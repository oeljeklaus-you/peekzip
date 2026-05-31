import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @ObservedObject private var store = ArchiveStore.shared
    @State private var hoveredEntryID: UUID?
    @State private var windowSize: CGSize = .zero
    @State private var showInspectorPopover = false

    private let supportedExtensions = [
        "zip", "rar", "7z", "tar", "gz", "tgz", "bz2", "tbz2", "tbz", "xz", "txz", "cpio", "xar"
    ]

    private var showSidebar: Bool {
        layoutMetrics.showSidebar
    }

    private func ui(_ key: L10n.Key) -> String {
        L10n.string(key)
    }

    private var layoutMetrics: LayoutMetrics {
        LayoutMetrics(
            windowWidth: windowSize.width,
            windowHeight: windowSize.height,
            hasSelection: store.selectedEntry != nil,
            hasArchiveLoaded: store.hasArchiveLoaded
        )
    }

    private var emptyStateMetrics: EmptyStateMetrics {
        let metrics = EmptyStateMetrics(width: windowSize.width, height: windowSize.height)
        return metrics
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                backgroundLayer

                VStack(spacing: 0) {
                    appChromeBar

                    Divider()
                        .opacity(0.7)

                    Group {
                        if store.hasArchiveLoaded {
                            VStack(spacing: 10) {
                                compactLoadedSummaryBar

                                if store.isLoading {
                                    loadingCard
                                } else if let errorMessage = store.errorMessage {
                                    errorCard(message: errorMessage)
                                } else {
                                    archiveWorkspace
                                }
                            }
                        } else if store.isLoading {
                            loadingCard
                        } else if let errorMessage = store.errorMessage {
                            errorCard(message: errorMessage)
                        } else {
                            emptyHomeWorkspace
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
            .onAppear {
                windowSize = proxy.size
                debugEmptyStateMetrics()
            }
            .onChange(of: proxy.size) { newSize in
                windowSize = newSize
                debugEmptyStateMetrics()
            }
        }
        .environment(\.layoutDirection, L10n.isRTL ? .rightToLeft : .leftToRight)
        .toolbar { }
        .onDrop(of: [UTType.fileURL], isTargeted: $store.isDropTargeted) { providers in
            handleDrop(providers: providers)
        }
        .overlay(alignment: .topTrailing) {
            if let toast = store.toastMessage {
                toastView(text: toast)
                    .padding(.top, 64)
                    .padding(.trailing, 16)
            }
        }
        .overlay {
            if store.isDropTargeted {
                dropOverlay
            }
        }
        .sheet(item: $store.activeProPaywallState) { state in
            ProPaywallView(
                state: state,
                onUnlock: {
                    store.unlockProForTesting()
                },
                    onRestorePurchase: {
                        store.showToast(L10n.string(.archiveRestorePurchaseFuture))
                    },
                onContinueFree: {
                    store.continueFreeFromPaywall()
                }
            )
        }
        .sheet(item: $store.passwordPromptState) { state in
            PasswordPromptView(
                state: state,
                onCancel: {
                    store.dismissPasswordPrompt()
                },
                onUnlock: { password, remember in
                    store.submitPassword(password, rememberForSession: remember)
                }
            )
        }
        .sheet(item: $store.customTypeRequest) { request in
            BatchExtractCustomTypesView(
                request: request,
                onCancel: {
                    store.customTypeRequest = nil
                },
                onExtract: { extensions in
                    store.customTypeRequest = nil
                    store.requestCustomBatchExtract(extensions: extensions)
                }
            )
        }
        .sheet(isPresented: $store.isShowingSettings) {
            SettingsView()
        }
        .confirmationDialog(
            String(format: ui(.archiveRiskConfirmationTitle), locale: .current, arguments: [store.riskyFileCountValue]),
            isPresented: $store.showRiskyExtractConfirmation,
            titleVisibility: .visible
        ) {
                    Button(ui(.archiveReviewRiskyFiles)) {
                        store.reviewRiskyFiles()
                    }
            Button(ui(.archiveExtractAnyway)) {
                store.confirmRiskyExtract()
            }
            Button(ui(.archiveCancel), role: .cancel) {
                store.showRiskyExtractConfirmation = false
            }
        } message: {
            Text(ui(.archiveRiskConfirmationMessage))
        }
    }

    private var toolbarStatusText: String {
        if store.isExtracting {
            return L10n.string(.statusExtractingShort)
        }
        if store.isLoading {
            return L10n.string(.statusInspectingShort)
        }
        if store.isPro && store.hasArchiveLoaded {
            return L10n.string(.statusProActive)
        }
        return L10n.string(.statusReadyShort)
    }

    private var appChromeBar: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                AppIconView(size: 22)

                Text("PeekZip")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                toolbarStatusBadge(text: toolbarStatusText)
            }
            .frame(minWidth: 220, alignment: .leading)

            Spacer(minLength: 16)

            if store.hasArchiveLoaded {
                Text(store.selectedArchiveName)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .layoutPriority(0)
                    .frame(minWidth: 160, idealWidth: 220, maxWidth: 300)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(.thinMaterial, in: Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
                    )
                    .help(store.selectedArchivePath ?? store.selectedArchiveName)
            }

            Spacer(minLength: 16)

            HStack(spacing: 8) {
                Button {
                    openArchive()
                } label: {
                    Text(ui(.toolbarOpenShort))
                }
                .buttonStyle(ToolbarSecondaryButtonStyle())
                .focusable(false)

                Button {
                    store.extractAll()
                } label: {
                    Text(ui(.toolbarExtractShort))
                }
                .disabled(!store.canExtractAll || store.isLoading || store.isExtracting)
                .buttonStyle(ToolbarPrimaryButtonStyle())
                .focusable(false)

                Menu {
                    moreMenuContent
                } label: {
                    HStack(spacing: 6) {
                        Label(ui(.toolbarActionsShort), systemImage: "ellipsis.circle")
                            .labelStyle(.titleAndIcon)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                    }
                }
                .buttonStyle(ToolbarMenuButtonStyle())
                .focusable(false)
                .accessibilityLabel(ui(.toolbarMoreAccessibility))

                if store.isPro {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12, weight: .semibold))
                        Text(ui(.toolbarProActiveShort))
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .frame(minWidth: 62, minHeight: 30)
                    .foregroundStyle(.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.green.opacity(0.16), lineWidth: 1)
                    )
                    .help(ui(.toolbarProTooltipActive))
                } else {
                    Button {
                        store.presentPaywall(feature: .fullLargeArchiveIndex)
                    } label: {
                        Label(ui(.toolbarProShort), systemImage: "sparkles")
                    }
                    .buttonStyle(ToolbarProButtonStyle())
                    .focusable(false)
                    .accessibilityLabel(ui(.archiveActionUpgradePro))
                    .help(ui(.toolbarProTooltipUpgrade))
                }
            }
            .layoutPriority(2)
        }
        .padding(.leading, 88)
        .padding(.trailing, 20)
        .frame(height: 52)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var summaryFormatLabel: String {
        guard !store.isMultiArchiveMode, let selectedArchiveURL = store.selectedArchiveURL else {
            return store.archiveTypeLabel
        }
        return archiveFormatLabel(from: selectedArchiveURL.lastPathComponent)
    }

    private var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color(nsColor: .controlBackgroundColor).opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.orange.opacity(0.08))
                .frame(width: 220, height: 220)
                .blur(radius: 72)
                .offset(x: 250, y: -220)

            Circle()
                .fill(Color.secondary.opacity(0.06))
                .frame(width: 210, height: 210)
                .blur(radius: 72)
                .offset(x: -250, y: 220)
        }
        .ignoresSafeArea()
    }

    private var emptyHomeWorkspace: some View {
        ScrollView(.vertical, showsIndicators: windowSize.height < 760) {
            VStack(spacing: emptyStateMetrics.sectionSpacing) {
                if emptyStateMetrics.useTwoColumns {
                    emptyHomeHeader

                    HStack(alignment: .top, spacing: 20) {
                        emptyPrimaryCard
                            .frame(minWidth: 520, idealWidth: 560, maxWidth: 620, alignment: .leading)

                        emptyFeatureValuePanel
                            .frame(width: emptyStateMetrics.featurePanelWidth, alignment: .leading)
                    }
                    .frame(maxWidth: emptyStateMetrics.contentWidth, alignment: .center)
                } else {
                    emptyHomeHeaderCompact

                    VStack(spacing: 16) {
                        emptyPrimaryCardCompact
                        emptyFeatureValuePanel
                    }
                    .frame(maxWidth: emptyStateMetrics.contentWidth)
                }
            }
            .padding(.vertical, emptyStateMetrics.verticalPadding)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(minHeight: max(windowSize.height - 32, 0), alignment: windowSize.height < 760 ? .top : .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var emptyHomeHeader: some View {
        HStack(alignment: .center, spacing: emptyStateMetrics.headerSpacing) {
            AppIconView(size: emptyStateMetrics.iconSize)

            VStack(alignment: .leading, spacing: 6) {
                Text(ui(.emptyHomeTitle))
                    .font(.system(size: emptyStateMetrics.titleFontSize, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)

                Text(ui(.emptyHomeSubtitle))
                    .font(.system(size: emptyStateMetrics.subtitleFontSize))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: emptyStateMetrics.subtitleMaxWidth, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: emptyStateMetrics.contentWidth)
    }

    private var emptyHomeHeaderCompact: some View {
        VStack(alignment: .center, spacing: 12) {
            AppIconView(size: emptyStateMetrics.iconSize)

            VStack(alignment: .center, spacing: 6) {
                Text(ui(.emptyHomeTitle))
                    .font(.system(size: emptyStateMetrics.titleFontSize, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .multilineTextAlignment(.center)

                Text(ui(.emptyHomeSubtitle))
                    .font(.system(size: emptyStateMetrics.subtitleFontSize))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
    }

    private var emptyPrimaryCard: some View {
        VStack(alignment: .leading, spacing: emptyStateMetrics.primaryCardSpacing) {
            VStack(alignment: .leading, spacing: 4) {
                Text(ui(.emptyPrimaryTitle))
                    .font(.system(size: emptyStateMetrics.primaryTitleFontSize, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(ui(.emptyPrimarySubtitle))
                    .font(.system(size: emptyStateMetrics.primarySubtitleFontSize))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 10) {
                Button {
                    openArchive()
                } label: {
                    Label(ui(.archiveEmptyOpenArchive), systemImage: "plus")
                }
                .buttonStyle(PrimaryActionButtonStyle())

                Button {
                    openArchive()
                } label: {
                    Text(ui(.archiveEmptyTrySampleArchive))
                }
                .buttonStyle(SecondaryActionButtonStyle())
            }

            dropZone
        }
        .padding(emptyStateMetrics.primaryCardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var emptyPrimaryCardCompact: some View {
        VStack(alignment: .leading, spacing: emptyStateMetrics.primaryCardSpacing) {
            VStack(alignment: .leading, spacing: 4) {
                Text(ui(.emptyPrimaryTitle))
                    .font(.system(size: emptyStateMetrics.primaryTitleFontSize, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(ui(.emptyPrimarySubtitle))
                    .font(.system(size: emptyStateMetrics.primarySubtitleFontSize))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            if emptyStateMetrics.availableWidth < 560 {
                VStack(spacing: 8) {
                    Button {
                        openArchive()
                    } label: {
                        Label(ui(.archiveEmptyOpenArchive), systemImage: "plus")
                    }
                    .buttonStyle(PrimaryActionButtonStyle())
                    .frame(maxWidth: .infinity)

                    Button {
                        openArchive()
                    } label: {
                        Text(ui(.archiveEmptyTrySampleArchive))
                    }
                    .buttonStyle(SecondaryActionButtonStyle())
                    .frame(maxWidth: .infinity)
                }
            } else {
                HStack(spacing: 10) {
                    Button {
                        openArchive()
                    } label: {
                        Label(ui(.archiveEmptyOpenArchive), systemImage: "plus")
                    }
                    .buttonStyle(PrimaryActionButtonStyle())

                    Button {
                        openArchive()
                    } label: {
                        Text(ui(.archiveEmptyTrySampleArchive))
                    }
                    .buttonStyle(SecondaryActionButtonStyle())
                }
            }

            dropZone
        }
        .padding(emptyStateMetrics.primaryCardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var emptyFeatureValuePanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(ui(.emptyFeaturesTitle))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            featureRow(
                icon: "magnifyingglass",
                title: ui(.emptyFeatureSearchTitle),
                subtitle: ui(.emptyFeatureSearchSubtitle)
            )

            featureRow(
                icon: "square.grid.2x2",
                title: ui(.emptyFeatureBrowseTitle),
                subtitle: ui(.emptyFeatureBrowseSubtitle)
            )

            featureRow(
                icon: "tray.and.arrow.down",
                title: ui(.emptyFeatureExtractTitle),
                subtitle: ui(.emptyFeatureExtractSubtitle)
            )

            Divider()
                .padding(.vertical, 2)

            supportedFormatsCompact
        }
        .padding(emptyStateMetrics.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor).opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.045), lineWidth: 1)
        )
    }

    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.accentColor)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.accentColor.opacity(0.08))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13.5, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)
        }
    }

    private var supportedFormatsCompact: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ui(.emptyFormatsTitle))
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 48), spacing: 6)],
                spacing: 6
            ) {
                formatPill("ZIP")
                formatPill("RAR")
                formatPill("7Z")
                formatPill("TAR")
                formatPill("GZ")
                formatPill("BZ2")
                formatPill("XZ")
            }
        }
    }

    private func formatPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11.5, weight: .semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.08), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.secondary.opacity(0.10), lineWidth: 1)
            )
    }

    private var compactLoadedSummaryBar: some View {
        ViewThatFits(in: .horizontal) {
            loadedSummaryWide
            loadedSummaryStacked
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(minHeight: 84, maxHeight: 104)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.68), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }

    private var loadedSummaryWide: some View {
        HStack(alignment: .center, spacing: 12) {
            loadedSummaryIdentity
            Spacer(minLength: 12)
            loadedSummaryStats
            Spacer(minLength: 12)
            loadedSummaryActions
        }
    }

    private var loadedSummaryStacked: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                loadedSummaryIdentity
                Spacer(minLength: 12)
                loadedSummaryActions
            }

            loadedSummaryStats
        }
    }

    private var loadedSummaryIdentity: some View {
        HStack(alignment: .center, spacing: 14) {
            ArchiveFormatIconView(formatLabel: summaryFormatLabel, size: 46)

            VStack(alignment: .leading, spacing: 2) {
                Text(store.selectedArchiveName)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Text(store.archiveSafetySummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }

    private var loadedSummaryStats: some View {
        HStack(spacing: 5) {
            summaryMiniChip(text: summaryFormatLabel.isEmpty ? ui(.archiveArchiveLabel) : summaryFormatLabel)
            summaryMiniChip(text: String(format: ui(.statFilesCompact), locale: .current, arguments: [store.fileCount]))
            summaryMiniChip(text: String(format: ui(.statFoldersCompact), locale: .current, arguments: [store.folderCount]))
            summaryMiniChip(text: store.totalSizeLabel == ui(.statSizeUnknown) ? ui(.statSizeUnknown) : store.totalSizeLabel)
            summaryMiniChip(text: store.archiveFlavorLabel)
        }
        .layoutPriority(1)
    }

    private var loadedSummaryActions: some View {
        VStack(alignment: .trailing, spacing: 6) {
            if store.shouldShowLargeArchiveBanner && !store.isPro {
                HStack(spacing: 8) {
                    Text(String(format: ui(.archiveShowingOfTotalPrefix), locale: .current, arguments: [min(store.activeSessionShowingCount, 200), store.archiveItemCount]))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)

                Button {
                    store.presentPaywall(feature: .fullLargeArchiveIndex)
                } label: {
                    chromeActionLabel(title: ui(.toolbarUpgradeShort), systemImage: nil, variant: .secondary)
                }
                .buttonStyle(.plain)
                .controlSize(.small)
                .focusable(false)
                }
            }

            HStack(spacing: 8) {
                Menu {
                    moreMenuContent
                } label: {
                    chromeActionLabel(title: ui(.actionsShort), systemImage: "tray.and.arrow.down", variant: .secondary)
                }
                .buttonStyle(.plain)
                .controlSize(.small)
                .focusable(false)
            }
        }
    }

    private var archiveWorkspace: some View {
        let metrics = layoutMetrics

        return VStack(spacing: 12) {
            if metrics.showDetailsPanel {
                threeColumnWorkspace
            } else {
                primaryWorkspaceWithoutInspector
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var threeColumnWorkspace: some View {
        HStack(alignment: .top, spacing: 16) {
            if showSidebar {
                sidebarPanel
                    .frame(width: layoutMetrics.sidebarWidth)
            }

            fileListPanel
                .frame(minWidth: layoutMetrics.contentMinWidth, maxWidth: .infinity)
                .layoutPriority(1)

            inspectorPanel
                .frame(width: layoutMetrics.detailsWidth)
        }
    }

    private var primaryWorkspaceWithoutInspector: some View {
        HStack(alignment: .top, spacing: 16) {
            if showSidebar {
                sidebarPanel
                    .frame(width: layoutMetrics.sidebarWidth)
            }

            fileListPanel
                .frame(minWidth: layoutMetrics.contentMinWidth, maxWidth: .infinity)
                .layoutPriority(1)
        }
    }

    private var sidebarPanel: some View {
        cardSurface(alignment: .topLeading) {
            ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 12) {
                    Text(ui(.archiveFiltersTitle))
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary.opacity(0.78))
                        .textCase(.uppercase)

                    if store.isMultiArchiveMode {
                        archiveSessionsSection
                        Divider()
                    }

                    sidebarSection(title: ui(.archiveBrowseGroupTitle)) {
                        VStack(spacing: 6) {
                            ForEach(browseFilters) { filter in
                                filterButton(filter)
                            }
                        }
                    }

                    Divider()

                    sidebarSection(title: ui(.archiveInspectGroupTitle)) {
                        VStack(spacing: 6) {
                            ForEach(inspectFilters) { filter in
                                filterButton(filter)
                            }
                        }
                    }

                    if !layoutMetrics.showCompactSidebar {
                        Divider()

                        sidebarSection(title: ui(.archiveSummaryGroupTitle)) {
                            VStack(alignment: .leading, spacing: 8) {
                                statRow(title: L10n.string(.archiveTableSize), value: store.totalSizeLabel)
                                statRow(title: L10n.string(.archiveTableName), value: "\(store.fileCount)")
                                statRow(title: L10n.string(.filterFolders), value: "\(store.folderCount)")
                                statRow(title: L10n.string(.archiveNoFileSelected), value: "\(store.selectedItemCount)")
                            }
                        }
                    }
                }
            }
        }
    }

    private var browseFilters: [ArchiveFilter] {
        [.allItems, .folders, .images, .documents, .code, .videos, .archives]
    }

    private var inspectFilters: [ArchiveFilter] {
        [.largeFiles, .recentlyViewed, .riskyFiles, .hiddenJunkFiles]
    }

    private var archiveSessionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
                Text(ui(.archiveArchivesGroupTitle))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary.opacity(0.78))
                .textCase(.uppercase)

            Button {
                store.selectArchiveSession(nil)
            } label: {
                archiveSessionRow(title: ui(.archiveAllArchivesTitle), isSelected: store.activeArchiveSessionID == nil)
            }
            .buttonStyle(.plain)

            ForEach(store.archiveFilterSessions) { session in
                Button {
                    store.selectArchiveSession(session.id)
                } label: {
                    archiveSessionRow(
                        title: session.archiveName,
                        isSelected: store.activeArchiveSessionID == session.id
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func sidebarSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary.opacity(0.78))
                .textCase(.uppercase)

            content()
        }
    }

    private var compactFilterBar: some View {
        Picker(ui(.archiveFiltersTitle), selection: $store.activeFilter) {
            ForEach(browseFilters) { filter in
                Text(filter.title).tag(filter)
            }
        }
        .pickerStyle(.segmented)
    }

    private var fileListPanel: some View {
        cardSurface(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 10) {
                archiveContentsHeader

                if store.shouldShowLargeArchiveBanner {
                    infoBanner(
                        systemImage: "info.circle.fill",
                        title: store.largeArchiveBannerMessage,
                        actionTitle: ui(.archiveActionUnlockFullIndex),
                        action: {
                            store.presentPaywall(
                                feature: .fullLargeArchiveIndex
                            )
                        },
                        secondaryActionTitle: ui(.archiveActionContinueFree),
                        secondaryAction: { }
                    )
                }

                if store.shouldShowRiskBanner {
                    infoBanner(
                        systemImage: "exclamationmark.triangle.fill",
                        title: store.riskBannerMessage,
                        actionTitle: ui(.archiveReviewRiskyFiles),
                        action: {
                            store.showRiskyFiles()
                        }
                    )
                }

                searchBar

                if !showSidebar {
                    compactFilterBar
                }

                categoryCardsRow

                if store.isLoading {
                    centeredEmptyState(
                        systemImage: "arrow.triangle.2.circlepath",
                        title: ui(.archiveReadingTitle),
                        message: ui(.archiveReadingSubtitle)
                    )
                } else if let errorMessage = store.errorMessage {
                    centeredErrorState(message: errorMessage)
                } else if store.visibleEntries.isEmpty {
                    if store.entries.isEmpty {
                        centeredEmptyState(
                            systemImage: "archivebox",
                            title: ui(.archiveEmptyArchiveTitle),
                            message: ui(.archiveChooseAnotherArchive)
                        )
                    } else {
                        centeredEmptyState(
                            systemImage: "magnifyingglass",
                            title: ui(.archiveNoMatchesTitle),
                            message: ui(.archiveNoMatchesSubtitle)
                        )
                    }
                } else {
                    fileTable

                    if store.archiveItemCount <= 3 {
                        fewItemsHint
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private var archiveContentsHeader: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .firstTextBaseline) {
                Text(ui(.archiveContentsTitle))
                    .font(.title3.bold())

                Spacer()

                if store.isExtracting {
                    Label(ui(.statusExtractingShort), systemImage: "arrow.down.circle")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                if !layoutMetrics.showDetailsPanel {
                    Button {
                        showInspectorPopover.toggle()
                    } label: {
                        chromeActionLabel(title: ui(.inspectorShort), systemImage: "sidebar.right", variant: .subtle)
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showInspectorPopover, attachmentAnchor: .rect(.bounds), arrowEdge: .trailing) {
                        inspectorPopoverContent
                            .frame(width: 340, height: 540)
                            .padding(6)
                    }
                }
            }

            Text(store.archiveContentsSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var searchBar: some View {
        ViewThatFits(in: .horizontal) {
            searchBarWide
            searchBarStacked
        }
    }

    private var searchBarWide: some View {
        HStack(spacing: 8) {
            searchField

            Text("⌘F")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.secondary.opacity(0.08), in: Capsule())
        }
    }

    private var searchBarStacked: some View {
        VStack(alignment: .leading, spacing: 6) {
            searchField
            HStack {
                Spacer()
                Text("⌘F")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.secondary.opacity(0.08), in: Capsule())
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField(ui(.searchPlaceholderArchive), text: $store.searchText)
                .textFieldStyle(.plain)
                .onSubmit {
                    if !store.searchText.isEmpty {
                        store.showToast(String(format: ui(.archiveShowingResultsFor), locale: .current, arguments: [store.visibleEntries.count, store.searchText as NSString]))
                    }
                }

                if !store.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Button {
                        store.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(minWidth: layoutMetrics.searchMinWidth)
        .background(Color(nsColor: .textBackgroundColor), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.secondary.opacity(0.14), lineWidth: 1)
        )
    }

    private var categoryCardsRow: some View {
        let metrics = topMetrics
        return Group {
            if layoutMetrics.useHorizontalCategoryCards {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 8) {
                        ForEach(metrics) { metric in
                            summaryMetricCard(metric)
                                .frame(width: layoutMetrics.categoryCardWidth)
                        }
                    }
                    .padding(.vertical, 1)
                }
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: layoutMetrics.categoryCardWidth, maximum: layoutMetrics.categoryCardWidth + 20), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(metrics) { metric in
                        summaryMetricCard(metric)
                    }
                }
            }
        }
    }

    private var fileTable: some View {
        let items = store.visibleDisplayItems

        return VStack(alignment: .leading, spacing: 0) {
            fileListHeader

            Divider()

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(items) { entry in
                        fileRow(entry)

                        if entry.id != items.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .frame(minWidth: layoutMetrics.tableMinWidth, alignment: .leading)
    }

    private var fileListHeader: some View {
        let mode = layoutMetrics.tableMode
        return HStack(spacing: 10) {
            if store.isMultiArchiveMode {
                Text(ui(.archiveTableArchive))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 136, alignment: .leading)
            }

            Text(ui(.archiveTableName))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(minWidth: mode == .compact ? 320 : 300, maxWidth: .infinity, alignment: .leading)

            if mode != .compact {
                Text(ui(.archiveTablePath))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: mode == .full ? 150 : 120, alignment: .leading)
            }

            Text(ui(.archiveTableSize))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 92, alignment: .trailing)

            if mode == .full {
                Text(ui(.archiveTableModified))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 140, alignment: .leading)
            }

            Text(ui(.archiveTableType))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private func fileRow(_ entry: DisplayArchiveItem) -> some View {
        let mode = layoutMetrics.tableMode
        let isSelected = store.selectedEntryID == entry.id
        let finding = store.riskFinding(for: entry.originalArchiveItem)
        return Button {
            store.select(entry: entry.originalArchiveItem)
        } label: {
            HStack(spacing: 12) {
                if store.isMultiArchiveMode {
                    Text(entry.archiveName)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(width: 136, alignment: .leading)
                }

                HStack(spacing: 10) {
                    FileTypeIconView(
                        entry: entry.originalArchiveItem,
                        finding: finding,
                        isSelected: isSelected,
                        size: 20
                    )
                    .frame(width: 22, height: 22, alignment: .center)
                    .fixedSize(horizontal: true, vertical: true)
                    .layoutPriority(2)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text(entry.name)
                                .font(.system(size: 13.5, weight: .medium))
                                .lineLimit(1)
                                .truncationMode(.middle)

                            if let finding {
                                if finding.riskLevel == .notice {
                                    badgeLabel(L10n.string(.archiveHiddenBadge))
                                } else {
                                    riskBadge(for: finding)
                                }
                            } else {
                                EmptyView()
                            }
                        }

                        if mode == .compact {
                            Text(entry.displayPath)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }
                    .frame(minWidth: mode == .compact ? 320 : 300, maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                }
                .contentShape(Rectangle())

                if mode != .compact {
                    Text(entry.displayPath)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(width: mode == .full ? 150 : 120, alignment: .leading)
                }

                HStack {
                    Spacer(minLength: 0)
                    Text(entry.formattedSize)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 92)

                if mode == .full {
                    Text(entry.formattedModifiedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 140, alignment: .leading)
                }

                badgeLabel(fileTypeBadgeLabel(for: entry))
                    .frame(width: 80, alignment: .leading)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(rowBackground(for: entry))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            hoveredEntryID = hovering ? entry.id : (hoveredEntryID == entry.id ? nil : hoveredEntryID)
        }
    }

    private var inspectorPanel: some View {
        cardSurface(alignment: .topLeading) {
            inspectorPanelContent
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private var inspectorPopoverContent: some View {
        cardSurface(alignment: .topLeading) {
            inspectorPanelContent
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private var inspectorPanelContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            inspectorHeader

            if let selectedEntry = store.selectedEntry {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 14) {
                            FileTypeIconView(
                                entry: selectedEntry,
                                finding: store.riskFinding(for: selectedEntry),
                                size: 52
                            )

                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Text(selectedEntry.name)
                                        .font(.headline)
                                        .lineLimit(2)

                                    if let riskFinding = store.riskFinding(for: selectedEntry) {
                                        if riskFinding.riskLevel == .high || riskFinding.riskLevel == .medium {
                                            riskBadge(for: riskFinding)
                                        } else {
                                            badgeLabel(L10n.string(.archiveHiddenBadge))
                                        }
                                    }
                                }

                                badgeLabel(fileTypeBadgeLabel(for: selectedEntry))
                            }

                            Spacer()
                        }

                        sectionCard(title: ui(.archiveMetadataTitle)) {
                            VStack(spacing: 10) {
                                inspectorRow(label: ui(.archiveMetadataType), value: selectedEntry.kindLabel)
                                inspectorRow(label: ui(.archiveMetadataSize), value: selectedEntry.formattedSize)
                                inspectorRow(label: ui(.archiveMetadataModified), value: selectedEntry.formattedModifiedDate)
                                inspectorRow(label: ui(.archiveMetadataCompression), value: selectedEntry.formattedCompressionMethod)
                                inspectorRow(label: ui(.archiveMetadataCompressedSize), value: selectedEntry.formattedCompressedSize)
                            }
                        }

                        sectionCard(title: ui(.archiveLocationTitle)) {
                            VStack(spacing: 10) {
                                inspectorRow(label: ui(.archiveMetadataPathInArchive), value: selectedEntry.path)
                                inspectorRow(label: ui(.archiveMetadataArchiveName), value: store.selectedArchiveName)
                                inspectorRow(label: ui(.archiveMetadataParentFolder), value: selectedEntry.parentPath.isEmpty ? "—" : selectedEntry.parentPath)
                            }
                        }

                        if let finding = store.riskFinding(for: selectedEntry) {
                            sectionCard(title: ui(.archiveRiskTitle)) {
                                VStack(spacing: 10) {
                                    inspectorRow(label: ui(.archiveMetadataLevel), value: finding.riskLevel.label)
                                    inspectorRow(label: ui(.archiveMetadataReason), value: finding.reason.label)
                                    inspectorRow(label: ui(.archiveMetadataMessage), value: finding.message)
                                }
                            }
                        }

                        sectionCard(title: ui(.archivePreviewTitle)) {
                            previewSection(for: selectedEntry)
                        }

                        sectionCard(title: ui(.archiveQuickActionsTitle)) {
                            VStack(alignment: .leading, spacing: 10) {
                                Button(selectedEntry.isDirectory ? ui(.archiveActionExtractFolder) : ui(.archiveActionExtractSelected)) {
                                    store.extractSelected()
                                }
                                .buttonStyle(InspectorPrimaryActionButtonStyle())
                                .disabled(store.isExtracting || !store.canExtractSelected)

                                if store.selectedItemCount > 0 {
                                    if store.selectedItemCount > 1 {
                                        Text(String(format: ui(.archiveSelectedSummary), locale: .current, arguments: [store.selectedItemCount]))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }

                                    VStack(spacing: 6) {
                                        InspectorActionRow(iconName: "folder", title: ui(.archiveActionRevealAfterExtract)) {
                                            store.extractSelected(revealAfterExtract: true)
                                        }
                                        .disabled(store.isExtracting || !store.canExtractSelected)

                                        InspectorActionRow(iconName: "doc.on.doc", title: ui(.archiveActionCopyFileName)) {
                                            store.copySelectedFileName()
                                        }
                                        .disabled(store.selectedEntry == nil)

                                        InspectorActionRow(iconName: "link", title: ui(.archiveActionCopyPath)) {
                                            store.copySelectedPath()
                                        }
                                        .disabled(store.selectedEntry == nil)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 2)
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.visible)
            } else {
                emptyInspector
            }
        }
    }

    private var inspectorHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ui(.archiveContentsInspectorTitle))
                    .font(.title2.bold())
                Text(ui(.archiveContentsInspectorSubtitle))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if store.previewState == .loading {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var emptyInspector: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.secondary.opacity(0.10))
                    .frame(width: 64, height: 64)
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 6) {
                Text(ui(.archiveSelectItemToInspect))
                    .font(.headline)

                Text(ui(.archiveInspectBeforeExtracting))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 250)
            }

            VStack(alignment: .leading, spacing: 8) {
                tipRow(ui(.archivePreviewImagesText))
                tipRow(ui(.archiveCopyPathsText))
                tipRow(ui(.archiveExtractSelectedText))
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 14)
    }

    private func tipRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.accentColor)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
    }

    private var loadingCard: some View {
        cardSurface {
            centeredEmptyState(
                systemImage: "arrow.triangle.2.circlepath",
                title: ui(.archiveReadingTitle),
                message: ui(.archiveReadingSubtitle)
            )
        }
    }

    private func errorCard(message: String) -> some View {
        cardSurface {
            VStack(spacing: 18) {
                centeredErrorState(message: message)

                HStack(spacing: 12) {
                    Button(ui(.archiveTryAgain)) {
                        store.reloadArchive()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.isLoading)

                    Button(ui(.archiveChooseAnotherArchive)) {
                        openArchive()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var dropZone: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.2, dash: [6, 6]))
                    .foregroundStyle(.secondary.opacity(0.35))
            )
            .frame(height: emptyStateMetrics.dropZoneHeight)
            .frame(maxWidth: .infinity)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: emptyStateMetrics.isCompactHeight ? 20 : 24, weight: .semibold))
                        .foregroundStyle(Color.accentColor)

                    Text(ui(.archiveDropTitle))
                        .font(.system(size: emptyStateMetrics.isCompactHeight ? 15 : 17, weight: .semibold))

                    Text(ui(.archiveDropSubtitle))
                        .font(.system(size: emptyStateMetrics.isCompactHeight ? 12 : 13))
                        .foregroundStyle(.secondary)
                }
            )
    }

    private var dropOverlay: some View {
        ZStack {
            Color.accentColor.opacity(0.12)
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .strokeBorder(Color.accentColor.opacity(0.4), lineWidth: 1.5)
                )
                .frame(maxWidth: 500)
                .frame(height: 220)
                .overlay(
                    VStack(spacing: 14) {
                        Image(systemName: "tray.and.arrow.down.fill")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(Color.accentColor)

                        Text(ui(.archiveDropOverlayTitle))
                            .font(.title2.bold())

                        Text(ui(.archiveDropOverlaySubtitle))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 380)
                    }
                )
                .shadow(color: .black.opacity(0.18), radius: 30, y: 14)
        }
    }

    private func previewSection(for entry: ArchiveEntry) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            switch store.previewState {
            case .loading:
                HStack {
                    ProgressView()
                    Text(ui(.archivePreviewReading))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
            case .ready:
                if let previewImage = store.previewImage {
                    Image(nsImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                } else if let previewText = store.previewText {
                    ScrollView {
                        Text(previewText)
                            .font(.system(.callout, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                    }
                    .frame(height: 160)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                } else {
                    fallbackPreviewState(for: entry)
                }
            case .empty:
                fallbackPreviewState(for: entry)
            }
        }
    }

    private func fallbackPreviewState(for entry: ArchiveEntry) -> some View {
        VStack(spacing: 10) {
            FileTypeIconView(entry: entry, finding: store.riskFinding(for: entry), size: 30)

            if entry.kind == .image || entry.kind == .text || entry.kind == .code {
                Text(ui(.archiveNoPreviewSubtitle))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else if entry.kind == .document && entry.fileExtensionLowercased == "pdf" {
                Text(ui(.archiveNoPreviewPdfTitle))
                    .font(.footnote.weight(.semibold))
                Text(ui(.archiveNoPreviewPdfSubtitle))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else if entry.isDirectory {
                Text(ui(.archiveNoPreviewFolderTitle))
                    .font(.footnote.weight(.semibold))
                Text(ui(.archiveNoPreviewFolderSubtitle))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text(ui(.archiveNoPreviewTitle))
                    .font(.footnote.weight(.semibold))
                Text(ui(.archiveNoPreviewSubtitle))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .frame(minHeight: 96, maxHeight: 120)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func centeredEmptyState(systemImage: String, title: String, message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(Color.accentColor)

            Text(title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 420)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 22)
    }

    private func centeredErrorState(message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.orange)

            Text(ui(.archiveUnableToReadTitle))
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 420)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private func filterButton(_ filter: ArchiveFilter) -> some View {
        let isSelected = store.activeFilter == filter
        let count = store.filterCount(for: filter)
        let isLocked = filter.requiresPro && !store.isPro
        let rowOpacity: Double = count == 0 ? (isSelected ? 0.78 : 0.52) : 1.0
        let displayCountText = isLocked ? ui(.archiveProTag) : "\(count)"

        return Button {
            if isLocked {
                store.presentPaywall(
                    feature: .riskFileDetection
                )
                return
            }
            store.activeFilter = filter
        } label: {
            Group {
                if layoutMetrics.showCompactSidebar {
                    HStack {
                        Spacer(minLength: 0)
                        Image(systemName: filter.symbolName)
                            .font(.caption.weight(.semibold))
                        Spacer(minLength: 0)
                    }
                    .help("\(filter.title) (\(count))")
                } else {
                    HStack(spacing: 9) {
                        Image(systemName: filter.symbolName)
                            .font(.system(size: 12.5, weight: .semibold))
                            .frame(width: 14)

                        Text(filter.title)
                            .font(.system(size: 13, weight: .medium))
                            .lineLimit(1)

                        Spacer(minLength: 0)

                        Text(displayCountText)
                            .font(.system(size: 11.5, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .opacity(isLocked ? 0.92 : (count == 0 ? 0.55 : 1.0))
                            .frame(minWidth: 30)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background {
                                if isLocked {
                                    Capsule()
                                        .fill(Color.secondary.opacity(0.08))
                                } else {
                                    Capsule()
                                        .fill(.thinMaterial)
                                }
                            }

                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(rowOpacity)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.06) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Color.accentColor.opacity(0.14) : Color.secondary.opacity(0.10), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, minHeight: 38, alignment: .leading)
    }

    private func summaryBadge(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func archiveSessionRow(title: String, isSelected: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "externaldrive")
                .font(.system(size: 12, weight: .semibold))
                .frame(width: 14)
            if !layoutMetrics.showCompactSidebar {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
                    .truncationMode(.middle)
            } else {
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isSelected ? Color.accentColor.opacity(0.10) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isSelected ? Color.accentColor.opacity(0.24) : Color.secondary.opacity(0.14), lineWidth: 1)
        )
    }

    private var fewItemsHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)

            Text(archiveFewItemsHint())
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.05), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.secondary.opacity(0.10), lineWidth: 1)
        )
        .padding(.top, 8)
    }

    private func infoBanner(
        systemImage: String,
        title: String,
        actionTitle: String,
        action: @escaping () -> Void,
        secondaryActionTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) -> some View {
        ViewThatFits(in: .horizontal) {
            infoBannerHorizontal(
                systemImage: systemImage,
                title: title,
                actionTitle: actionTitle,
                action: action,
                secondaryActionTitle: secondaryActionTitle,
                secondaryAction: secondaryAction
            )
            infoBannerStacked(
                systemImage: systemImage,
                title: title,
                actionTitle: actionTitle,
                action: action,
                secondaryActionTitle: secondaryActionTitle,
                secondaryAction: secondaryAction
            )
        }
        .padding(12)
        .background(Color.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.orange.opacity(0.16), lineWidth: 1)
        )
    }

    private func infoBannerHorizontal(
        systemImage: String,
        title: String,
        actionTitle: String,
        action: @escaping () -> Void,
        secondaryActionTitle: String?,
        secondaryAction: (() -> Void)?
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(.orange)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(2)

            Spacer(minLength: 8)

            if let secondaryActionTitle, let secondaryAction {
                Button(secondaryActionTitle, action: secondaryAction)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }

            Button(actionTitle, action: action)
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
    }

    private func infoBannerStacked(
        systemImage: String,
        title: String,
        actionTitle: String,
        action: @escaping () -> Void,
        secondaryActionTitle: String?,
        secondaryAction: (() -> Void)?
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(.orange)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
            }

            HStack {
                Spacer()
                if let secondaryActionTitle, let secondaryAction {
                    Button(secondaryActionTitle, action: secondaryAction)
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                }
                Button(actionTitle, action: action)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }
    }

    private var topMetrics: [ArchiveMetricCard] {
        let metrics: [ArchiveMetricCard] = [
            .init(title: L10n.string(.metricItems), value: "\(store.archiveItemCount)", symbol: "doc.on.doc"),
            .init(title: L10n.string(.metricCode), value: "\(store.codeCount)", symbol: "chevron.left.forwardslash.chevron.right"),
            .init(title: L10n.string(.metricFolders), value: "\(store.folderCount)", symbol: "folder"),
            .init(title: L10n.string(.metricDocuments), value: "\(store.documentCount)", symbol: "doc.text"),
            .init(title: L10n.string(.metricImages), value: "\(store.imageCount)", symbol: "photo"),
            .init(title: L10n.string(.metricVideos), value: "\(store.videoCount)", symbol: "video"),
            .init(title: L10n.string(.metricLarge), value: "\(store.largeFileCount)", symbol: "tray.full"),
            .init(title: L10n.string(.metricRisky), value: "\(store.riskyFileCountValue)", symbol: "exclamationmark.triangle"),
            .init(title: L10n.string(.metricHidden), value: "\(store.hiddenJunkCount)", symbol: "eye.slash")
        ]

        return Array(metrics.filter { $0.title == L10n.string(.metricItems) || $0.value != "0" }.prefix(4))
    }

    private func summaryMetricCard(_ metric: ArchiveMetricCard) -> some View {
        let isImportant = metric.title == L10n.string(.metricItems) || metric.title == L10n.string(.metricCode) || metric.title == L10n.string(.metricRisky)
        return VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: metric.symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Text(metric.title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Text(metric.value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            if isImportant {
                Text(metric.title == L10n.string(.metricItems) ? L10n.string(.archiveMetricTopLevelOverview) : L10n.string(.archiveMetricMostRelevant))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .frame(width: layoutMetrics.categoryCardWidth, height: layoutMetrics.categoryCardHeight, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.58), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(metric.title == L10n.string(.metricItems) ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.12), lineWidth: 1)
        )
    }

    private func summaryMiniChip(text: String) -> some View {
        Text(text)
            .font(.system(size: 11.5, weight: .semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Color.secondary.opacity(0.08), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.secondary.opacity(0.14), lineWidth: 1)
            )
    }

    @ViewBuilder
    private var moreMenuContent: some View {
        Group {
            menuSectionTitle(ui(.menuSectionExtraction))

            menuAction(ui(.archiveMenuExtractAll), systemImage: "tray.and.arrow.down", isEnabled: store.canExtractAll && !store.isLoading && !store.isExtracting) {
                store.extractAll()
            }

            menuAction(ui(.archiveMenuExtractSelected), systemImage: "checkmark.circle", isEnabled: store.selectedEntry != nil && !store.isLoading && !store.isExtracting && store.canExtractSelected) {
                store.extractSelected()
            }

            menuAction(ui(.archiveMenuRevealAfterExtract), systemImage: "folder", isEnabled: store.selectedEntry != nil && !store.isLoading && !store.isExtracting && store.canExtractSelected) {
                store.extractSelected(revealAfterExtract: true)
            }

            Divider()

            menuSectionTitle(ui(.menuSectionUtilities))
            menuAction(ui(.archiveMenuCopyFileName), systemImage: "doc.on.doc", isEnabled: store.selectedEntry != nil) {
                store.copySelectedFileName()
            }

            menuAction(ui(.archiveMenuCopyPath), systemImage: "link", isEnabled: store.selectedEntry != nil) {
                store.copySelectedPath()
            }

            menuAction(ui(.archiveMenuReloadArchive), systemImage: "arrow.clockwise", isEnabled: store.hasArchiveLoaded && !store.isLoading) {
                store.reloadArchive()
            }

            Divider()

            menuSectionTitle(ui(.menuSectionProTools))
            menuAction(ui(.archiveMenuSearchMultipleArchives), systemImage: "magnifyingglass.circle", isEnabled: true, trailingTag: store.isPro ? nil : ui(.archiveProTag)) {
                if store.isPro {
                    openArchive()
                } else {
                    store.presentPaywall(
                        feature: .multiArchiveSearch
                    )
                }
            }

            Menu {
                menuAction(ui(.archiveMenuExtractAllImages), systemImage: "photo", isEnabled: true) {
                    store.requestBatchExtract(type: .images)
                }
                menuAction(ui(.archiveMenuExtractAllPDFs), systemImage: "doc.richtext", isEnabled: true) {
                    store.requestBatchExtract(type: .pdfs)
                }
                menuAction(ui(.archiveMenuExtractAllVideos), systemImage: "video", isEnabled: true) {
                    store.requestBatchExtract(type: .videos)
                }
                menuAction(ui(.archiveMenuExtractAllDocuments), systemImage: "doc.text", isEnabled: true) {
                    store.requestBatchExtract(type: .documents)
                }
                menuAction(ui(.archiveMenuExtractAllCodeFiles), systemImage: "chevron.left.forwardslash.chevron.right", isEnabled: true) {
                    store.requestBatchExtract(type: .code)
                }
                menuAction(ui(.archiveMenuExtractCustomTypes), systemImage: "slider.horizontal.3", isEnabled: true) {
                    store.customTypeRequest = CustomTypeRequest()
                }
            } label: {
                Label(L10n.string(.archiveBatchExtractByType), systemImage: "square.stack.3d.down.right")
            }

            menuAction(ui(.archiveMenuScanRiskyFiles), systemImage: "exclamationmark.shield", isEnabled: true) {
                store.scanRiskyFiles()
            }
        }

        Divider()

        Group {
            if store.isPro {
                menuAction(ui(.toolbarProTooltipActive), systemImage: "checkmark.seal", isEnabled: false) { }
            } else {
                menuAction(ui(.archiveMenuUpgradeToPro), systemImage: "sparkles", isEnabled: true) {
                    store.presentPaywall(feature: .batchExtractByType)
                }
            }

            menuSectionTitle(ui(.menuSectionApp))
            menuAction(ui(.archiveMenuSettings), systemImage: "gearshape", isEnabled: true) {
                store.isShowingSettings = true
            }
        }
    }

    @ViewBuilder
    private func menuAction(_ title: String, systemImage: String, isEnabled: Bool, trailingTag: String? = nil, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Label(title, systemImage: systemImage)
                Spacer(minLength: 0)
                if let trailingTag {
                    Text(trailingTag)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.10), in: Capsule())
                }
            }
        }
        .disabled(!isEnabled)
    }

    @ViewBuilder
    private func menuSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.top, 2)
            .padding(.bottom, 1)
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
                .font(.system(size: 11))
            Spacer()
            Text(value)
                .font(.system(size: 11.5, weight: .semibold))
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(width: 84, alignment: .trailing)
        }
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            content()
        }
        .padding(14)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.48), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.secondary.opacity(0.10), lineWidth: 1)
        )
    }

    private func inspectorRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 124, alignment: .leading)

            Text(value)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func riskBadge(level: ArchiveRiskLevel?) -> some View {
        RiskBadgeView(level: level)
    }

    private func riskBadge(for finding: RiskFinding) -> some View {
        let label: String
        let color: Color

        switch finding.reason {
        case .macOSAppBundle, .macOSAppExecutablePath:
            label = "APP"
            color = .orange
        case .macOSInstaller:
            label = "INSTALLER"
            color = .orange
        case .macOSDiskImage:
            label = "DISK IMAGE"
            color = .orange
        case .shellScript, .scriptFile:
            label = "SCRIPT"
            color = .orange
        case .windowsExecutable, .windowsScript:
            label = "WINDOWS"
            color = .orange
        case .powershellScript:
            label = "POWERSHELL"
            color = .orange
        case .javaArchive:
            label = "JAVA"
            color = .orange
        case .suspiciousExecutableName:
            label = "RISKY"
            color = .orange
        case .hiddenOrJunk:
            label = "HIDDEN"
            color = .secondary
        case .sensitiveConfig:
            label = "CONFIG"
            color = .secondary
        }

        return TagBadgeView(text: label, tint: color, backgroundTint: color)
    }

    private func rowBackground(for entry: DisplayArchiveItem) -> Color {
        if store.selectedEntryID == entry.id {
            return Color.accentColor.opacity(0.12)
        }
        if hoveredEntryID == entry.id {
            return Color.secondary.opacity(0.08)
        }
        return Color.clear
    }

    private func badgeLabel(_ text: String) -> some View {
        TagBadgeView(text: text, tint: badgeTint(for: text), backgroundTint: badgeBackgroundTint(for: text))
    }

    private func badgeTint(for text: String) -> Color {
        switch text.lowercased() {
        case "folder":
            return .blue
        case "image":
            return .green
        case "document", "text", "pdf":
            return .secondary
        case "code":
            return .purple
        case "archive", "installer", "disk image":
            return .orange
        case "app", "script", "windows", "powershell", "java", "exec":
            return .orange
        case "hidden":
            return .secondary
        case "risky", "high risk", "medium risk":
            return .orange
        case "config":
            return .secondary
        default:
            return .accentColor
        }
    }

    private func badgeBackgroundTint(for text: String) -> Color {
        switch text.lowercased() {
        case "folder":
            return .blue
        case "image":
            return .green
        case "document", "text", "pdf":
            return .secondary
        case "code":
            return .purple
        case "archive", "installer", "disk image":
            return .orange
        case "app", "script", "windows", "powershell", "java", "exec":
            return .orange
        case "hidden":
            return .secondary
        case "risky", "high risk", "medium risk":
            return .orange
        case "config":
            return .secondary
        default:
            return .accentColor
        }
    }

    private func fileTypeSymbolName(for entry: ArchiveEntry) -> String {
        switch entry.kind {
        case .folder:
            return "folder.fill"
        case .image:
            return "photo.fill"
        case .document:
            return entry.fileExtensionLowercased == "pdf" ? "doc.richtext.fill" : "doc.text.fill"
        case .code:
            return "chevron.left.forwardslash.chevron.right"
        case .video:
            return "video.fill"
        case .archive:
            return "archivebox.fill"
        case .text:
            return "doc.plaintext.fill"
        case .largeFile:
            return "tray.full.fill"
        case .other:
            return "doc.fill"
        case .executable:
            let ext = entry.fileExtensionLowercased
            if ext == "app" { return "app.fill" }
            if ext == "pkg" { return "shippingbox.fill" }
            if ext == "dmg" { return "externaldrive.fill" }
            if ["command", "sh", "bash", "zsh"].contains(ext) { return "terminal.fill" }
            return "terminal.fill"
        }
    }

    private func fileTypeBadgeLabel(for entry: DisplayArchiveItem) -> String {
        fileTypeBadgeLabel(for: entry.originalArchiveItem)
    }

    private func fileTypeBadgeLabel(for entry: ArchiveEntry) -> String {
        if let finding = store.riskFinding(for: entry) {
            switch finding.reason {
            case .macOSAppBundle, .macOSAppExecutablePath:
                return "APP"
            case .macOSInstaller:
                return "INSTALLER"
            case .macOSDiskImage:
                return "DISK IMAGE"
            case .shellScript, .scriptFile:
                return "SCRIPT"
            case .windowsExecutable, .windowsScript:
                return "WINDOWS"
            case .powershellScript:
                return "POWERSHELL"
            case .javaArchive:
                return "JAVA"
            case .suspiciousExecutableName:
                return "RISKY"
            case .hiddenOrJunk:
                return "HIDDEN"
            case .sensitiveConfig:
                return "CONFIG"
            }
        }

        switch entry.kind {
        case .folder:
            return "FOLDER"
        case .image:
            return "IMAGE"
        case .document:
            return entry.fileExtensionLowercased == "pdf" ? "PDF" : "DOCUMENT"
        case .code:
            return "CODE"
        case .video:
            return "VIDEO"
        case .archive:
            return "ARCHIVE"
        case .text:
            return "TEXT"
        case .largeFile:
            return "LARGE"
        case .other:
            return "FILE"
        case .executable:
            let ext = entry.fileExtensionLowercased
            if ext == "app" { return "APP" }
            if ext == "pkg" { return "INSTALLER" }
            if ext == "dmg" { return "DISK IMAGE" }
            if ["command", "sh", "bash", "zsh"].contains(ext) { return "SCRIPT" }
            if ["exe", "scr", "bat", "cmd", "vbs"].contains(ext) { return "WINDOWS" }
            if ext == "ps1" { return "POWERSHELL" }
            if ext == "jar" { return "JAVA" }
            return "EXEC"
        }
    }

    private func summaryChip(text: String) -> some View {
        Text(text)
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.thinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
            )
    }

    private func toolbarStatusBadge(text: String) -> some View {
        let palette = toolbarStatusPalette(for: text)
        return HStack(spacing: 5) {
            Circle()
                .fill(palette.foreground.opacity(0.72))
                .frame(width: 4.5, height: 4.5)

            Text(text)
                .font(.system(size: 10.5, weight: .medium))
                .lineLimit(1)
        }
        .foregroundStyle(palette.foreground)
        .padding(.horizontal, 7)
        .padding(.vertical, 2)
        .background(palette.background.opacity(0.72), in: Capsule())
        .overlay(
            Capsule()
                .stroke(palette.stroke.opacity(0.6), lineWidth: 1)
        )
    }

    private func toolbarStatusPalette(for text: String) -> (foreground: Color, background: Color, stroke: Color) {
        switch text {
        case L10n.string(.statusExtractingShort), "Extracting":
            return (.orange, Color.orange.opacity(0.10), Color.orange.opacity(0.18))
        case L10n.string(.statusInspectingShort), "Inspecting":
            return (.primary, Color.secondary.opacity(0.06), Color.secondary.opacity(0.10))
        case L10n.string(.statusProActive), "Pro Active":
            return (.primary, Color.orange.opacity(0.07), Color.orange.opacity(0.12))
        default:
            return (.secondary, Color.secondary.opacity(0.05), Color.secondary.opacity(0.09))
        }
    }

    private func debugEmptyStateMetrics() {
        let metrics = emptyStateMetrics
        print("[EmptyStateMetrics] width=\(Int(metrics.width)), height=\(Int(metrics.height)), contentWidth=\(Int(metrics.contentWidth)), icon=\(Int(metrics.iconSize)), dropZoneHeight=\(Int(metrics.dropZoneHeight))")
    }

    private enum ChromeActionVariant: Equatable {
        case primary
        case secondary
        case subtle
    }

    private func chromeActionLabel(title: String, systemImage: String?, variant: ChromeActionVariant) -> some View {
        if variant == .primary {
            chromeActionBody(
                title: title,
                systemImage: systemImage,
                foreground: .white,
                background: Color.accentColor,
                horizontalPadding: 12,
                minWidth: 76,
                maxWidth: 108,
                minHeight: 30,
                cornerRadius: 10,
                fontWeight: .semibold,
                fontSize: 12.6,
                shadowOpacity: 0.0
            )
        } else if variant == .secondary {
            chromeActionBody(
                title: title,
                systemImage: systemImage,
                foreground: .primary,
                background: Color.white.opacity(0.50),
                horizontalPadding: 12,
                minWidth: 68,
                maxWidth: 96,
                minHeight: 30,
                cornerRadius: 10,
                fontWeight: .medium,
                fontSize: 12.6,
                shadowOpacity: 0.0
            )
        } else {
            chromeActionBody(
                title: title,
                systemImage: systemImage,
                foreground: .primary,
                background: Color.secondary.opacity(0.06),
                horizontalPadding: 12,
                minWidth: 64,
                maxWidth: 90,
                minHeight: 30,
                cornerRadius: 10,
                fontWeight: .medium,
                fontSize: 12.6,
                shadowOpacity: 0.0
            )
        }
    }

    private func chromeActionBody(
        title: String,
        systemImage: String?,
        foreground: Color,
        background: Color,
        horizontalPadding: CGFloat,
        minWidth: CGFloat,
        maxWidth: CGFloat,
        minHeight: CGFloat,
        cornerRadius: CGFloat,
        fontWeight: Font.Weight,
        fontSize: CGFloat,
        shadowOpacity: Double
    ) -> some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .semibold))
            }

            Text(title)
                .font(.system(size: fontSize, weight: fontWeight))
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .fixedSize(horizontal: true, vertical: false)
        }
        .fixedSize(horizontal: true, vertical: false)
        .foregroundStyle(foreground)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 5.5)
        .frame(minWidth: minWidth, idealWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(background)
        )
        .shadow(color: Color.black.opacity(shadowOpacity), radius: 2, y: 1)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    @ViewBuilder
    private func chromeIconPill(systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.55))

            Image(systemName: systemName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .frame(width: 30, height: 30)
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func toastView(text: String) -> some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
    }

    private func cardSurface<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    .blendMode(.overlay)
            )
            .shadow(color: .black.opacity(0.10), radius: 16, y: 6)
    }

    private func openArchive() {
        let panel = NSOpenPanel()
        panel.title = ui(.archiveActionOpenArchive)
        panel.message = ui(.archiveOpenArchivePanelMessage)
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = supportedExtensions.compactMap { UTType(filenameExtension: $0) }

        guard panel.runModal() == .OK else {
            return
        }

        let urls = panel.urls
        guard let first = urls.first else {
            return
        }

        if urls.count == 1 {
            store.loadArchive(url: first)
        } else {
            store.loadArchives(urls: urls)
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else {
            return false
        }

        _ = provider.loadObject(ofClass: URL.self) { object, _ in
            guard let url = object else { return }
            DispatchQueue.main.async {
                self.store.loadArchiveFromDrop(url: url)
            }
        }

        return true
    }
}

