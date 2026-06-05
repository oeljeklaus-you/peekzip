import AppKit
import SwiftUI

struct ProPaywallView: View {
    let state: ProPaywallState
    let onUnlock: () async -> Void
    let onRestorePurchase: () async -> Void
    let onContinueFree: () -> Void
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    @State private var isPurchasing = false
    @State private var isRestoring = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(nsColor: .windowBackgroundColor).opacity(0.98))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.10), radius: 22, x: 0, y: 14)

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 18) {
                            header
                            highlightPill
                        }

                        featureList
                        pricingCardSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 30)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                Divider()

                actionFooter
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    .background(.regularMaterial)
            }

            closeButton
                .padding(.top, 14)
                .padding(.trailing, 14)
                .zIndex(1)
        }
        .frame(minWidth: 720, idealWidth: 780, maxWidth: 860)
        .frame(minHeight: 620, idealHeight: 760, maxHeight: 860)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            AppIconView(size: 52)

            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.string(.paywallTitle))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)

                Text(L10n.string(.paywallSubtitle))
                    .font(.system(size: 15.5, weight: .medium))
                    .foregroundStyle(Color.secondary.opacity(0.92))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
    }

    private var highlightPill: some View {
        let highlight = L10n.highlight(for: state.feature)

        return HStack(alignment: .center, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color.accentColor.opacity(0.10))

                Image(systemName: paywallContextSymbol)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.accentColor.opacity(0.92))
            }
            .frame(width: 28, height: 28)

            Text(highlight.isEmpty ? L10n.string(.paywallSubtitle) : highlight)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary.opacity(0.86))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.64), in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(displayFeatureRows, id: \.self) { row in
                featureRow(row)
            }
        }
    }

    private var displayFeatureRows: [L10n.PaywallFeatureRow] {
        let hiddenTitle: String
        switch state.feature {
        case .fullLargeArchiveIndex:
            hiddenTitle = L10n.string(.paywallFeatureFullIndexing)
        case .multiArchiveSearch:
            hiddenTitle = L10n.string(.paywallFeatureMultiArchiveSearch)
        case .passwordArchive:
            hiddenTitle = L10n.string(.paywallFeaturePasswordSupport)
        case .batchExtractByType:
            hiddenTitle = L10n.string(.paywallFeatureBatchExtract)
        case .riskFileDetection:
            hiddenTitle = L10n.string(.paywallFeatureRiskDetection)
        }
        return L10n.featureRows.filter { $0.title != hiddenTitle }
    }

    private func featureRow(_ row: L10n.PaywallFeatureRow) -> some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.accentColor.opacity(0.10))

                Image(systemName: row.iconName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.accentColor.opacity(0.92))
            }
            .frame(width: 38, height: 38)

            VStack(alignment: .leading, spacing: 3) {
                Text(row.title)
                    .font(.system(size: 15.5, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)

                Text(row.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.secondary.opacity(0.88))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }

    private func pricingCard(priceLabel: String, priceValue: String) -> some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.string(.paywallLifetimePro))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(L10n.string(.paywallOneTimePurchase))
                    .font(.system(size: 13))
                    .foregroundStyle(Color.secondary.opacity(0.90))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 2) {
                Text(priceValue)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(priceLabel)
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundStyle(Color.secondary.opacity(0.88))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .layoutPriority(2)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var pricingCardSection: some View {
        pricingCard(priceLabel: L10n.paywallPriceBadge, priceValue: displayPrice)
    }

    private var displayPrice: String {
        if let price = purchaseManager.proProduct?.displayPrice {
            return price
        }
        return purchaseManager.didFinishProductLoad ? "Product not found" : L10n.string(.paywallPriceLoading)
    }

    private var actionFooter: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                restorePurchaseButton
                Spacer(minLength: 0)
                continueFreeButton
                unlockProButton
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 10) {
                unlockProButton

                HStack(spacing: 10) {
                    restorePurchaseButton
                    continueFreeButton
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private var continueFreeButton: some View {
        Button {
            onContinueFree()
        } label: {
            Text(L10n.string(.paywallContinueFree))
        }
        .buttonStyle(PaywallSecondaryButtonStyle())
        .focusable(false)
        .disabled(isBusy)
    }

    private var restorePurchaseButton: some View {
        Button {
            beginRestorePurchase()
        } label: {
            if isRestoring {
                HStack(spacing: 6) {
                    ProgressView()
                        .controlSize(.mini)
                    Text(L10n.string(.paywallRestoring))
                }
            } else {
                Text(L10n.string(.paywallRestorePurchase))
            }
        }
        .buttonStyle(PaywallAuxiliaryButtonStyle())
        .focusable(false)
        .disabled(isBusy)
    }

    private var unlockProButton: some View {
        Button {
            beginPurchase()
        } label: {
            if isPurchasing {
                HStack(spacing: 6) {
                    ProgressView()
                        .controlSize(.mini)
                    Text(L10n.string(.paywallUnlocking))
                }
            } else {
                Label(L10n.string(.paywallUnlockPro), systemImage: "sparkles")
            }
        }
        .buttonStyle(PaywallPrimaryPurchaseButtonStyle())
        .focusable(false)
        .disabled(isBusy)
    }

    private var isBusy: Bool {
        isPurchasing || isRestoring
    }

    private func beginPurchase() {
        AppEventLogger.iap("unlock button tapped")
        guard !isBusy else {
            AppEventLogger.iap("unlock tap ignored: busy")
            return
        }
        Task { @MainActor in
            isPurchasing = true
            defer { isPurchasing = false }
            await onUnlock()
        }
    }

    private func beginRestorePurchase() {
        AppEventLogger.iap("restore tapped")
        guard !isBusy else {
            AppEventLogger.iap("restore tap ignored: busy")
            return
        }
        Task { @MainActor in
            isRestoring = true
            defer { isRestoring = false }
            await onRestorePurchase()
        }
    }

    private var closeButton: some View {
        Button {
            onContinueFree()
        } label: {
            ZStack {
                Circle()
                    .fill(Color(nsColor: .controlBackgroundColor).opacity(0.92))
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
        .focusable(false)
        .opacity(0.95)
        .accessibilityLabel(Text(L10n.string(.paywallClose)))
    }

    private var paywallContextSymbol: String {
        switch state.feature {
        case .fullLargeArchiveIndex:
            return "tray.full.fill"
        case .multiArchiveSearch:
            return "magnifyingglass.circle.fill"
        case .passwordArchive:
            return "lock.fill"
        case .batchExtractByType:
            return "square.stack.3d.down.right.fill"
        case .riskFileDetection:
            return "exclamationmark.shield.fill"
        }
    }
}

struct PasswordPromptView: View {
    let state: PasswordPromptState
    let onCancel: () -> Void
    let onUnlock: (String, Bool) -> Void
    @State private var password: String = ""
    @State private var rememberPasswordForSession: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.string(.passwordPromptTitle))
                    .font(.title2.bold())
                Text(state.archiveName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(state.message)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            SecureField(L10n.string(.passwordPromptPasswordPlaceholder), text: $password)
                .textFieldStyle(.roundedBorder)

            Toggle(L10n.string(.passwordPromptRememberSession), isOn: $rememberPasswordForSession)

            HStack {
                Spacer()
                Button(L10n.string(.passwordPromptCancel)) {
                    onCancel()
                }
                Button(L10n.string(.passwordPromptUnlockArchive)) {
                    onUnlock(password, rememberPasswordForSession)
                }
                .buttonStyle(.borderedProminent)
                .disabled(password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(24)
        .frame(width: 440)
        .onAppear {
            if password.isEmpty {
                rememberPasswordForSession = state.rememberPasswordForSession
            }
        }
    }
}

struct BatchExtractCustomTypesView: View {
    let request: CustomTypeRequest
    let onCancel: () -> Void
    let onExtract: (Set<String>) -> Void
    @State private var value: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.string(.archiveBatchExtractCustomTitle))
                    .font(.title2.bold())
                Text(L10n.string(.batchExtractCustomSubtitle))
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            TextField(L10n.string(.batchExtractCustomPlaceholder), text: $value)
                .textFieldStyle(.roundedBorder)

            HStack {
                Spacer()
                Button(L10n.string(.batchExtractCustomCancel)) {
                    onCancel()
                }
                Button(L10n.string(.batchExtractCustomExtract)) {
                    let extensions = value.split(separator: ",")
                    let normalized = extensions
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                        .filter { !$0.isEmpty }
                    onExtract(Set(normalized))
                }
                .buttonStyle(.borderedProminent)
                .disabled(value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(24)
        .frame(width: 460)
        .onAppear {
            if value.isEmpty {
                value = request.value
            }
        }
    }
}

struct SettingsView: View {
    @ObservedObject private var preferences = AppPreferences.shared
    @ObservedObject private var license = LicenseManager.shared
    private let systemLanguageTag = "system"

    var body: some View {
        Form {
            Section(L10n.string(.settingsGeneralTitle)) {
                Picker(
                    L10n.string(.settingsLanguageTitle),
                    selection: Binding(
                        get: {
                            if let selectedLanguageCode = preferences.selectedLanguageCode,
                               L10n.supportedLocaleCodes.contains(selectedLanguageCode) {
                                return selectedLanguageCode
                            }
                            return systemLanguageTag
                        },
                        set: { newValue in
                            preferences.selectedLanguageCode = newValue == systemLanguageTag ? nil : newValue
                        }
                    )
                ) {
                    Text(L10n.string(.settingsLanguageFollowSystem))
                        .tag(systemLanguageTag)

                    ForEach(L10n.supportedLocaleCodes, id: \.self) { localeCode in
                        Text(L10n.displayName(for: localeCode))
                            .tag(localeCode)
                    }
                }
                .pickerStyle(.menu)

                Toggle(L10n.string(.settingsRevealAfterExtract), isOn: $preferences.revealAfterExtract)
                Toggle(L10n.string(.settingsKeepFolderStructure), isOn: $preferences.keepFolderStructure)
                Toggle(L10n.string(.settingsSkipJunkFilesOnExtract), isOn: $preferences.skipJunkFilesOnExtract)
            }

            Section(L10n.string(.settingsDefaultExtractLocationTitle)) {
                Button(L10n.string(.settingsChooseFolder)) {
                    chooseDefaultLocation()
                }

                if let path = preferences.defaultExtractLocationPath {
                    Text(path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(L10n.string(.settingsUseSystemDefaultLocation))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section(L10n.string(.settingsProTitle)) {
                HStack {
                    Text(L10n.string(.settingsLicenseStatus))
                    Spacer()
                    Text(license.isPro ? L10n.string(.settingsProActive) : L10n.string(.settingsFree))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 520, height: 460)
    }

    private func chooseDefaultLocation() {
        let panel = NSOpenPanel()
        panel.title = L10n.string(.settingsDefaultExtractLocationPanelTitle)
        panel.message = L10n.string(.settingsDefaultExtractLocationPanelMessage)
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        preferences.defaultExtractLocationPath = url.path
    }
}
