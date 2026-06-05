import AppKit
import Combine
import Foundation

@MainActor
final class ArchiveStore: ObservableObject {
    static let shared = ArchiveStore()

    private let archiveService = ArchiveService()
    private let purchaseManager = PurchaseManager.shared
    private var licenseCancellable: AnyCancellable?

    @Published var selectedArchiveURL: URL?
    @Published var entries: [ArchiveEntry] = []
    @Published var displayItems: [DisplayArchiveItem] = [] { didSet { refreshRiskData(); refreshDerivedContent() } }
    @Published var archiveSessions: [ArchiveSession] = [] { didSet { refreshRiskData(); refreshDerivedContent() } }
    @Published var selectedEntryID: ArchiveEntry.ID?
    @Published var searchText = "" { didSet { refreshDerivedContent() } }
    @Published var activeFilter: ArchiveFilter = .allItems { didSet { refreshDerivedContent() } }
    @Published var activeArchiveSessionID: UUID? { didSet { refreshRiskData(); refreshDerivedContent() } }
    @Published var selectedArchiveFilterID: UUID?
    @Published var isLoading = false
    @Published var isExtracting = false
    @Published var isDropTargeted = false
    @Published var loadState: ArchiveLoadState = .empty
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    @Published var previewState: PreviewState = .empty
    @Published var previewImage: NSImage?
    @Published var previewText: String?
    @Published var recentlyViewedPaths: [String] = []
    @Published var isPro = LicenseManager.shared.isPro { didSet { refreshDerivedContent() } }
    @Published var activeProPaywallState: ProPaywallState?
    @Published var passwordPromptState: PasswordPromptState?
    @Published var customTypeRequest: CustomTypeRequest?
    @Published var isShowingSettings = false
    @Published var showRiskyExtractConfirmation = false
    @Published var riskyArchiveCount = 0
    @Published var riskyFileCount = 0
    @Published var largeArchiveShowingCount = 0
    @Published var largeArchiveTotalCount = 0
    @Published var pendingPasswordArchivePassword: String?
    @Published var pendingPasswordSessionID: UUID?
    @Published private(set) var riskFindings: [RiskFinding] = []
    @Published private(set) var riskyFindings: [RiskFinding] = []
    @Published private(set) var hiddenJunkFindings: [RiskFinding] = []
    @Published private(set) var riskFindingByItemID: [String: RiskFinding] = [:]
    @Published private(set) var visibleDisplayItemsCache: [DisplayArchiveItem] = []
    @Published private(set) var filterCountsCache: [ArchiveFilter: Int] = [:]

    private var loadTask: Task<Void, Never>?
    private var previewTask: Task<Void, Never>?
    private var toastTask: Task<Void, Never>?
    private var settingsTask: Task<Void, Never>?
    private var archivePasswords: [String: String] = [:]

    init() {
        licenseCancellable = LicenseManager.shared.objectWillChange.sink { [weak self] _ in
            guard let self else { return }
            self.isPro = LicenseManager.shared.isPro
            if !self.isPro && self.activeFilter == .riskyFiles {
                self.activeFilter = .allItems
            }
            self.refreshDerivedContent()
        }
    }

    var selectedArchivePath: String? {
        selectedArchiveURL?.path
    }

    var selectedArchiveName: String {
        if isMultiArchiveMode {
            return "\(archiveSessions.count) \(L10n.string(.archiveArchivesGroupTitle)) \(L10n.string(.archiveArchivesOpen))"
        }
        guard let selectedArchiveURL else {
            return L10n.string(.archiveNoArchiveSelected)
        }
        return selectedArchiveURL.lastPathComponent
    }

    var isMultiArchiveMode: Bool {
        archiveSessions.count > 1
    }

    var archiveFilterSessions: [ArchiveSession] {
        archiveSessions
    }

    var availableFilters: [ArchiveFilter] {
        ArchiveFilter.allCases
    }

    var activeSession: ArchiveSession? {
        if let activeArchiveSessionID, let session = archiveSessions.first(where: { $0.id == activeArchiveSessionID }) {
            return session
        }
        return archiveSessions.first
    }

    var activeSessionItems: [ArchiveEntry] {
        activeSession?.items ?? entries
    }

    var activeSessionTotalCount: Int {
        activeSession?.itemCount ?? entries.count
    }

    var activeSessionShowingCount: Int {
        visibleDisplayItemsCache.count
    }

    var archiveTypeLabel: String {
        if isMultiArchiveMode {
            return L10n.string(.archiveTypeMulti)
        }
        if let format = loadState.detectedFormat, format != .unknown {
            return displayFormatLabel(for: format)
        }
        if let selectedArchiveURL {
            return archiveFormatLabel(from: selectedArchiveURL.lastPathComponent)
        }
        return L10n.string(.archiveTypeArchive)
    }

