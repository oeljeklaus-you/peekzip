import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var store = ArchiveStore.shared
    @ObservedObject private var preferences = AppPreferences.shared
    @State private var hoveredEntryID: UUID?
    @State private var windowSize: CGSize = .zero
    @State private var showInspectorPopover = false
    @State private var isHoveringOpenArchiveButton = false
    @State private var isHoveringSampleArchiveButton = false

    private let supportedExtensions = [
        "zip", "rar", "7z", "tar", "gz", "tgz", "bz2", "tbz2", "tbz", "xz", "txz", "cpio", "xar"
    ]

    private var isDarkMode: Bool {
        colorScheme == .dark
    }

    private var emptyPrimaryCardFill: Color {
        isDarkMode ? Color(nsColor: .controlBackgroundColor).opacity(0.92) : Color.white.opacity(0.84)
    }

    private var emptyFeatureCardFill: Color {
        isDarkMode ? Color(nsColor: .controlBackgroundColor).opacity(0.86) : Color(nsColor: .controlBackgroundColor).opacity(0.72)
    }

    private var emptyElevatedTileFill: Color {
        isDarkMode ? Color.white.opacity(0.08) : Color.white.opacity(0.68)
    }

    private var emptyChipFill: Color {
        isDarkMode ? Color.white.opacity(0.10) : Color.white.opacity(0.62)
    }

    private var emptyDropZoneFill: Color {
        isDarkMode ? Color.white.opacity(0.08) : Color.white.opacity(0.55)
    }

    private var emptyHairlineStroke: Color {
        isDarkMode ? Color.white.opacity(0.10) : Color.white.opacity(0.35)
    }

    private var emptyBorderStroke: Color {
        isDarkMode ? Color.black.opacity(0.35) : Color.black.opacity(0.065)
    }

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
            }
            .onChange(of: proxy.size) { newSize in
                windowSize = newSize
            }
        }
        .id(preferences.selectedLanguageCode ?? "system")
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
                    await store.handleProUnlockRequest()
                },
                onRestorePurchase: {
                    await store.restorePurchases()
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
        GeometryReader { proxy in
            let metrics = EmptyStateMetrics(size: proxy.size)

            ZStack {
                // 修改点 1：背景只保留极轻的品牌氛围，避免整页雾化。
                Color(nsColor: .windowBackgroundColor)
                    .allowsHitTesting(false)

                RadialGradient(
                    colors: [
                        Color.orange.opacity(metrics.isExpanded ? 0.018 : 0.012),
                        Color.clear
                    ],
                    center: .topLeading,
                    startRadius: 80,
                    endRadius: 520
                )
                .blur(radius: 28)
                .allowsHitTesting(false)

                RadialGradient(
                    colors: [
                        Color.accentColor.opacity(metrics.isExpanded ? 0.010 : 0.006),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 120,
                    endRadius: 620
                )
                .blur(radius: 32)
                .allowsHitTesting(false)

                Group {
                    if proxy.size.height < 560 || proxy.size.width < 620 {
                        ScrollView(.vertical, showsIndicators: false) {
                            emptyStateContent(metrics: metrics)
                                .padding(.horizontal, metrics.horizontalPadding)
                                .padding(.vertical, metrics.verticalPadding)
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        emptyStateContent(metrics: metrics)
                            .padding(.horizontal, metrics.horizontalPadding)
                            .padding(.vertical, metrics.verticalPadding)
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func emptyStateContent(metrics: EmptyStateMetrics) -> some View {
        // 修改点 2：把空状态明确拆成 Hero 和 Core Content，两层结构更清晰。
        Group {
            if metrics.isExpanded {
                HStack(alignment: .top, spacing: metrics.columnSpacing) {
                    VStack(alignment: .leading, spacing: metrics.heroToBodySpacing) {
                        emptyStateHeader(metrics: metrics)

                        primaryActionPanel(metrics: metrics)
                            .frame(width: metrics.primaryPanelWidth)
                            .frame(height: metrics.panelHeight, alignment: .top)
                            .frame(minHeight: metrics.primaryPanelMinHeight, alignment: .top)
                    }
                    .frame(width: metrics.primaryPanelWidth, alignment: .leading)

                    featureValuePanel(metrics: metrics)
                        .frame(width: metrics.featurePanelWidth)
                        .frame(height: metrics.panelHeight, alignment: .top)
                        .padding(.top, metrics.featurePanelTopInset)
                }
                .frame(width: metrics.contentWidth)
            } else {
                VStack(alignment: .leading, spacing: metrics.heroToBodySpacing) {
                    emptyStateHeader(metrics: metrics)

                    if metrics.useTwoColumns {
                        HStack(alignment: .top, spacing: metrics.columnSpacing) {
                            primaryActionPanel(metrics: metrics)
                                .frame(width: metrics.primaryPanelWidth)
                                .frame(height: metrics.panelHeight, alignment: .top)
                                .frame(minHeight: metrics.primaryPanelMinHeight, alignment: .top)

                            featureValuePanel(metrics: metrics)
                                .frame(width: metrics.featurePanelWidth)
                                .frame(height: metrics.panelHeight, alignment: .top)
                                .padding(.top, metrics.featurePanelTopInset)
                        }
                        .frame(width: metrics.contentWidth)
                    } else {
                        VStack(spacing: metrics.columnSpacing) {
                            primaryActionPanel(metrics: metrics)
                            featureValuePanel(metrics: metrics)
                        }
                        .frame(width: metrics.contentWidth)
                    }
                }
            }
        }
        .frame(width: metrics.contentWidth, alignment: .leading)
        .scaleEffect(metrics.shouldScaleContent ? metrics.contentScale : 1.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .offset(y: metrics.contentYOffset)
    }

    private func emptyStateHeader(metrics: EmptyStateMetrics) -> some View {
        // 修改点 3：Hero 更像产品首页头部，而不是普通标题块。
        HStack(alignment: .center, spacing: metrics.headerSpacing) {
            AppIconView(size: metrics.heroIconSize)
                .shadow(color: Color.orange.opacity(metrics.isExpanded ? 0.12 : 0.07), radius: metrics.isExpanded ? 12 : 8, y: metrics.isExpanded ? 5 : 3)
                .background {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.orange.opacity(metrics.isExpanded ? 0.08 : 0.05),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: metrics.heroIconSize * 0.60
                            )
                        )
                        .frame(width: metrics.heroIconSize, height: metrics.heroIconSize)
                        .blur(radius: metrics.isExpanded ? 8 : 6)
                }

            VStack(alignment: .leading, spacing: metrics.heroTextSpacing) {
                Text(ui(.emptyHomeTitle))
                    .font(.system(size: metrics.titleSize, weight: .bold, design: .rounded))
                    .tracking(metrics.heroTitleTracking)
                    .foregroundStyle(.primary)
                    .lineLimit(metrics.isExpanded ? 1 : 2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(ui(.emptyHomeSubtitle))
                    .font(.system(size: metrics.subtitleSize, weight: .regular))
                    .foregroundStyle(Color.secondary.opacity(0.88))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: metrics.heroSubtitleWidth, alignment: .leading)

                Label {
                    Text("ZIP · RAR · 7Z · TAR")
                        .font(.system(size: metrics.heroValueSize, weight: .semibold))
                        .foregroundStyle(Color.secondary.opacity(0.84))
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "archivebox")
                        .font(.system(size: metrics.heroValueSize, weight: .semibold))
                        .foregroundStyle(Color.accentColor.opacity(0.9))
                }
                .padding(.top, 4)
            }
            .padding(.trailing, 12)

            Spacer(minLength: 0)
        }
        .padding(.leading, metrics.heroLeadingInset)
        .padding(.vertical, metrics.heroVerticalPadding)
        .frame(width: metrics.heroFrameWidth, alignment: .leading)
        .frame(maxWidth: metrics.isExpanded ? metrics.primaryPanelWidth : metrics.contentWidth, alignment: metrics.isExpanded ? .center : .leading)
    }

    private func primaryActionPanel(metrics: EmptyStateMetrics) -> some View {
        // 修改点 4：左侧主卡按“标题 -> 按钮 -> 拖拽区”重组节奏，突出主入口。
        VStack(alignment: .leading, spacing: metrics.primaryPanelSpacing) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(ui(.emptyPrimaryTitle))
                        .font(.system(size: metrics.primaryTitleSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Text(ui(.emptyPrimarySubtitle))
                        .font(.system(size: metrics.primarySubtitleSize))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 12)

                smallArchiveBadge(metrics: metrics)
            }

            if metrics.useVerticalActionButtons {
                VStack(spacing: 8) {
                    openArchiveButton(metrics: metrics)
                        .frame(maxWidth: .infinity)

                    trySampleButton(metrics: metrics)
                        .frame(maxWidth: .infinity)
                }
            } else {
                HStack(spacing: 12) {
                    openArchiveButton(metrics: metrics)
                    trySampleButton(metrics: metrics)
                }
            }

            compactDropZone(metrics: metrics)
        }
        .padding(metrics.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(primaryPanelBackground(metrics: metrics))
        .clipShape(RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.045), radius: 14, x: 0, y: 8)
    }

    private func featureValuePanel(metrics: EmptyStateMetrics) -> some View {
        // 修改点 5：右侧不再是说明列表，而是卡片式能力摘要面板。
        VStack(alignment: .leading, spacing: metrics.featurePanelSpacing) {
            HStack(spacing: 10) {
                Text(ui(.emptyFeaturesTitle))
                    .font(.system(size: metrics.featuresTitleSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Spacer(minLength: 0)

                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary.opacity(0.6))
            }

            VStack(spacing: metrics.featureRowSpacing) {
                featureRow(
                    icon: "magnifyingglass",
                    title: ui(.emptyFeatureSearchTitle),
                    subtitle: ui(.emptyFeatureSearchSubtitle),
                    metrics: metrics
                )

                featureRow(
                    icon: "square.grid.2x2",
                    title: ui(.emptyFeatureBrowseTitle),
                    subtitle: ui(.emptyFeatureBrowseSubtitle),
                    metrics: metrics
                )

                featureRow(
                    icon: "tray.and.arrow.down",
                    title: ui(.emptyFeatureExtractTitle),
                    subtitle: ui(.emptyFeatureExtractSubtitle),
                    metrics: metrics
                )
            }

            Spacer(minLength: metrics.featurePanelFlexibleGap)

            Divider()
                .opacity(0.6)

            supportedFormatsCompact(metrics: metrics)
        }
        .padding(metrics.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(featurePanelBackground(metrics: metrics))
        .clipShape(RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.032), radius: 10, x: 0, y: 6)
    }

    private func featureRow(icon: String, title: String, subtitle: String, metrics: EmptyStateMetrics) -> some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: metrics.featureIconCornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.accentColor.opacity(0.12),
                                Color.accentColor.opacity(0.07)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: metrics.featureIconCornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.55), lineWidth: 1)

                Image(systemName: icon)
                    .font(.system(size: metrics.featureIconSize, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: metrics.featureIconTileSize, height: metrics.featureIconTileSize)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: metrics.featureRowTitleSize, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Text(subtitle)
                    .font(.system(size: metrics.featureRowSubtitleSize))
                    .foregroundStyle(Color.secondary.opacity(0.82))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: metrics.featureRowCornerRadius, style: .continuous)
                .fill(emptyElevatedTileFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: metrics.featureRowCornerRadius, style: .continuous)
                .stroke(isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.04), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.018), radius: 5, y: 2)
    }

    private func supportedFormatsCompact(metrics: EmptyStateMetrics) -> some View {
        VStack(alignment: .leading, spacing: metrics.tier == .expanded ? 10 : 8) {
            Text(ui(.emptyFormatsTitle))
                .font(.system(size: metrics.formatsTitleSize, weight: .semibold))
                .foregroundStyle(Color.secondary.opacity(0.85))

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: metrics.formatPillMinWidth), spacing: metrics.formatGridSpacing)],
                alignment: .leading,
                spacing: metrics.formatGridSpacing
            ) {
                formatPill("ZIP", metrics: metrics)
                formatPill("RAR", metrics: metrics)
                formatPill("7Z", metrics: metrics)
                formatPill("TAR", metrics: metrics)
                formatPill("GZ", metrics: metrics)
                formatPill("BZ2", metrics: metrics)
                formatPill("XZ", metrics: metrics)
            }
        }
    }

    private func formatPill(_ text: String, metrics: EmptyStateMetrics) -> some View {
        Text(text)
            .font(.system(size: metrics.formatPillFontSize, weight: .semibold))
            .foregroundStyle(Color.secondary.opacity(0.90))
            .padding(.horizontal, metrics.tier == .expanded ? 10 : 8)
            .frame(minWidth: metrics.formatPillMinWidth, minHeight: metrics.formatPillHeight)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(emptyChipFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.045), lineWidth: 1)
            )
    }

    private func compactDropZone(metrics: EmptyStateMetrics) -> some View {
        // 修改点 6：DropZone 作为辅助入口保持清晰可交互，但不抢主按钮焦点。
        ZStack {
            RoundedRectangle(cornerRadius: metrics.dropZoneCornerRadius, style: .continuous)
                .fill(emptyDropZoneFill)

            RoundedRectangle(cornerRadius: metrics.dropZoneCornerRadius, style: .continuous)
                .stroke(style: StrokeStyle(lineWidth: 1.2, dash: [7, 7]))
                .foregroundStyle(Color.secondary.opacity(0.28))

            VStack(spacing: metrics.tier == .expanded ? 7 : 5) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.11))
                        .frame(width: metrics.dropZoneBadgeSize, height: metrics.dropZoneBadgeSize)

                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: metrics.dropZoneGlyphSize, weight: .medium))
                        .foregroundStyle(Color.accentColor.opacity(0.95))
                }

                Text(ui(.archiveDropTitle))
                    .font(.system(size: metrics.dropZoneTitleSize, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                Text(ui(.archiveDropSubtitle))
                    .font(.system(size: metrics.dropZoneSubtitleSize))
                    .foregroundStyle(Color.secondary.opacity(0.85))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.9)
            }
            .padding(.horizontal, 14)
            .padding(.top, metrics.tier == .expanded ? 2 : 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: metrics.dropZoneHeight)
    }

    private func smallArchiveBadge(metrics: EmptyStateMetrics) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "archivebox.fill")
                .font(.system(size: 11, weight: .semibold))
            Text("ZIP · RAR · 7Z")
                .font(.system(size: metrics.archiveBadgeFontSize, weight: .semibold))
                .lineLimit(1)
        }
        .foregroundStyle(Color.secondary.opacity(0.85))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(emptyChipFill)
        )
        .overlay(
            Capsule()
                .stroke(isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private func openArchiveButton(metrics: EmptyStateMetrics) -> some View {
        Button {
            openArchive()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "plus")
                    .font(.system(size: metrics.actionButtonFontSize - 0.5, weight: .semibold))

                Text(ui(.archiveEmptyOpenArchive))
                    .font(.system(size: metrics.actionButtonFontSize, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .foregroundStyle(.white)
            .frame(minWidth: metrics.openButtonMinWidth, minHeight: metrics.actionButtonHeight)
            .frame(maxWidth: metrics.useVerticalActionButtons ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.accentColor.opacity(isHoveringOpenArchiveButton ? 1.0 : 0.96),
                                Color.accentColor.opacity(isHoveringOpenArchiveButton ? 0.94 : 0.84)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(isHoveringOpenArchiveButton ? 0.18 : 0.10), lineWidth: 1)
            )
            .scaleEffect(isHoveringOpenArchiveButton ? 1.01 : 1.0)
            .shadow(color: Color.accentColor.opacity(isHoveringOpenArchiveButton ? 0.24 : 0.18), radius: isHoveringOpenArchiveButton ? 10 : 8, y: 4)
        }
        .buttonStyle(.plain)
        .onHover { isHoveringOpenArchiveButton = $0 }
    }

    private func trySampleButton(metrics: EmptyStateMetrics) -> some View {
        Button {
            openArchive()
        } label: {
            Text(ui(.archiveEmptyTrySampleArchive))
                .font(.system(size: metrics.actionButtonFontSize, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .foregroundStyle(.primary)
                .frame(minWidth: metrics.sampleButtonMinWidth, minHeight: metrics.actionButtonHeight)
                .frame(maxWidth: metrics.useVerticalActionButtons ? .infinity : nil)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isDarkMode ? Color.white.opacity(isHoveringSampleArchiveButton ? 0.14 : 0.10) : Color.white.opacity(isHoveringSampleArchiveButton ? 0.82 : 0.72))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isDarkMode ? Color.white.opacity(isHoveringSampleArchiveButton ? 0.12 : 0.08) : Color.black.opacity(isHoveringSampleArchiveButton ? 0.09 : 0.06), lineWidth: 1)
                )
                .scaleEffect(isHoveringSampleArchiveButton ? 1.01 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { isHoveringSampleArchiveButton = $0 }
    }

    private func primaryPanelBackground(metrics: EmptyStateMetrics) -> some View {
        // 修改点 7：卡片从“灰板/玻璃泡泡”改成更接近 macOS 面板的实体浅卡。
        RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous)
            .fill(emptyPrimaryCardFill)
            .overlay {
                RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous)
                    .stroke(emptyHairlineStroke, lineWidth: 1)
            }
            .overlay {
                RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous)
                    .stroke(emptyBorderStroke, lineWidth: 1)
            }
    }

    private func featurePanelBackground(metrics: EmptyStateMetrics) -> some View {
        RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous)
            .fill(emptyFeatureCardFill)
            .overlay {
                RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous)
                    .stroke(isDarkMode ? Color.white.opacity(0.08) : Color.white.opacity(0.28), lineWidth: 1)
            }
            .overlay {
                RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous)
                    .stroke(isDarkMode ? Color.black.opacity(0.28) : Color.black.opacity(0.055), lineWidth: 1)
            }
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
                    chromeActionLabel(title: ui(.archiveActionUnlockFullIndex), systemImage: "sparkles", variant: .upgrade)
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
                                    badgeLabel(L10n.string(.archiveHiddenBadge), semantic: "hidden")
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

                badgeLabel(fileTypeBadgeLabel(for: entry), semantic: fileTypeBadgeSemantic(for: entry))
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
                                            badgeLabel(L10n.string(.archiveHiddenBadge), semantic: "hidden")
                                        }
                                    }
                                }

                                badgeLabel(fileTypeBadgeLabel(for: selectedEntry), semantic: fileTypeBadgeSemantic(for: selectedEntry))
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
        let displayCountText = (isLocked && filter == .riskyFiles) ? "\(count)" : (isLocked ? ui(.archiveProTag) : "\(count)")

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
                            upgradePillLabel(compact: true)
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
            menuAction(ui(.archiveMenuSearchMultipleArchives), systemImage: "magnifyingglass.circle", isEnabled: true, trailingTag: store.isPro ? nil : ui(.paywallUnlockPro), trailingTagProminent: !store.isPro) {
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
                HStack(spacing: 8) {
                    Label(L10n.string(.archiveBatchExtractByType), systemImage: "square.stack.3d.down.right")
                    Spacer(minLength: 0)
                    if !store.isPro {
                        upgradePillLabel(compact: true)
                    }
                }
            }

            menuAction(ui(.archiveMenuScanRiskyFiles), systemImage: "exclamationmark.shield", isEnabled: true, trailingTag: store.isPro ? nil : ui(.paywallUnlockPro), trailingTagProminent: !store.isPro) {
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
    private func menuAction(_ title: String, systemImage: String, isEnabled: Bool, trailingTag: String? = nil, trailingTagProminent: Bool = false, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Label(title, systemImage: systemImage)
                Spacer(minLength: 0)
                if let trailingTag {
                    if trailingTagProminent {
                        upgradePillLabel(compact: true)
                    } else {
                        Text(trailingTag)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.10), in: Capsule())
                    }
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
            label = ui(.badgeApp)
            color = .orange
        case .macOSInstaller:
            label = ui(.badgeInstaller)
            color = .orange
        case .macOSDiskImage:
            label = ui(.badgeDiskImage)
            color = .orange
        case .shellScript, .scriptFile:
            label = ui(.badgeScript)
            color = .orange
        case .windowsExecutable, .windowsScript:
            label = ui(.badgeWindows)
            color = .orange
        case .powershellScript:
            label = ui(.badgePowerShell)
            color = .orange
        case .javaArchive:
            label = ui(.badgeJava)
            color = .orange
        case .suspiciousExecutableName:
            label = ui(.badgeRisky)
            color = .orange
        case .hiddenOrJunk:
            label = ui(.archiveHiddenBadge)
            color = .secondary
        case .sensitiveConfig:
            label = ui(.badgeConfig)
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

    private func badgeLabel(_ text: String, semantic: String? = nil) -> some View {
        let token = semantic ?? text
        return TagBadgeView(text: text, tint: badgeTint(for: token), backgroundTint: badgeBackgroundTint(for: token))
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

    private func fileTypeBadgeSemantic(for entry: DisplayArchiveItem) -> String {
        fileTypeBadgeSemantic(for: entry.originalArchiveItem)
    }

    private func fileTypeBadgeSemantic(for entry: ArchiveEntry) -> String {
        if let finding = store.riskFinding(for: entry) {
            switch finding.reason {
            case .macOSAppBundle, .macOSAppExecutablePath:
                return "app"
            case .macOSInstaller:
                return "installer"
            case .macOSDiskImage:
                return "disk image"
            case .shellScript, .scriptFile:
                return "script"
            case .windowsExecutable, .windowsScript:
                return "windows"
            case .powershellScript:
                return "powershell"
            case .javaArchive:
                return "java"
            case .suspiciousExecutableName:
                return "risky"
            case .hiddenOrJunk:
                return "hidden"
            case .sensitiveConfig:
                return "config"
            }
        }

        switch entry.kind {
        case .folder:
            return "folder"
        case .image:
            return "image"
        case .document:
            return entry.fileExtensionLowercased == "pdf" ? "pdf" : "document"
        case .code:
            return "code"
        case .video:
            return "video"
        case .archive:
            return "archive"
        case .text:
            return "text"
        case .largeFile:
            return "large"
        case .other:
            return "file"
        case .executable:
            let ext = entry.fileExtensionLowercased
            if ext == "app" { return "app" }
            if ext == "pkg" { return "installer" }
            if ext == "dmg" { return "disk image" }
            if ["command", "sh", "bash", "zsh"].contains(ext) { return "script" }
            if ["exe", "scr", "bat", "cmd", "vbs"].contains(ext) { return "windows" }
            if ext == "ps1" { return "powershell" }
            if ext == "jar" { return "java" }
            return "exec"
        }
    }

    private func fileTypeBadgeLabel(for entry: ArchiveEntry) -> String {
        if let finding = store.riskFinding(for: entry) {
            switch finding.reason {
            case .macOSAppBundle, .macOSAppExecutablePath:
                return ui(.badgeApp)
            case .macOSInstaller:
                return ui(.badgeInstaller)
            case .macOSDiskImage:
                return ui(.badgeDiskImage)
            case .shellScript, .scriptFile:
                return ui(.badgeScript)
            case .windowsExecutable, .windowsScript:
                return ui(.badgeWindows)
            case .powershellScript:
                return ui(.badgePowerShell)
            case .javaArchive:
                return ui(.badgeJava)
            case .suspiciousExecutableName:
                return ui(.badgeRisky)
            case .hiddenOrJunk:
                return ui(.archiveHiddenBadge)
            case .sensitiveConfig:
                return ui(.badgeConfig)
            }
        }

        switch entry.kind {
        case .folder:
            return ui(.badgeFolder)
        case .image:
            return ui(.badgeImage)
        case .document:
            return entry.fileExtensionLowercased == "pdf" ? ui(.badgePDF) : ui(.badgeDocument)
        case .code:
            return ui(.badgeCode)
        case .video:
            return ui(.badgeVideo)
        case .archive:
            return ui(.badgeArchive)
        case .text:
            return ui(.badgeText)
        case .largeFile:
            return ui(.badgeLarge)
        case .other:
            return ui(.badgeFile)
        case .executable:
            let ext = entry.fileExtensionLowercased
            if ext == "app" { return ui(.badgeApp) }
            if ext == "pkg" { return ui(.badgeInstaller) }
            if ext == "dmg" { return ui(.badgeDiskImage) }
            if ["command", "sh", "bash", "zsh"].contains(ext) { return ui(.badgeScript) }
            if ["exe", "scr", "bat", "cmd", "vbs"].contains(ext) { return ui(.badgeWindows) }
            if ext == "ps1" { return ui(.badgePowerShell) }
            if ext == "jar" { return ui(.badgeJava) }
            return ui(.badgeExec)
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

    private enum ChromeActionVariant: Equatable {
        case primary
        case secondary
        case subtle
        case upgrade
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
        } else if variant == .upgrade {
            chromeActionBody(
                title: title,
                systemImage: systemImage,
                foreground: Color.accentColor,
                background: Color.accentColor.opacity(0.10),
                horizontalPadding: 12,
                minWidth: 92,
                maxWidth: 140,
                minHeight: 30,
                cornerRadius: 10,
                fontWeight: .semibold,
                fontSize: 12.4,
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

    private func upgradePillLabel(compact: Bool = false) -> some View {
        Text(ui(.paywallUnlockPro))
            .font(.system(size: compact ? 10.5 : 11.5, weight: .semibold))
            .foregroundStyle(Color.accentColor)
            .padding(.horizontal, compact ? 7 : 8)
            .padding(.vertical, compact ? 3 : 4)
            .background(
                Capsule()
                    .fill(Color.accentColor.opacity(0.10))
            )
            .overlay(
                Capsule()
                    .stroke(Color.accentColor.opacity(0.16), lineWidth: 1)
            )
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

private enum EmptyStateTier {
    case compact
    case regular
    case expanded
}

private struct EmptyStateMetrics {
    let size: CGSize

    var tier: EmptyStateTier {
        if size.width >= 1180 && size.height >= 760 {
            return .expanded
        }

        if size.width >= 900 && size.height >= 660 {
            return .regular
        }

        return .compact
    }

    var horizontalPadding: CGFloat {
        switch tier {
        case .compact: return 24
        case .regular: return 40
        case .expanded: return 64
        }
    }

    var availableWidth: CGFloat {
        max(0, size.width - horizontalPadding * 2)
    }

    var availableHeight: CGFloat {
        max(0, size.height - 80)
    }

    var isExpanded: Bool {
        tier == .expanded
    }

    var useTwoColumns: Bool {
        tier == .regular || tier == .expanded
    }

    var shouldScaleContent: Bool {
        tier == .compact
    }

    var primaryPanelWidth: CGFloat {
        switch tier {
        case .compact:
            return contentWidth
        case .regular:
            return contentWidth * 0.63
        case .expanded:
            return min(contentWidth * 0.64, 800)
        }
    }

    var contentWidth: CGFloat {
        switch tier {
        case .compact:
            return min(max(availableWidth, 560), 760)
        case .regular:
            return min(max(availableWidth * 0.92, 900), 1080)
        case .expanded:
            return min(max(availableWidth * 0.92, 1180), 1320)
        }
    }

    var contentScale: CGFloat {
        let widthScale = min(1.0, availableWidth / contentWidth)
        let heightScale: CGFloat

        if useTwoColumns {
            heightScale = min(1.0, availableHeight / 560)
        } else {
            heightScale = min(1.0, availableHeight / 680)
        }

        return max(0.82, min(widthScale, heightScale))
    }

    var heroIconSize: CGFloat {
        switch tier {
        case .compact: return 60
        case .regular: return 76
        case .expanded: return 82
        }
    }

    var headerIconSize: CGFloat {
        heroIconSize
    }

    var titleSize: CGFloat {
        switch tier {
        case .compact: return 28
        case .regular: return 36
        case .expanded: return 40
        }
    }

    var subtitleSize: CGFloat {
        switch tier {
        case .compact: return 14
        case .regular: return 16
        case .expanded: return 17
        }
    }

    var headerSpacing: CGFloat {
        switch tier {
        case .compact: return 18
        case .regular: return 20
        case .expanded: return 24
        }
    }

    var columnSpacing: CGFloat {
        switch tier {
        case .compact: return 16
        case .regular: return 24
        case .expanded: return 28
        }
    }

    var cardPadding: CGFloat {
        switch tier {
        case .compact: return 22
        case .regular: return 28
        case .expanded: return 28
        }
    }

    var verticalPadding: CGFloat {
        switch tier {
        case .compact: return 26
        case .regular: return 34
        case .expanded: return 32
        }
    }

    var contentYOffset: CGFloat {
        switch tier {
        case .compact: return -8
        case .regular: return -8
        case .expanded: return 2
        }
    }

    var heroLeadingInset: CGFloat {
        switch tier {
        case .compact: return 0
        case .regular: return 18
        case .expanded: return 0
        }
    }

    var heroFrameWidth: CGFloat {
        switch tier {
        case .compact:
            return contentWidth
        case .regular:
            return contentWidth
        case .expanded:
            return min(primaryPanelWidth - 132, 620)
        }
    }

    var primaryPanelMinHeight: CGFloat {
        switch tier {
        case .compact, .regular:
            return 0
        case .expanded:
            return 452
        }
    }

    var panelHeight: CGFloat? {
        switch tier {
        case .compact, .regular:
            return nil
        case .expanded:
            return 428
        }
    }

    var featurePanelTopInset: CGFloat {
        switch tier {
        case .compact, .regular:
            return 0
        case .expanded:
            return 74
        }
    }

    var cardCornerRadius: CGFloat {
        switch tier {
        case .compact: return 22
        case .regular: return 26
        case .expanded: return 26
        }
    }

    var featurePanelWidth: CGFloat {
        switch tier {
        case .compact:
            return contentWidth
        case .regular, .expanded:
            return contentWidth - primaryPanelWidth - columnSpacing
        }
    }

    var dropZoneHeight: CGFloat {
        switch tier {
        case .compact: return 108
        case .regular: return 124
        case .expanded: return 144
        }
    }

    var dropZoneCornerRadius: CGFloat {
        switch tier {
        case .compact: return 18
        case .regular: return 20
        case .expanded: return 20
        }
    }

    var dropZoneIconSize: CGFloat {
        switch tier {
        case .compact: return 26
        case .regular: return 30
        case .expanded: return 38
        }
    }

    var dropZoneBadgeSize: CGFloat {
        switch tier {
        case .compact: return 40
        case .regular: return 44
        case .expanded: return 44
        }
    }

    var dropZoneGlyphSize: CGFloat {
        switch tier {
        case .compact: return 20
        case .regular: return 22
        case .expanded: return 22
        }
    }

    var dropZoneTitleSize: CGFloat {
        switch tier {
        case .compact: return 14
        case .regular: return 16
        case .expanded: return 16
        }
    }

    var dropZoneSubtitleSize: CGFloat {
        switch tier {
        case .compact: return 12
        case .regular: return 13
        case .expanded: return 13
        }
    }

    var actionButtonHeight: CGFloat {
        switch tier {
        case .compact:
            return contentScale < 0.9 ? 36 : 40
        case .regular:
            return 46
        case .expanded:
            return 46
        }
    }

    var actionButtonFontSize: CGFloat {
        switch tier {
        case .compact:
            return contentScale < 0.9 ? 13 : 13.5
        case .regular:
            return 14.5
        case .expanded:
            return 14.5
        }
    }

    var useVerticalActionButtons: Bool {
        tier == .compact && (availableWidth < 700 || contentScale < 0.9)
    }

    var primaryPanelSpacing: CGFloat {
        switch tier {
        case .compact: return 16
        case .regular: return 20
        case .expanded: return 18
        }
    }

    var primaryTitleSize: CGFloat {
        switch tier {
        case .compact: return 20
        case .regular: return 24
        case .expanded: return 30
        }
    }

    var primarySubtitleSize: CGFloat {
        subtitleSize
    }

    var featurePanelSpacing: CGFloat {
        switch tier {
        case .compact: return 14
        case .regular: return 16
        case .expanded: return 16
        }
    }

    var featuresTitleSize: CGFloat {
        switch tier {
        case .compact: return 15
        case .regular: return 16
        case .expanded: return 17
        }
    }

    var featureRowSpacing: CGFloat {
        switch tier {
        case .compact: return 10
        case .regular: return 12
        case .expanded: return 12
        }
    }

    var featureIconTileSize: CGFloat {
        switch tier {
        case .compact: return 32
        case .regular: return 34
        case .expanded: return 40
        }
    }

    var featureIconCornerRadius: CGFloat {
        switch tier {
        case .compact: return 10
        case .regular: return 10
        case .expanded: return 10
        }
    }

    var featureIconSize: CGFloat {
        switch tier {
        case .compact: return 14
        case .regular: return 15
        case .expanded: return 16
        }
    }

    var featureRowTitleSize: CGFloat {
        switch tier {
        case .compact: return 13.5
        case .regular: return 14.5
        case .expanded: return 16
        }
    }

    var featureRowSubtitleSize: CGFloat {
        switch tier {
        case .compact: return 12.5
        case .regular: return 12.5
        case .expanded: return 13.5
        }
    }

    var featureRowCornerRadius: CGFloat {
        switch tier {
        case .compact: return 14
        case .regular: return 15
        case .expanded: return 15
        }
    }

    var formatsTitleSize: CGFloat {
        switch tier {
        case .compact: return 12.5
        case .regular: return 12.5
        case .expanded: return 12.5
        }
    }

    var formatPillHeight: CGFloat {
        switch tier {
        case .compact: return 24
        case .regular: return 28
        case .expanded: return 28
        }
    }

    var formatPillMinWidth: CGFloat {
        switch tier {
        case .compact: return 48
        case .regular: return 54
        case .expanded: return 54
        }
    }

    var formatPillFontSize: CGFloat {
        switch tier {
        case .compact: return 11.5
        case .regular: return 12
        case .expanded: return 12
        }
    }

    var formatGridSpacing: CGFloat {
        switch tier {
        case .compact: return 6
        case .regular: return 7
        case .expanded: return 8
        }
    }

    var openButtonMinWidth: CGFloat {
        switch tier {
        case .compact: return 132
        case .regular: return 150
        case .expanded: return 160
        }
    }

    var sampleButtonMinWidth: CGFloat {
        switch tier {
        case .compact: return 136
        case .regular: return 160
        case .expanded: return 168
        }
    }

    var archiveBadgeFontSize: CGFloat {
        switch tier {
        case .compact: return 11
        case .regular: return 11.5
        case .expanded: return 12
        }
    }

    var heroToBodySpacing: CGFloat {
        switch tier {
        case .compact: return 22
        case .regular: return 28
        case .expanded: return 14
        }
    }

    var heroTextSpacing: CGFloat {
        switch tier {
        case .compact: return 5
        case .regular: return 6
        case .expanded: return 7
        }
    }

    var heroTitleTracking: CGFloat {
        switch tier {
        case .compact: return -0.2
        case .regular: return -0.35
        case .expanded: return -0.35
        }
    }

    var heroSubtitleWidth: CGFloat {
        switch tier {
        case .compact: return 420
        case .regular: return 520
        case .expanded: return 640
        }
    }

    var heroValueSize: CGFloat {
        switch tier {
        case .compact: return 12
        case .regular: return 12.5
        case .expanded: return 13
        }
    }

    var heroVerticalPadding: CGFloat {
        switch tier {
        case .compact: return 4
        case .regular: return 8
        case .expanded: return 2
        }
    }

    var featurePanelFlexibleGap: CGFloat {
        switch tier {
        case .compact, .regular:
            return 0
        case .expanded:
            return 14
        }
    }

}

private enum TableColumnMode {
    case full
    case medium
    case compact
}
