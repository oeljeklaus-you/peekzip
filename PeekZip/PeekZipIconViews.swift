import AppKit
import SwiftUI

struct AppIconView: View {
    let size: CGFloat

    private var appIconImage: NSImage {
        NSImage(named: "AppIcon") ?? NSApp.applicationIconImage
    }

    var body: some View {
        Image(nsImage: appIconImage)
            .resizable()
            .renderingMode(.original)
            .interpolation(.high)
            .antialiased(true)
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.24, style: .continuous))
            .shadow(color: .black.opacity(size >= 32 ? 0.10 : 0.0), radius: size >= 32 ? max(2, size * 0.08) : 0, y: size >= 32 ? 1 : 0)
    }
}

struct ArchiveFormatIconView: View {
    let formatLabel: String
    let size: CGFloat

    var body: some View {
        let cornerRadius = max(12, size * 0.24)
        let badgeText = archiveFormatLabelText

        VStack(spacing: max(2, size * 0.08)) {
            Image(systemName: "archivebox.fill")
                .font(.system(size: size * 0.34, weight: .semibold))
                .foregroundStyle(formatTint.opacity(0.88))

            Text(badgeText)
                .font(.system(size: max(8.5, size * 0.16), weight: .bold, design: .rounded))
                .foregroundStyle(formatTint.opacity(0.98))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .frame(maxWidth: size - 10)
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(formatTint.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(formatTint.opacity(0.16), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.035), radius: 3, x: 0, y: 1)
    }

    private var archiveFormatLabelText: String {
        let trimmed = formatLabel.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        return trimmed.isEmpty ? "ARCHIVE" : trimmed
    }

    private var formatTint: Color {
        switch archiveFormatLabelText {
        case "ZIP", "TAR", "TAR.GZ", "TAR.BZ2", "TAR.XZ":
            return .orange
        case "RAR", "7Z":
            return .purple
        case "GZ", "TGZ", "BZ2", "XZ", "TBZ2", "TXZ":
            return .teal
        default:
            return .gray
        }
    }
}

struct ArchiveFileIconView: View {
    let format: String
    let size: CGFloat

    var body: some View {
        ArchiveFormatIconView(formatLabel: format, size: size)
    }
}

struct FileTypeIconView: View {
    let entry: ArchiveEntry
    var finding: RiskFinding? = nil
    var isSelected: Bool = false
    let size: CGFloat

    private var symbolName: String {
        if let finding {
            switch finding.reason {
            case .macOSAppBundle, .macOSAppExecutablePath:
                return "app.fill"
            case .macOSInstaller:
                return "shippingbox.fill"
            case .macOSDiskImage:
                return "externaldrive.fill"
            case .shellScript, .scriptFile, .windowsExecutable, .windowsScript, .powershellScript:
                return "terminal.fill"
            case .javaArchive:
                return "doc.text.fill"
            case .suspiciousExecutableName:
                return "exclamationmark.triangle.fill"
            case .hiddenOrJunk, .sensitiveConfig:
                return "doc.fill"
            }
        }

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
            if ["app"].contains(entry.fileExtensionLowercased) { return "app.fill" }
            if ["pkg"].contains(entry.fileExtensionLowercased) { return "shippingbox.fill" }
            if ["dmg"].contains(entry.fileExtensionLowercased) { return "externaldrive.fill" }
            if ["command", "sh", "bash", "zsh"].contains(entry.fileExtensionLowercased) { return "terminal.fill" }
            return "terminal.fill"
        }
    }

    private var foregroundColor: Color {
        if let finding {
            switch finding.riskLevel {
            case .high:
                return Color.orange
            case .medium:
                return Color.orange.opacity(0.88)
            case .notice:
                return Color.secondary
            }
        }

        switch entry.kind {
        case .folder:
            return isSelected ? .blue.opacity(0.95) : .blue
        case .image:
            return isSelected ? .green.opacity(0.95) : .green
        case .document, .text:
            return .secondary
        case .code:
            return isSelected ? .purple.opacity(0.95) : .purple
        case .video:
            return isSelected ? .teal.opacity(0.95) : .teal
        case .archive:
            return isSelected ? .orange.opacity(0.95) : .orange
        case .largeFile:
            return .secondary
        case .other:
            return .secondary
        case .executable:
            return .orange
        }
    }

    private var backgroundColor: Color {
        if let finding {
            switch finding.riskLevel {
            case .high:
                return Color.orange.opacity(0.16)
            case .medium:
                return Color.orange.opacity(0.11)
            case .notice:
                return Color.secondary.opacity(0.10)
            }
        }

        switch entry.kind {
        case .folder:
            return Color.blue.opacity(isSelected ? 0.20 : 0.12)
        case .image:
            return Color.green.opacity(isSelected ? 0.20 : 0.12)
        case .document, .text:
            return Color.secondary.opacity(isSelected ? 0.14 : 0.08)
        case .code:
            return Color.purple.opacity(isSelected ? 0.20 : 0.12)
        case .video:
            return Color.teal.opacity(isSelected ? 0.20 : 0.12)
        case .archive:
            return Color.orange.opacity(isSelected ? 0.20 : 0.14)
        case .largeFile:
            return Color.secondary.opacity(isSelected ? 0.14 : 0.08)
        case .other:
            return Color.secondary.opacity(isSelected ? 0.14 : 0.08)
        case .executable:
            return Color.orange.opacity(isSelected ? 0.22 : 0.14)
        }
    }

    private var strokeColor: Color {
        if let finding {
            switch finding.riskLevel {
            case .high:
                return Color.orange.opacity(0.36)
            case .medium:
                return Color.orange.opacity(0.22)
            case .notice:
                return Color.secondary.opacity(0.18)
            }
        }

        switch entry.kind {
        case .folder:
            return Color.blue.opacity(isSelected ? 0.28 : 0.20)
        case .image:
            return Color.green.opacity(isSelected ? 0.26 : 0.18)
        case .document, .text:
            return Color.secondary.opacity(isSelected ? 0.22 : 0.16)
        case .code:
            return Color.purple.opacity(isSelected ? 0.26 : 0.18)
        case .video:
            return Color.teal.opacity(isSelected ? 0.26 : 0.18)
        case .archive:
            return Color.orange.opacity(isSelected ? 0.26 : 0.20)
        case .largeFile:
            return Color.secondary.opacity(isSelected ? 0.22 : 0.16)
        case .other:
            return Color.secondary.opacity(isSelected ? 0.22 : 0.16)
        case .executable:
            return Color.orange.opacity(isSelected ? 0.30 : 0.22)
        }
    }

    private var symbolSize: CGFloat {
        max(11, size * 0.58)
    }

    var body: some View {
        let cornerRadius = max(4, size * 0.22)
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor)

            Image(systemName: symbolName)
                .font(.system(size: symbolSize, weight: .semibold))
                .foregroundStyle(foregroundColor)
                .symbolRenderingMode(.hierarchical)
        }
        .frame(width: size, height: size)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(strokeColor, lineWidth: size >= 24 ? 1 : 0.75)
        )
        .fixedSize()
        .shadow(color: .black.opacity(size >= 32 ? 0.06 : 0.0), radius: size >= 32 ? max(1.5, size * 0.05) : 0, y: size >= 32 ? 1 : 0)
        .accessibilityLabel(Text(entry.name))
    }
}