    var statusText: String {
        if isLoading {
            return L10n.string(.statusInspectingShort)
        }
        switch loadState {
        case .loaded:
            return selectedEntryID == nil ? L10n.string(.toolbarArchiveLoaded) : L10n.string(.statusInspectingShort)
        case .dependencyRequired, .passwordProtected, .unsupported, .error:
            return L10n.string(.toolbarNeedsAttention)
        case .loading:
            return L10n.string(.statusInspectingShort)
        case .empty:
            return L10n.string(.statusReadyShort)
        }
    }

    var hasArchiveLoaded: Bool {
        !archiveSessions.isEmpty || selectedArchiveURL != nil
    }

    var totalSize: Int64 {
        loadState.totalSize ?? entries.reduce(0) { $0 + max($1.size, 0) }
    }

    var totalSizeLabel: String {
        if let totalSize = loadState.totalSize {
            return ByteCountFormatter.string(fromByteCount: totalSize, countStyle: .file)
        }

        if hasArchiveLoaded {
            return L10n.string(.statSizeUnknown)
        }

        return "—"
    }

    var fileCount: Int {
        loadState.stats?.fileCount ?? activeSessionItems.filter { !$0.isDirectory }.count
    }

    var folderCount: Int {
        loadState.stats?.folderCount ?? activeSessionItems.filter(\.isDirectory).count
    }

    var imageCount: Int {
        loadState.stats?.imageCount ?? activeSessionItems.filter { $0.kind == .image }.count
    }

    var documentCount: Int {
        loadState.stats?.documentCount ?? activeSessionItems.filter { $0.kind == .document || $0.kind == .text }.count
    }

    var codeCount: Int {
        loadState.stats?.codeCount ?? activeSessionItems.filter { $0.kind == .code }.count
    }

    var videoCount: Int {
        loadState.stats?.videoCount ?? activeSessionItems.filter { $0.kind == .video }.count
    }

    var archiveCount: Int {
        loadState.stats?.archiveCount ?? activeSessionItems.filter { $0.kind == .archive }.count
    }

    var largeFileCount: Int {
        loadState.stats?.largeFileCount ?? activeSessionItems.filter { $0.kind == .largeFile }.count
    }

    var riskyFileCountValue: Int {
        riskyFindings.count
    }

    var hiddenJunkCount: Int {
        hiddenJunkFindings.count
    }

    var selectedItemCount: Int {
        selectedEntryID == nil ? 0 : 1
    }

    var archiveItemCount: Int {
        activeSessionItems.filter { Self.isRenderableArchiveEntry($0) }.count
    }

    var showingItemCount: Int {
        visibleDisplayItems.count
    }

    var canExtractSelected: Bool {
        guard case .loaded(let loaded) = loadState else {
            return false
        }
        if let selectedDisplayItem,
           let session = archiveSessions.first(where: { $0.id == selectedDisplayItem.archiveSessionId }) {
            return archiveService.supportsSelectedExtraction(for: session.detectedFormat)
        }
        return archiveService.supportsSelectedExtraction(for: loaded.detectedFormat)
    }

    var canExtractAll: Bool {
        if case .loaded = loadState {
            return true
        }
        return false
    }

    var visibleEntries: [ArchiveEntry] {
        visibleDisplayItemsCache.map(\.originalArchiveItem)
    }

    var visibleDisplayItems: [DisplayArchiveItem] {
        visibleDisplayItemsCache
    }

    func filterCount(for filter: ArchiveFilter) -> Int {
        if filter == .riskyFiles {
            return riskyFileCountValue
        }
        return filterCountsCache[filter] ?? 0
    }

    func riskFinding(for entry: ArchiveEntry) -> RiskFinding? {
        riskFindingByItemID[entry.id.uuidString] ?? riskFindings.first(where: { $0.path == entry.path })
    }

    private func filteredDisplayItemsForIndexing() -> [DisplayArchiveItem] {
        let baseItems: [DisplayArchiveItem]
        if let activeArchiveSessionID {
            baseItems = displayItems.filter { $0.archiveSessionId == activeArchiveSessionID }
        } else {
            baseItems = displayItems
        }

        guard !isPro else {
            return baseItems
        }

        if baseItems.count > 200 {
            return Array(baseItems.prefix(200))
        }
        return baseItems
    }

    private func refreshDerivedContent() {
        let search = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let source = filteredDisplayItemsForIndexing().filter(Self.isRenderableDisplayItem)

        filterCountsCache = ArchiveFilter.allCases.reduce(into: [:]) { result, filter in
            result[filter] = source.reduce(into: 0) { count, item in
                if matches(filter: filter, item: item) {
                    count += 1
                }
            }
        }

        visibleDisplayItemsCache = source.filter { item in
            guard matches(filter: activeFilter, item: item) else {
                return false
            }
            guard !search.isEmpty else {
                return true
            }
            return item.path.localizedCaseInsensitiveContains(search)
                || item.name.localizedCaseInsensitiveContains(search)
        }
    }

