import AppKit
import Foundation
import StoreKit
import SwiftUI

typealias ArchiveRiskLevel = RiskLevel

enum ProFeature: String, CaseIterable, Identifiable, Hashable, Sendable {
    case multiArchiveSearch
    case fullLargeArchiveIndex
    case passwordArchive
    case batchExtractByType
    case riskFileDetection

    var id: String { rawValue }
}

final class LicenseManager: ObservableObject {
    static let shared = LicenseManager()

    private enum Keys {
        static let isProUnlocked = "PeekZip.isProUnlocked"
        static let proUnlockedAt = "PeekZip.proUnlockedAt"
    }

    @Published private(set) var isProUnlocked: Bool {
        didSet {
            UserDefaults.standard.set(isProUnlocked, forKey: Keys.isProUnlocked)
        }
    }

    @Published private(set) var proUnlockedAt: Date? {
        didSet {
            UserDefaults.standard.set(proUnlockedAt, forKey: Keys.proUnlockedAt)
        }
    }

    var isPro: Bool { isProUnlocked }

    private init() {
        let defaults = UserDefaults.standard
        self.isProUnlocked = defaults.bool(forKey: Keys.isProUnlocked)
        self.proUnlockedAt = defaults.object(forKey: Keys.proUnlockedAt) as? Date
    }

    func requirePro(feature: ProFeature) -> Bool {
        switch feature {
        case .multiArchiveSearch, .fullLargeArchiveIndex, .passwordArchive, .batchExtractByType, .riskFileDetection:
            return isPro
        }
    }

    func applyStoreEntitlement(isUnlocked: Bool, unlockedAt: Date?) {
        isProUnlocked = isUnlocked
        proUnlockedAt = isUnlocked ? unlockedAt : nil
    }
}

@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    enum PurchaseOutcome {
        case success
        case pending
        case cancelled
    }

    enum PurchaseError: LocalizedError {
        case productUnavailable
        case verificationFailed

        var errorDescription: String? {
            switch self {
            case .productUnavailable:
                return L10n.string(.paywallPurchaseUnavailable)
            case .verificationFailed:
                return L10n.string(.paywallPurchaseFailed)
            }
        }
    }

    private let productID = "com.youyujie.peekzip.pro"
    private var updatesTask: Task<Void, Never>?
    private var didConfigure = false

    @Published private(set) var proProduct: Product?
    @Published private(set) var didFinishProductLoad = false

    private init() { }

    deinit {
        updatesTask?.cancel()
    }

    func configureIfNeeded() {
        guard !didConfigure else { return }
        didConfigure = true
        AppEventLogger.iap("transaction listener started")

        updatesTask = Task { [weak self] in
            guard let self else { return }

            for await update in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(update)
                    AppEventLogger.iap("transaction update received: \(transaction.productID)")
                    if transaction.productID == self.productID {
                        await self.refreshEntitlements()
                    }
                    await transaction.finish()
                    AppEventLogger.iap("transaction finished")
                } catch {
                    AppEventLogger.iap("transaction update verification failed: \(error.localizedDescription)")
                    AppEventLogger.log("storekit_transaction_verification_failed")
                }
            }
        }

        Task {
            await loadProducts()
            await refreshEntitlements()
        }
    }

    func loadProducts() async {
        AppEventLogger.iap("loading products: \(productID)")
        do {
            let products = try await Product.products(for: [productID])
            AppEventLogger.iap("loaded products count: \(products.count)")
            for product in products {
                AppEventLogger.iap("product loaded: id=\(product.id), name=\(product.displayName), price=\(product.displayPrice)")
            }
            proProduct = products.first
            didFinishProductLoad = true
            if proProduct == nil {
                AppEventLogger.iap("product not found for id: \(productID)")
            }
        } catch {
            didFinishProductLoad = true
            AppEventLogger.iap("product load failed: \(error.localizedDescription)")
            AppEventLogger.log("storekit_products_failed", metadata: ["error": error.localizedDescription])
        }
    }

    func purchasePro() async throws -> PurchaseOutcome {
        if proProduct == nil {
            await loadProducts()
        }

        guard let product = proProduct else {
            AppEventLogger.iap("purchase failed: product not found")
            throw PurchaseError.productUnavailable
        }

        AppEventLogger.iap("purchase started")

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                AppEventLogger.iap("purchase result: success")
                let transaction = try checkVerified(verification)
                AppEventLogger.iap("verified transaction product id: \(transaction.productID)")
                if transaction.productID == productID {
                    await refreshEntitlements()
                }
                await transaction.finish()
                AppEventLogger.iap("transaction finished")
                return .success
            case .pending:
                AppEventLogger.iap("purchase result: pending")
                return .pending
            case .userCancelled:
                AppEventLogger.iap("purchase result: userCancelled")
                return .cancelled
            @unknown default:
                AppEventLogger.iap("purchase result: unknown")
                return .cancelled
            }
        } catch {
            AppEventLogger.iap("purchase failed: \(error.localizedDescription)")
            throw error
        }
    }

    func restorePurchases() async throws -> Bool {
        AppEventLogger.iap("AppStore.sync started")
        do {
            try await AppStore.sync()
            AppEventLogger.iap("AppStore.sync finished")
            let restored = await refreshEntitlements()
            AppEventLogger.iap(restored ? "restore result: restored" : "restore result: nothing found")
            return restored
        } catch {
            AppEventLogger.iap("restore failed: \(error.localizedDescription)")
            throw error
        }
    }

    @discardableResult
    func refreshEntitlements() async -> Bool {
        var unlockedAt: Date?

        for await entitlement in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(entitlement)
                AppEventLogger.iap("current entitlement: \(transaction.productID)")
                guard transaction.productID == productID else { continue }
                guard transaction.revocationDate == nil else { continue }

                if let current = unlockedAt {
                    unlockedAt = max(current, transaction.purchaseDate)
                } else {
                    unlockedAt = transaction.purchaseDate
                }
            } catch {
                AppEventLogger.iap("entitlement verification failed: \(error.localizedDescription)")
            }
        }

        let isUnlocked = unlockedAt != nil
        LicenseManager.shared.applyStoreEntitlement(isUnlocked: isUnlocked, unlockedAt: unlockedAt)
        AppEventLogger.iap("entitlement refresh result: isPro=\(isUnlocked)")
        return isUnlocked
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified:
            throw PurchaseError.verificationFailed
        }
    }
}