private struct ArchiveMetricCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let symbol: String
}

private struct LayoutMetrics {
    let windowWidth: CGFloat
    let windowHeight: CGFloat
    let hasSelection: Bool
    let hasArchiveLoaded: Bool

    var sidebarWidth: CGFloat {
        if windowWidth >= 1440 {
            return 248
        }
        if windowWidth >= 1320 {
            return 232
        }
        if windowWidth >= 1100 {
            return 220
        }
        return 72
    }

    var detailsWidth: CGFloat {
        if windowWidth >= 1500 {
            return 340
        }
        return 320
    }

    var showDetailsPanel: Bool {
        hasSelection && windowWidth >= 1320
    }

    var showSidebar: Bool {
        hasArchiveLoaded
    }

    var showCompactSidebar: Bool {
        windowWidth < 1100
    }

    var contentMinWidth: CGFloat {
        720
    }

    var tableMinWidth: CGFloat {
        680
    }

    var searchMinWidth: CGFloat {
        480
    }

    var categoryCardWidth: CGFloat {
        if windowWidth < 1320 {
            return 120
        }
        return 140
    }

    var categoryCardHeight: CGFloat {
        if windowWidth < 1320 {
            return 70
        }
        return 82
    }

    var useHorizontalCategoryCards: Bool {
        windowWidth < 1320
    }