    private static func isRenderableDisplayItem(_ item: DisplayArchiveItem) -> Bool {
        let normalizedPath = item.originalArchiveItem.path.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedName = item.originalArchiveItem.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let rootLikeCharacters = CharacterSet(charactersIn: "/.")
        let isRootLikePath = !normalizedPath.isEmpty && normalizedPath.trimmingCharacters(in: rootLikeCharacters).isEmpty
        let isRootLikeName = !normalizedName.isEmpty && normalizedName.trimmingCharacters(in: rootLikeCharacters).isEmpty

        guard !normalizedPath.isEmpty, !normalizedName.isEmpty else { return false }
        guard !isRootLikePath, !isRootLikeName else { return false }
        return true
    }

    private static func isRenderableArchiveEntry(_ item: ArchiveEntry) -> Bool {
        let normalizedPath = item.path.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedName = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let rootLikeCharacters = CharacterSet(charactersIn: "/.")
        let isRootLikePath = !normalizedPath.isEmpty && normalizedPath.trimmingCharacters(in: rootLikeCharacters).isEmpty
        let isRootLikeName = !normalizedName.isEmpty && normalizedName.trimmingCharacters(in: rootLikeCharacters).isEmpty

        guard !normalizedPath.isEmpty, !normalizedName.isEmpty else { return false }
        guard !isRootLikePath, !isRootLikeName else { return false }
        return true
    }

    private func refreshRiskData() {
        let items = activeSessionItems
        let findings = RiskScanner.scan(items: items)
        riskFindings = findings
        riskyFindings = findings.filter { $0.riskLevel == .high || $0.riskLevel == .medium }
        hiddenJunkFindings = findings.filter { $0.riskLevel == .notice }
        riskFindingByItemID = Dictionary(uniqueKeysWithValues: findings.map { ($0.itemId, $0) })
        riskyFileCount = riskyFindings.count
        largeArchiveShowingCount = showingItemCount
        largeArchiveTotalCount = archiveItemCount
    }

    private func matches(filter: ArchiveFilter, item: DisplayArchiveItem) -> Bool {
        switch filter {
        case .riskyFiles:
            guard isPro else { return false }
            return riskFinding(for: item.originalArchiveItem)?.riskLevel == .high
                || riskFinding(for: item.originalArchiveItem)?.riskLevel == .medium
        case .hiddenJunkFiles:
            return riskFinding(for: item.originalArchiveItem)?.riskLevel == .notice
                || item.originalArchiveItem.isHiddenOrJunk
        default:
            return item.originalArchiveItem.matches(filter)
        }
    }

    var summaryText: String {
        guard hasArchiveLoaded else {
            return L10n.string(.archiveSummaryText)
        }

        if isMultiArchiveMode {
            return "\(archiveSessions.count) \(L10n.string(.archiveArchivesGroupTitle).lowercased()) \(L10n.string(.archiveArchivesOpen)) · \(showingItemCount) \(L10n.string(.archiveShowingSuffix))"
        }

        return loadState.stats?.summaryDescription ?? "\(fileCount) files · \(folderCount) folders · \(totalSizeLabel)"
    }

    var archiveSafetySummary: String {
        guard hasArchiveLoaded else {
            return L10n.string(.archiveEmptyHeroTitle)
        }

        if riskyFileCountValue > 0 {
            return String(format: L10n.string(.archiveSafetyRiskyFound), locale: .current, arguments: [riskyFileCountValue])
        }

        if isPro {
            return L10n.string(.archiveSafetyNoRiskyDetected)
        }

        return L10n.string(.archiveSafetyNothingExtracted)
    }

    var archiveLimitSubtitle: String {
        if shouldShowLargeArchiveBanner {
            return String(format: L10n.string(.archiveFreePreviewIndexing), locale: .current, arguments: [archiveItemCount])
        }
        return L10n.string(.archiveContentsSubtitleDefault)
    }

    var selectionSummaryText: String {
        if selectedItemCount > 0 {
            return String(format: L10n.string(.archiveSelectedSummary), locale: .current, arguments: [selectedItemCount])
        }
        return L10n.string(.archiveNoFileSelected)
    }

    var archiveFlavorLabel: String {
        guard hasArchiveLoaded else { return L10n.string(.archiveTypeArchive) }

        let imageOrDocumentOrVideoMax = max(imageCount, max(documentCount, videoCount))
        let codeOrDocumentOrImageMax = max(codeCount, max(documentCount, imageCount))

        if codeCount >= imageOrDocumentOrVideoMax && codeCount > 0 {
            return L10n.string(.archiveFlavorCodeCompact)
        }
        if imageCount >= max(codeCount, max(documentCount, videoCount)) && imageCount > 0 {
            return L10n.string(.archiveFlavorImageCompact)
        }
        if documentCount >= codeOrDocumentOrImageMax && documentCount > 0 {
            return L10n.string(.archiveFlavorDocumentCompact)
        }
        if videoCount >= max(codeCount, max(imageCount, documentCount)) && videoCount > 0 {
            return L10n.string(.archiveFlavorVideoCompact)
        }
        if let format = loadState.detectedFormat, format.isSingleFileCompression {
            return L10n.string(.archiveFlavorSingleFileCompact)
        }
        if archiveItemCount <= 1 && folderCount == 0 {
            return L10n.string(.archiveFlavorSingleFileCompact)
        }
        return L10n.string(.archiveFlavorMixedCompact)
    }