enum AppEventLogger {
    static func log(_ name: String, metadata: [String: String] = [:]) {
#if DEBUG
        if metadata.isEmpty {
            print("[PeekZip] event: \(name)")
        } else {
            print("[PeekZip] event: \(name) \(metadata)")
        }
#endif
    }

    static func iap(_ message: String) {
#if DEBUG
        print("[PeekZip][IAP] \(message)")
#endif
    }
}

struct ArchiveSession: Identifiable, Hashable, Sendable {
    let id: UUID
    let archiveURL: URL
    let archiveName: String
    let detectedFormat: ArchiveFormat
    let items: [ArchiveEntry]
    let isPasswordProtected: Bool
    let itemCount: Int
    let totalSize: Int64?
    let riskyCount: Int
    let password: String?

    init(
        id: UUID = UUID(),
        archiveURL: URL,
        archiveName: String,
        detectedFormat: ArchiveFormat,
        items: [ArchiveEntry],
        isPasswordProtected: Bool = false,
        totalSize: Int64? = nil,
        riskyCount: Int = 0,
        password: String? = nil
    ) {
        self.id = id
        self.archiveURL = archiveURL
        self.archiveName = archiveName
        self.detectedFormat = detectedFormat
        self.items = items
        self.isPasswordProtected = isPasswordProtected
        self.itemCount = items.count
        self.totalSize = totalSize
        self.riskyCount = riskyCount
        self.password = password
    }
}

struct DisplayArchiveItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let archiveSessionId: UUID
    let archiveName: String
    let originalArchiveItem: ArchiveEntry

    init(archiveSessionId: UUID, archiveName: String, originalArchiveItem: ArchiveEntry) {
        self.id = originalArchiveItem.id
        self.archiveSessionId = archiveSessionId
        self.archiveName = archiveName
        self.originalArchiveItem = originalArchiveItem
    }

    var name: String { originalArchiveItem.name }
    var path: String { originalArchiveItem.path }
    var size: Int64 { originalArchiveItem.size }
    var type: String { originalArchiveItem.kindLabel }
    var modifiedDate: Date? { originalArchiveItem.modifiedAt }
    var formattedSize: String { originalArchiveItem.formattedSize }
    var formattedModifiedDate: String { originalArchiveItem.formattedModifiedDate }
    var formattedCompressionMethod: String { originalArchiveItem.formattedCompressionMethod }
    var compressedSize: Int64? { originalArchiveItem.compressedSize }
    var kindLabel: String { originalArchiveItem.kindLabel }
    var kind: ArchiveFileKind { originalArchiveItem.kind }
    var isRisky: Bool { originalArchiveItem.isRisky }
    var isDirectory: Bool { originalArchiveItem.isDirectory }
    var displayPath: String { originalArchiveItem.displayPath }
}