    var contentWidthHint: CGFloat {
        let sidebar = showSidebar ? sidebarWidth : 0
        let inspector = showDetailsPanel ? detailsWidth : 0
        let gutters: CGFloat = 48
        return max(0, windowWidth - sidebar - inspector - gutters)
    }

    var tableMode: TableColumnMode {
        if contentWidthHint >= 980 {
            return .full
        }
        if contentWidthHint >= 760 {
            return .medium
        }
        return .compact
    }
}

private struct EmptyStateMetrics {
    let width: CGFloat
    let height: CGFloat

    var isCompactHeight: Bool { height < 760 }
    var isVeryCompactHeight: Bool { height < 660 }
    var isNarrow: Bool { width < 760 }

    var horizontalPadding: CGFloat {
        isNarrow ? 20 : 32
    }

    var availableWidth: CGFloat {
        max(0, width - horizontalPadding * 2)
    }

    var minContentWidth: CGFloat { 520 }
    var idealContentWidth: CGFloat { 720 }
    var maxContentWidth: CGFloat { 760 }

    var minContentWidthResolved: CGFloat {
        min(minContentWidth, availableWidth)
    }

    var idealContentWidthResolved: CGFloat {
        min(idealContentWidth, availableWidth)
    }

    var maxContentWidthResolved: CGFloat {
        min(maxContentWidth, max(minContentWidthResolved, idealContentWidthResolved))
    }