    var archiveContentsSubtitle: String {
        if isLoading {
            return L10n.string(.archiveReadingTitle)
        }
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return String(
                format: L10n.string(.archiveShowingResultsFor),
                visibleEntries.count,
                searchText.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
            )
        }
        if shouldShowLargeArchiveBanner {
            return String(format: L10n.string(.archiveFreePreviewIndexing), locale: .current, arguments: [archiveItemCount])
        }
        return L10n.string(.archiveContentsSubtitleDefault)
    }

    var shouldShowLargeArchiveBanner: Bool {
        !isPro && archiveItemCount > 200
    }

    var largeArchiveBannerMessage: String {
        String(format: L10n.string(.archiveLargeArchiveDetected), locale: .current, arguments: [archiveItemCount])
    }

    var showingOfTotalText: String {
        String(format: L10n.string(.archiveShowingOfTotalPrefix), locale: .current, arguments: [min(activeSessionShowingCount, 200), archiveItemCount])
    }

    var shouldShowRiskBanner: Bool {
        isPro && riskyFileCountValue > 0
    }

    var riskBannerMessage: String {
        "\(riskyFileCountValue) risky files found. Review before extracting."
    }

    var safetyNote: String {
        L10n.string(.archiveSafetyNothingExtracted)
    }

    var selectedEntry: ArchiveEntry? {
        guard let selectedEntryID else {
            return nil
        }
        return selectedDisplayItem?.originalArchiveItem
            ?? activeSessionItems.first(where: { $0.id == selectedEntryID })
    }

    var selectedDisplayItem: DisplayArchiveItem? {
        guard let selectedEntryID else { return nil }
        return displayItems.first(where: { $0.id == selectedEntryID })
    }

    var selectedEntryIndex: Int? {
        guard let selectedEntry else { return nil }
        return visibleEntries.firstIndex(where: { $0.id == selectedEntry.id })
    }

    func loadArchive(url: URL) {
        loadArchive(url: url, password: archivePasswords[url.path])
    }

    func loadArchive(url: URL, password: String?) {
        loadArchives(urls: [url], password: password)
    }

    func loadArchives(urls: [URL], password: String? = nil) {
        guard !urls.isEmpty else { return }

        if urls.count > 1 && !LicenseManager.shared.requirePro(feature: .multiArchiveSearch) {
            activeProPaywallState = ProPaywallState(feature: .multiArchiveSearch)
            AppEventLogger.log("multi_archive_attempted")
            return
        }

        loadTask?.cancel()
        previewTask?.cancel()
        selectedArchiveURL = urls.first
        selectedEntryID = nil
        entries = []
        displayItems = []
        archiveSessions = []
        activeArchiveSessionID = nil
        errorMessage = nil
        toastMessage = nil
        previewState = .empty
        previewImage = nil
        previewText = nil
        searchText = ""
        activeFilter = .allItems
        isLoading = true
        loadState = .loading(archiveName: urls.first?.lastPathComponent)
        AppEventLogger.log("archive_opened", metadata: ["count": "\(urls.count)"])

        let service = archiveService
        let archiveURLs = urls
        loadTask = Task.detached(priority: .userInitiated) {
            if archiveURLs.count == 1 {
                let selectedURL = archiveURLs[0]
                let rememberedPassword = await MainActor.run { self.archivePasswords[selectedURL.path] }
                let passwordToUse = password ?? rememberedPassword
                let state = await service.loadArchive(url: selectedURL, password: passwordToUse)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.apply(loadState: state)
                }
                return
            }

            var sessions: [ArchiveSession] = []
            for url in archiveURLs {
                let state = await service.loadArchive(url: url)
                guard !Task.isCancelled else { return }
                switch state {
                case .loaded(let loaded):
                    sessions.append(
                        ArchiveSession(
                            archiveURL: loaded.archiveURL,
                            archiveName: loaded.archiveName,
                            detectedFormat: loaded.detectedFormat,
                            items: loaded.entries,
                            isPasswordProtected: false,
                            totalSize: loaded.totalSize,
                            riskyCount: loaded.stats.riskyCount
                        )
                    )
                case .passwordProtected, .dependencyRequired, .unsupported, .error:
                    await MainActor.run {
                        self.apply(loadState: state)
                    }
                    return
                case .empty, .loading:
                    continue
                }
            }

            guard !Task.isCancelled else { return }
            let resolvedSessions = sessions
            await MainActor.run {
                self.apply(multiSessions: resolvedSessions)
            }
        }
    }

    func reloadArchive() {
        guard let selectedArchiveURL else { return }
        loadArchive(url: selectedArchiveURL)
    }

    private func apply(loadState newState: ArchiveLoadState) {
        loadState = newState
        isLoading = false
        previewState = .empty
        previewImage = nil
        previewText = nil
        archiveSessions = []
        displayItems = []
        activeArchiveSessionID = nil

        switch newState {
        case .loaded(let loaded):
            let session = ArchiveSession(
                archiveURL: loaded.archiveURL,
                archiveName: loaded.archiveName,
                detectedFormat: loaded.detectedFormat,
                items: loaded.entries,
                isPasswordProtected: false,
                totalSize: loaded.totalSize,
                riskyCount: loaded.stats.riskyCount
            )
            entries = loaded.entries
            displayItems = loaded.entries.map { DisplayArchiveItem(archiveSessionId: session.id, archiveName: session.archiveName, originalArchiveItem: $0) }
            errorMessage = nil
            if loaded.entries.isEmpty {
                toastMessage = L10n.string(.archiveToastArchiveEmpty)
                scheduleToastClear()
            }
            archiveSessions = [session]
            activeArchiveSessionID = session.id
            selectedArchiveURL = loaded.archiveURL
            refreshRiskData()
            refreshDerivedContent()
        case .unsupported, .dependencyRequired, .error:
            entries = []
            errorMessage = newState.message
            selectedEntryID = nil
        case .passwordProtected(let state):
            entries = []
            selectedEntryID = nil
            errorMessage = nil
            if isPro {
                passwordPromptState = PasswordPromptState(
                    archiveSessionID: nil,
                    archiveName: state.archiveName,
                    detectedFormat: state.detectedFormat,
                    message: state.message
                )
            } else {
                activeProPaywallState = ProPaywallState(
                    feature: .passwordArchive
                )
            }
        case .loading, .empty:
            break
        }
    }

    private func apply(multiSessions sessions: [ArchiveSession]) {
        archiveSessions = sessions
        activeArchiveSessionID = sessions.first?.id
        selectedArchiveURL = sessions.first?.archiveURL
        entries = sessions.first?.items ?? []
        displayItems = sessions.flatMap { session in
            session.items.map { DisplayArchiveItem(archiveSessionId: session.id, archiveName: session.archiveName, originalArchiveItem: $0) }
        }
        selectedEntryID = nil
        loadState = sessions.first.map {
            .loaded(
                LoadedArchiveState(
                    archiveURL: $0.archiveURL,
                    archiveName: $0.archiveName,
                    detectedFormat: $0.detectedFormat,
                    entries: $0.items,
                    stats: Self.computeStats(entries: $0.items),
                    totalSize: $0.totalSize
                )
            )
        } ?? .empty
        isLoading = false
        errorMessage = nil
        if sessions.isEmpty {
            toastMessage = L10n.string(.archiveToastNoArchivesOpened)
            scheduleToastClear()
        }
        refreshRiskData()
        refreshDerivedContent()
    }

    func select(entry: ArchiveEntry) {
        guard let displayItem = displayItems.first(where: { $0.id == entry.id }) else {
            selectedEntryID = entry.id
            loadPreview(for: entry)
            return
        }

        activeArchiveSessionID = displayItem.archiveSessionId
        selectedArchiveURL = archiveSessions.first(where: { $0.id == displayItem.archiveSessionId })?.archiveURL ?? selectedArchiveURL
        selectedEntryID = displayItem.id
        if let index = recentlyViewedPaths.firstIndex(of: entry.path) {
            recentlyViewedPaths.remove(at: index)
        }
        recentlyViewedPaths.insert(entry.path, at: 0)
        recentlyViewedPaths = Array(recentlyViewedPaths.prefix(8))
        loadPreview(for: entry)
    }

    func clearSelection() {
        selectedEntryID = nil
        previewState = .empty
        previewImage = nil
        previewText = nil
    }

    func loadArchiveFromDrop(url: URL) {
        loadArchive(url: url)
    }

    func selectArchiveSession(_ sessionID: UUID?) {
        previewTask?.cancel()
        selectedEntryID = nil
        previewState = .empty
        previewImage = nil
        previewText = nil
        if let sessionID, let session = archiveSessions.first(where: { $0.id == sessionID }) {
            selectedArchiveURL = session.archiveURL
            entries = session.items
        } else {
            selectedArchiveURL = archiveSessions.first?.archiveURL
            entries = archiveSessions.first?.items ?? []
        }
        activeArchiveSessionID = sessionID
        refreshRiskData()
        refreshDerivedContent()
    }

    func presentPaywall(feature: ProFeature) {
        activeProPaywallState = ProPaywallState(feature: feature)
        AppEventLogger.log("pro_paywall_shown", metadata: ["feature": feature.rawValue])
    }

    func handleProUnlockRequest() async {
        AppEventLogger.log("pro_unlock_clicked")

        do {
            let outcome = try await purchaseManager.purchasePro()

            switch outcome {
            case .success:
                AppEventLogger.iap("purchase flow completed: success")
                activeProPaywallState = nil
                showToast(L10n.string(.paywallPurchaseSucceeded))
            case .pending:
                AppEventLogger.iap("purchase flow completed: pending")
                showToast(L10n.string(.paywallPurchasePending))
            case .cancelled:
                AppEventLogger.iap("purchase flow completed: cancelled")
                break
            }
        } catch {
            AppEventLogger.iap("purchase failed: \(error.localizedDescription)")
            showToast(error.localizedDescription)
        }
    }

    func restorePurchases() async {
        do {
            let restored = try await purchaseManager.restorePurchases()
            if restored {
                AppEventLogger.iap("restore flow completed: restored")
                activeProPaywallState = nil
                showToast(L10n.string(.paywallRestoreSucceeded))
            } else {
                AppEventLogger.iap("restore flow completed: nothing found")
                showToast(L10n.string(.paywallRestoreNothingFound))
            }
        } catch {
            AppEventLogger.iap("restore failed: \(error.localizedDescription)")
            showToast(error.localizedDescription)
        }
    }

    func continueFreeFromPaywall() {
        activeProPaywallState = nil
    }

    func dismissPasswordPrompt() {
        passwordPromptState = nil
    }

    func submitPassword(_ password: String, rememberForSession: Bool) {
        guard let archiveURL = selectedArchiveURL else { return }
        if rememberForSession {
            archivePasswords[archiveURL.path] = password
        }
        passwordPromptState = nil
        loadArchive(url: archiveURL, password: password)
    }

    func showPasswordPrompt(for state: PasswordProtectedArchiveState) {
        passwordPromptState = PasswordPromptState(
            archiveSessionID: activeArchiveSessionID,
            archiveName: state.archiveName,
            detectedFormat: state.detectedFormat,
            message: state.message
        )
    }

    func showRiskyFiles() {
        activeFilter = .riskyFiles
    }

    func confirmRiskyExtract() {
        showRiskyExtractConfirmation = false
        extractAll(force: true)
    }

    func reviewRiskyFiles() {
        showRiskyExtractConfirmation = false
        activeFilter = .riskyFiles
    }

    func scanRiskyFiles() {
        guard hasArchiveLoaded else { return }
        if LicenseManager.shared.requirePro(feature: .riskFileDetection) {
            if riskyFindings.isEmpty {
                showToast(L10n.string(.archiveToastNoRiskyFiles))
            } else {
                activeFilter = .riskyFiles
            }
        } else {
            presentPaywall(feature: .riskFileDetection)
        }
        AppEventLogger.log("risk_scan_clicked")
    }

    func requestBatchExtract(type: ArchiveBatchType) {
        guard LicenseManager.shared.requirePro(feature: .batchExtractByType) else {
            presentPaywall(feature: .batchExtractByType)
            return
        }

        batchExtract(type: type)
    }

    func requestCustomBatchExtract(extensions: Set<String>) {
        guard LicenseManager.shared.requirePro(feature: .batchExtractByType) else {
            presentPaywall(feature: .batchExtractByType)
            return
        }

        batchExtract(customExtensions: extensions)
    }

    func extractAll(force: Bool = false) {
        guard canExtractAll, let session = activeSession else { return }
        if LicenseManager.shared.isPro, !force, !riskyFindings.isEmpty {
            riskyArchiveCount = riskyFindings.count
            showRiskyExtractConfirmation = true
            return
        }
        guard let destination = chooseExtractionDestination(prompt: L10n.string(.archiveExtractArchivePrompt)) else { return }

        isExtracting = true
        toastMessage = nil

        let service = archiveService
        let skipJunkFiles = AppPreferences.shared.skipJunkFilesOnExtract
        Task.detached(priority: .userInitiated) {
            do {
                try await service.extractAll(
                    from: session.archiveURL,
                    to: destination,
                    password: session.password,
                    skipJunkFiles: skipJunkFiles
                )
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.isExtracting = false
                    self.showToast(L10n.string(.archiveToastExtractedSuccessfully))
                    NSWorkspace.shared.open(destination)
                }
            } catch let failure as ArchiveParserFailure {
                await MainActor.run {
                    self.isExtracting = false
                    if case .failedToRead(let message, _) = failure, message.contains("Unsafe archive paths detected") {
                        self.showToast(message)
                    } else {
                        self.showToast(L10n.string(.archiveToastExtractionFailed))
                    }
                }
            } catch {
                await MainActor.run {
                    self.isExtracting = false
                    self.showToast(L10n.string(.archiveToastExtractionFailed))
                }
            }
        }
    }

    func extractSelected(revealAfterExtract: Bool = false) {
        guard canExtractSelected, let selectedDisplayItem, let selectedEntry else { return }
        let session = archiveSessions.first(where: { $0.id == selectedDisplayItem.archiveSessionId }) ?? activeSession
        guard let session else { return }
        guard let destination = chooseExtractionDestination(prompt: L10n.string(.archiveExtractSelectedItemPrompt)) else { return }

        isExtracting = true
        toastMessage = nil

        let service = archiveService
        let currentEntries = session.items
        let selectedPath = selectedEntry.path
        let skipJunkFiles = AppPreferences.shared.skipJunkFilesOnExtract

        Task.detached(priority: .userInitiated) {
            do {
                try await service.extractSelected(
                    from: session.archiveURL,
                    to: destination,
                    selectedEntries: [selectedEntry],
                    allEntries: currentEntries,
                    password: session.password,
                    skipJunkFiles: skipJunkFiles
                )
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.isExtracting = false
                    self.showToast(L10n.string(.archiveToastExtractedSuccessfully))
                    if revealAfterExtract {
                        let outputURL = destination.appendingPathComponent(selectedPath)
                        NSWorkspace.shared.activateFileViewerSelecting([outputURL])
                    }
                }
            } catch let failure as ArchiveParserFailure {
                await MainActor.run {
                    self.isExtracting = false
                    if case .failedToRead(let message, _) = failure, message.contains("Unsafe archive paths detected") {
                        self.showToast(message)
                    } else {
                        self.showToast(L10n.string(.archiveToastExtractionFailed))
                    }
                }
            } catch {
                await MainActor.run {
                    self.isExtracting = false
                    self.showToast(L10n.string(.archiveToastExtractionFailed))
                }
            }
        }
    }

    func batchExtract(type: ArchiveBatchType) {
        let filteredItems = batchItems(matching: type)
        guard !filteredItems.isEmpty else {
            showToast(L10n.string(.archiveToastNoMatchingFiles))
            return
        }

        performBatchExtract(items: filteredItems, title: String(format: L10n.string(.archiveBatchExtractTitle), type.title))
    }

    func batchExtract(customExtensions: Set<String>) {
        let normalized = Set(customExtensions.map { $0.lowercased() })
        let filteredItems = batchItems { item in
            guard !item.isDirectory else { return false }
            return normalized.contains(item.originalArchiveItem.fileExtension.lowercased())
        }

        guard !filteredItems.isEmpty else {
            showToast(L10n.string(.archiveToastNoMatchingFiles))
            return
        }

        performBatchExtract(items: filteredItems, title: L10n.string(.archiveBatchExtractCustomTitle))
    }

    private func batchItems(matching type: ArchiveBatchType) -> [DisplayArchiveItem] {
        batchItems { item in
            type.matches(item.originalArchiveItem)
        }
    }

    private func batchItems(_ predicate: (DisplayArchiveItem) -> Bool) -> [DisplayArchiveItem] {
        visibleDisplayItems.filter(predicate)
    }

    private func performBatchExtract(items: [DisplayArchiveItem], title: String) {
        guard let destination = chooseExtractionDestination(prompt: title) else { return }

        isExtracting = true
        toastMessage = nil
        AppEventLogger.log("batch_extract_clicked", metadata: ["title": title])

        let service = archiveService
        let skipJunkFiles = AppPreferences.shared.skipJunkFilesOnExtract
        let groups = Dictionary(grouping: items, by: { $0.archiveSessionId })

        Task.detached(priority: .userInitiated) {
            do {
                for (sessionID, groupItems) in groups {
                    let session = await MainActor.run {
                        self.archiveSessions.first(where: { $0.id == sessionID })
                    }
                    guard let session else {
                        continue
                    }

                    let outputURL = groups.count > 1
                        ? destination.appendingPathComponent(session.archiveName, isDirectory: true)
                        : destination

                    try await service.extractSelected(
                        from: session.archiveURL,
                        to: outputURL,
                        selectedEntries: groupItems.map { $0.originalArchiveItem },
                        allEntries: session.items,
                        password: session.password,
                        skipJunkFiles: skipJunkFiles
                    )
                }

                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.isExtracting = false
                    self.showToast(L10n.string(.archiveToastExtractedSuccessfully))
                    NSWorkspace.shared.open(destination)
                }
            } catch {
                await MainActor.run {
                    self.isExtracting = false
                    self.showToast(L10n.string(.archiveToastExtractionFailed))
                }
            }
        }
    }

    func copySelectedFileName() {
        guard let selectedEntry else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(selectedEntry.name, forType: .string)
        showToast(L10n.string(.archiveToastFileNameCopied))
    }

    func copySelectedPath() {
        guard let selectedEntry else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(selectedEntry.path, forType: .string)
        showToast(L10n.string(.archiveToastPathCopied))
    }

    private func loadPreview(for entry: ArchiveEntry) {
        previewTask?.cancel()
        previewImage = nil
        previewText = nil
        previewState = .loading

        guard let archiveURL = selectedArchiveURL else {
            previewState = .empty
            return
        }

        let password = selectedDisplayItem.flatMap { displayItem in
            archiveSessions.first(where: { $0.id == displayItem.archiveSessionId })?.password
        }

        let service = archiveService
        previewTask = Task.detached(priority: .userInitiated) {
            let content = await service.preview(from: archiveURL, entry: entry, password: password)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                switch content {
                case .empty:
                    self.previewState = .empty
                    self.previewImage = nil
                    self.previewText = nil
                case .imageData(let data):
                    self.previewState = .ready
                    self.previewImage = NSImage(data: data)
                    self.previewText = nil
                case .text(let text):
                    self.previewState = .ready
                    self.previewText = text
                    self.previewImage = nil
                }
            }
        }
    }

    private func chooseExtractionDestination(prompt: String) -> URL? {
        let panel = NSOpenPanel()
        panel.title = prompt
        panel.message = L10n.string(.archiveChooseDestinationFolderMessage)
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = AppPreferences.shared.defaultExtractLocationURL
        guard panel.runModal() == .OK else {
            return nil
        }
        return panel.url
    }

    func showToast(_ message: String) {
        toastMessage = message
        scheduleToastClear()
    }

    private func scheduleToastClear() {
        toastTask?.cancel()
        toastTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            if !Task.isCancelled {
                toastMessage = nil
            }
        }
    }

    private static func computeStats(entries: [ArchiveEntry]) -> ArchiveStats {
        let files = entries.filter { !$0.isDirectory }
        let folders = entries.filter(\.isDirectory)
        return ArchiveStats(
            fileCount: files.count,
            folderCount: folders.count,
            imageCount: entries.filter { $0.kind == .image }.count,
            documentCount: entries.filter { $0.kind == .document || $0.kind == .text }.count,
            codeCount: entries.filter { $0.kind == .code }.count,
            videoCount: entries.filter { $0.kind == .video }.count,
            archiveCount: entries.filter { $0.kind == .archive }.count,
            executableCount: entries.filter { $0.kind == .executable }.count,
            largeFileCount: entries.filter { $0.kind == .largeFile }.count,
            riskyCount: entries.filter(\.isRisky).count,
            unknownSizeCount: entries.filter { $0.size < 0 }.count,
            totalSize: entries.reduce(into: Int64(0)) { result, entry in
                if entry.size > 0 {
                    result += entry.size
                }
            }
        )
    }
}