enum ArchiveBatchType: String, CaseIterable, Identifiable, Sendable {
    case images
    case pdfs
    case videos
    case documents
    case code

    var id: String { rawValue }

    var title: String {
        L10n.batchTypeTitle(self)
    }

    var extensions: Set<String> {
        switch self {
        case .images:
            return ["jpg", "jpeg", "png", "gif", "webp", "heic", "tiff", "bmp", "svg"]
        case .pdfs:
            return ["pdf"]
        case .videos:
            return ["mp4", "mov", "avi", "mkv", "webm", "m4v"]
        case .documents:
            return ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "md", "rtf", "csv"]
        case .code:
            return ["swift", "js", "ts", "jsx", "tsx", "java", "kt", "py", "go", "rs", "cpp", "c", "h", "cs", "php", "rb", "html", "css", "json", "xml", "yml", "yaml", "sh", "zsh", "bash"]
        }
    }

    func matches(_ entry: ArchiveEntry) -> Bool {
        guard !entry.isDirectory else { return false }
        let ext = entry.fileExtension.lowercased()
        return extensions.contains(ext)
    }
}

struct CustomTypeRequest: Identifiable, Hashable, Sendable {
    let id = UUID()
    var value: String = ""
}

struct PasswordPromptState: Identifiable, Hashable, Sendable {
    let id = UUID()
    let archiveSessionID: UUID?
    let archiveName: String
    let detectedFormat: ArchiveFormat
    var message: String
    var password: String = ""
    var rememberPasswordForSession: Bool = true
}

struct ProPaywallState: Identifiable, Hashable, Sendable {
    let id = UUID()
    let feature: ProFeature
}

@MainActor
final class AppPreferences: ObservableObject {
    static let shared = AppPreferences()

    private enum Keys {
        static let revealAfterExtract = "PeekZip.pref.revealAfterExtract"
        static let keepFolderStructure = "PeekZip.pref.keepFolderStructure"
        static let skipJunkFilesOnExtract = "PeekZip.pref.skipJunkFilesOnExtract"
        static let defaultExtractLocation = "PeekZip.pref.defaultExtractLocation"
        static let languageCode = "PeekZip.pref.languageCode"
    }

    @Published var revealAfterExtract: Bool {
        didSet { UserDefaults.standard.set(revealAfterExtract, forKey: Keys.revealAfterExtract) }
    }

    @Published var keepFolderStructure: Bool {
        didSet { UserDefaults.standard.set(keepFolderStructure, forKey: Keys.keepFolderStructure) }
    }

    @Published var skipJunkFilesOnExtract: Bool {
        didSet { UserDefaults.standard.set(skipJunkFilesOnExtract, forKey: Keys.skipJunkFilesOnExtract) }
    }

    @Published var defaultExtractLocationPath: String? {
        didSet { UserDefaults.standard.set(defaultExtractLocationPath, forKey: Keys.defaultExtractLocation) }
    }

    @Published var selectedLanguageCode: String? {
        didSet {
            if let selectedLanguageCode {
                UserDefaults.standard.set(selectedLanguageCode, forKey: Keys.languageCode)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.languageCode)
            }
        }
    }

    private init() {
        let defaults = UserDefaults.standard
        self.revealAfterExtract = defaults.object(forKey: Keys.revealAfterExtract) as? Bool ?? true
        self.keepFolderStructure = defaults.object(forKey: Keys.keepFolderStructure) as? Bool ?? true
        self.skipJunkFilesOnExtract = defaults.object(forKey: Keys.skipJunkFilesOnExtract) as? Bool ?? true
        self.defaultExtractLocationPath = defaults.string(forKey: Keys.defaultExtractLocation)
        self.selectedLanguageCode = defaults.string(forKey: Keys.languageCode)
    }

    var defaultExtractLocationURL: URL? {
        defaultExtractLocationPath.map(URL.init(fileURLWithPath:))
    }
}

extension ArchiveEntry {
    var riskLevel: ArchiveRiskLevel? {
        RiskScanner.finding(for: self)?.riskLevel
    }

    func matches(batchType: ArchiveBatchType) -> Bool {
        batchType.matches(self)
    }
}
