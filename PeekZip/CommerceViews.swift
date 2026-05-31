import AppKit
import SwiftUI

struct ProPaywallView: View {
    let state: ProPaywallState
    let onUnlock: () -> Void
    let onRestorePurchase: () -> Void
    let onContinueFree: () -> Void
    @State private var isPurchasing = false
    @State private var isRestoring = false

    var body: some View {
        GeometryReader { proxy in
            let width = min(600, max(480, proxy.size.width * 0.82))
            let height = min(680, max(520, proxy.size.height * 0.86))
            let priceParts = L10n.paywallPriceParts

            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 18) {
                        header
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 28)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            contextCallout
                            featureList
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 18)
                        .padding(.bottom, 18)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)

                    pricingCard(priceParts: priceParts)
                        .padding(.horizontal, 28)
                        .padding(.top, 6)
                        .padding(.bottom, 16)

                    Divider()
                        .padding(.horizontal, 28)

                    buttonBar
                        .padding(.horizontal, 28)
                        .padding(.top, 14)
                        .padding(.bottom, 22)
                }
                .frame(width: width, height: height, alignment: .topLeading)

                closeButton
                    .padding(.top, 14)
                    .padding(.trailing, 14)
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .frame(minWidth: 480, minHeight: 520)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            AppIconView(size: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.string(.paywallTitle))
                    .font(.system(size: 27, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(L10n.string(.paywallSubtitle))
                    .font(.system(size: 14.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
    }

    private var contextCallout: some View {
        let highlight = L10n.highlight(for: state.feature)

        return HStack(alignment: .top, spacing: 10) {
            Image(systemName: paywallContextSymbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.accentColor.opacity(0.88))

            Text(highlight.isEmpty ? L10n.string(.paywallSubtitle) : highlight)
                .font(.system(size: 13.5, weight: .medium))
                .foregroundStyle(.primary.opacity(0.86))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.44), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(L10n.featureRows, id: \.self) { row in
                featureRow(row)
            }
        }
    }

    private func featureRow(_ row: L10n.PaywallFeatureRow) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))

                Image(systemName: row.iconName)
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundStyle(Color.accentColor.opacity(0.88))
            }
            .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(row.title)
                    .font(.system(size: 14.5, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(row.subtitle)
                    .font(.system(size: 12.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }

    private func pricingCard(priceParts: (badge: String, price: String)) -> some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.string(.paywallLifetimePro))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(L10n.string(.paywallOneTimePurchase))
                    .font(.system(size: 12.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 2) {
                if !priceParts.price.isEmpty {
                    Text(priceParts.price)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                } else {
                    Text(priceParts.badge)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                if !priceParts.badge.isEmpty && !priceParts.price.isEmpty {
                    Text(priceParts.badge)
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .layoutPriority(2)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.72), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var buttonBar: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: 10) {
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
                .buttonStyle(PaywallTextButtonStyle())
                .focusable(false)
                .disabled(isBusy)

                Spacer(minLength: 16)

                Button {
                    onContinueFree()
                } label: {
                    Text(L10n.string(.paywallContinueFree))
                }
                .buttonStyle(PaywallSecondaryButtonStyle())
                .focusable(false)
                .disabled(isBusy)

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

            VStack(alignment: .leading, spacing: 10) {
                HStack {
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
                    .buttonStyle(PaywallTextButtonStyle())
                    .focusable(false)
                    .disabled(isBusy)

                    Spacer(minLength: 0)
                }

                HStack(spacing: 10) {
                    Button {
                        onContinueFree()
                    } label: {
                        Text(L10n.string(.paywallContinueFree))
                    }
                    .buttonStyle(PaywallSecondaryButtonStyle())
                    .focusable(false)
                    .disabled(isBusy)

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
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private var isBusy: Bool {
        isPurchasing || isRestoring
    }

    private func beginPurchase() {
        guard !isBusy else { return }
        isPurchasing = true
        onUnlock()
    }

    private func beginRestorePurchase() {
        guard !isBusy else { return }
        isRestoring = true
        onRestorePurchase()
    }

    private var closeButton: some View {
        Button {
            onContinueFree()
        } label: {
            ZStack {
                Circle()
                    .fill(Color(nsColor: .controlBackgroundColor).opacity(0.75))
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 36, height: 36)
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

    var body: some View {
        Form {
            Section(L10n.string(.settingsGeneralTitle)) {
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

                Button(license.isPro ? L10n.string(.settingsProActive) : L10n.string(.settingsUnlockPro)) {
                    if license.isPro {
                        return
                    }
                    license.unlockProForTesting()
                }
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 520, height: 420)
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