    var contentWidth: CGFloat {
        if availableWidth < minContentWidth {
            return availableWidth
        }
        return max(minContentWidth, min(idealContentWidth, min(maxContentWidth, availableWidth)))
    }

    var shouldUseNarrowLayout: Bool {
        availableWidth < minContentWidth
    }

    var verticalSpacing: CGFloat {
        if isCompactHeight { return 14 }
        return 18
    }

    var sectionSpacing: CGFloat {
        verticalSpacing
    }

    var verticalPadding: CGFloat {
        if isCompactHeight { return 24 }
        return 36
    }

    var iconSize: CGFloat {
        if isCompactHeight { return 56 }
        return 60
    }

    var titleFontSize: CGFloat {
        if isCompactHeight { return 24 }
        return 26
    }

    var subtitleFontSize: CGFloat {
        return 14
    }

    var subtitleMaxWidth: CGFloat {
        return 620
    }

    var headerSpacing: CGFloat {
        return 16
    }

    var primaryCardSpacing: CGFloat {
        if isCompactHeight { return 12 }
        return 14
    }

    var primaryCardPadding: CGFloat {
        if isCompactHeight { return 18 }
        return 20
    }

    var primaryTitleFontSize: CGFloat {
        return 18
    }

    var primarySubtitleFontSize: CGFloat {
        return 14
    }

    var pillFontSize: CGFloat {
        return 12
    }

    var pillHorizontalPadding: CGFloat {
        return 12
    }

    var pillVerticalPadding: CGFloat {
        return 7
    }

    var dropZoneHeight: CGFloat {
        if isCompactHeight { return 96 }
        return 108
    }
}

private enum TableColumnMode {
    case full
    case medium
    case compact
}