enum ArchiveFilter: String, CaseIterable, Identifiable {
    case allItems
    case folders
    case images
    case documents
    case code
    case videos
    case archives
    case largeFiles
    case recentlyViewed
    case riskyFiles
    case hiddenJunkFiles

    var id: String { rawValue }

    var title: String {
        switch self {
        case .allItems: return L10n.string(.filterAllItems)
        case .folders: return L10n.string(.filterFolders)
        case .images: return L10n.string(.filterImages)
        case .documents: return L10n.string(.filterDocuments)
        case .code: return L10n.string(.filterCode)
        case .videos: return L10n.string(.filterVideos)
        case .archives: return L10n.string(.filterArchives)
        case .largeFiles: return L10n.string(.filterLargeFiles)
        case .recentlyViewed: return L10n.string(.filterRecentlyViewed)
        case .riskyFiles: return L10n.string(.filterRiskyFiles)
        case .hiddenJunkFiles: return L10n.string(.filterHiddenJunkFiles)
        }
    }

    var symbolName: String {
        switch self {
        case .allItems: return "square.grid.2x2"
        case .folders: return "folder"
        case .images: return "photo"
        case .documents: return "doc"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .videos: return "video"
        case .archives: return "archivebox"
        case .largeFiles: return "externaldrive"
        case .recentlyViewed: return "clock"
        case .riskyFiles: return "exclamationmark.triangle"
        case .hiddenJunkFiles: return "sparkles"
        }
    }

    var requiresPro: Bool {
        switch self {
        case .riskyFiles:
            return true
        default:
            return false
        }
    }
}

enum PreviewState {
    case empty
    case loading
    case ready
}

extension ArchiveEntry {
    @MainActor
    func matches(_ filter: ArchiveFilter) -> Bool {
        switch filter {
        case .allItems:
            return true
        case .folders:
            return isDirectory
        case .images:
            return kind == .image
        case .documents:
            return kind == .document || kind == .text
        case .code:
            return kind == .code
        case .videos:
            return kind == .video
        case .archives:
            return kind == .archive
        case .largeFiles:
            return !isDirectory && size >= 1_048_576
        case .recentlyViewed:
            return ArchiveStore.shared.recentlyViewedPaths.contains(path)
        case .riskyFiles:
            return isRisky
        case .hiddenJunkFiles:
            return isHiddenOrJunk
        }
    }
}
