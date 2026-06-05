import Foundation

typealias ArchiveItem = ArchiveEntry

enum RiskLevel: String, Codable, CaseIterable, Hashable, Sendable {
    case high
    case medium
    case notice
}

extension RiskLevel {
    var label: String {
        switch self {
        case .high:
            return L10n.string(.badgeRisky)
        case .medium:
            return L10n.string(.badgeRisky)
        case .notice:
            return L10n.string(.archiveHiddenBadge)
        }
    }
}

enum RiskReason: String, Codable, CaseIterable, Hashable, Sendable {
    case macOSAppBundle
    case macOSAppExecutablePath
    case macOSInstaller
    case macOSDiskImage
    case shellScript
    case windowsExecutable
    case windowsScript
    case powershellScript
    case javaArchive
    case scriptFile
    case suspiciousExecutableName
    case hiddenOrJunk
    case sensitiveConfig

    var label: String {
        switch self {
        case .macOSAppBundle:
            return L10n.string(.badgeApp)
        case .macOSAppExecutablePath:
            return L10n.string(.badgeApp)
        case .macOSInstaller:
            return L10n.string(.badgeInstaller)
        case .macOSDiskImage:
            return L10n.string(.badgeDiskImage)
        case .shellScript:
            return L10n.string(.badgeScript)
        case .windowsExecutable:
            return L10n.string(.badgeWindows)
        case .windowsScript:
            return L10n.string(.badgeWindows)
        case .powershellScript:
            return L10n.string(.badgePowerShell)
        case .javaArchive:
            return L10n.string(.badgeJava)
        case .scriptFile:
            return L10n.string(.badgeScript)
        case .suspiciousExecutableName:
            return L10n.string(.badgeRisky)
        case .hiddenOrJunk:
            return L10n.string(.archiveHiddenBadge)
        case .sensitiveConfig:
            return L10n.string(.badgeConfig)
        }
    }
}

struct RiskFinding: Identifiable, Hashable, Sendable {
    let id: String
    let itemId: String
    let path: String
    let fileName: String
    let riskLevel: RiskLevel
    let reason: RiskReason
    let message: String
}

final class RiskScanner {
    static func scan(items: [ArchiveItem]) -> [RiskFinding] {
        items.compactMap { finding(for: $0) }
    }

    static func finding(for item: ArchiveItem) -> RiskFinding? {
        let lowerPath = item.path.lowercased()
        let fileName = item.name.lowercased()
        let ext = item.fileExtension.lowercased()
        let itemId = item.id.uuidString

        if let finding = highRiskFinding(itemId: itemId, lowerPath: lowerPath, fileName: fileName, ext: ext, path: item.path) {
            return finding
        }

        if let finding = mediumRiskFinding(itemId: itemId, lowerPath: lowerPath, fileName: fileName, ext: ext, path: item.path) {
            return finding
        }

        if let finding = noticeFinding(itemId: itemId, lowerPath: lowerPath, fileName: fileName, ext: ext, path: item.path) {
            return finding
        }

        return nil
    }

    static func flaggedEntries(from items: [ArchiveItem], findings: [RiskFinding]? = nil) -> [ArchiveEntry] {
        let lookup = Dictionary(uniqueKeysWithValues: (findings ?? scan(items: items)).map { ($0.itemId, $0) })
        return items.map { item in
            guard let finding = lookup[item.id.uuidString] else {
                return item.updating(isRisky: false)
            }
            return item.updating(isRisky: finding.riskLevel == .high || finding.riskLevel == .medium)
        }
    }

    private static func highRiskFinding(
        itemId: String,
        lowerPath: String,
        fileName: String,
        ext: String,
        path: String
    ) -> RiskFinding? {
        if ext == "app" || lowerPath.contains(".app/") {
            let reason: RiskReason = lowerPath.contains(".app/contents/macos/") ? .macOSAppExecutablePath : .macOSAppBundle
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .high,
                reason: reason,
                message: "macOS app bundle. Review before extracting."
            )
        }

        if ext == "pkg" || lowerPath.contains(".pkg/") {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .high,
                reason: .macOSInstaller,
                message: "macOS installer package. Review before extracting."
            )
        }

        if ["command", "sh", "bash", "zsh"].contains(ext) {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .high,
                reason: .shellScript,
                message: "Shell script that may run commands. Review before opening."
            )
        }

        if ["exe", "scr"].contains(ext) {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .high,
                reason: .windowsExecutable,
                message: "Windows executable file. Review before opening."
            )
        }

        if ["bat", "cmd", "vbs"].contains(ext) {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .high,
                reason: .windowsScript,
                message: "Windows script file. Review before opening."
            )
        }

        if ext == "ps1" {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .high,
                reason: .powershellScript,
                message: "PowerShell script. Review before opening."
            )
        }

        return nil
    }

    private static func mediumRiskFinding(
        itemId: String,
        lowerPath: String,
        fileName: String,
        ext: String,
        path: String
    ) -> RiskFinding? {
        if ext == "dmg" {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .medium,
                reason: .macOSDiskImage,
                message: "macOS disk image that may contain apps or installers."
            )
        }

        if ext == "jar" {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .medium,
                reason: .javaArchive,
                message: "Java archive that may contain executable code."
            )
        }

        if ["js", "py", "rb", "pl", "php"].contains(ext) {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .medium,
                reason: .scriptFile,
                message: "Script file. Review before running."
            )
        }

        let suspiciousNames: Set<String> = ["install", "setup", "run", "start", "bootstrap", "configure", "postinstall", "preinstall"]
        if ext.isEmpty, suspiciousNames.contains(fileName) {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .medium,
                reason: .suspiciousExecutableName,
                message: "Executable-looking file name. Review before opening."
            )
        }

        return nil
    }

    private static func noticeFinding(
        itemId: String,
        lowerPath: String,
        fileName: String,
        ext: String,
        path: String
    ) -> RiskFinding? {
        if fileName == ".ds_store" || fileName == "thumbs.db" || fileName == "desktop.ini" || fileName == ".localized" || lowerPath.contains("__macosx/") {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .notice,
                reason: .hiddenOrJunk,
                message: "System-generated or hidden file."
            )
        }

        if fileName == ".env" || fileName == ".npmrc" || fileName == ".pypirc" || fileName == ".netrc" || lowerPath.contains(".ssh/") || lowerPath.contains(".aws/") || lowerPath.contains(".config/") {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .notice,
                reason: .sensitiveConfig,
                message: "Hidden or sensitive-looking configuration file."
            )
        }

        if fileName.hasPrefix(".") && fileName != "." && fileName != ".." {
            return makeFinding(
                itemId: itemId,
                path: path,
                fileName: fileName,
                level: .notice,
                reason: .hiddenOrJunk,
                message: "Hidden file."
            )
        }

        return nil
    }

    private static func makeFinding(
        itemId: String,
        path: String,
        fileName: String,
        level: RiskLevel,
        reason: RiskReason,
        message: String
    ) -> RiskFinding {
        RiskFinding(
            id: "\(itemId):\(level.rawValue):\(reason.rawValue)",
            itemId: itemId,
            path: path,
            fileName: fileName,
            riskLevel: level,
            reason: reason,
            message: message
        )
    }
}
