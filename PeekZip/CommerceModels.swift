import AppKit
import Foundation
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

    func unlockProForTesting() {
        isProUnlocked = true
        proUnlockedAt = Date()
    }

    func resetProForTesting() {
        isProUnlocked = false
        proUnlockedAt = nil
    }

    func requirePro(feature: ProFeature) -> Bool {
        switch feature {
        case .multiArchiveSearch, .fullLargeArchiveIndex, .passwordArchive, .batchExtractByType, .riskFileDetection:
            return isPro
        }
    }
}

enum AppEventLogger {
    static func log(_ name: String, metadata: [String: String] = [:]) {
        if metadata.isEmpty {
            print("[PeekZip] event: \(name)")
        } else {
            print("[PeekZip] event: \(name) \(metadata)")
        }
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
        switch self {
        case .images: return "Images"
        case .pdfs: return "PDFs"
        case .videos: return "Videos"
        case .documents: return "Documents"
        case .code: return "Code Files"
        }
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

    private init() {
        let defaults = UserDefaults.standard
        self.revealAfterExtract = defaults.object(forKey: Keys.revealAfterExtract) as? Bool ?? true
        self.keepFolderStructure = defaults.object(forKey: Keys.keepFolderStructure) as? Bool ?? true
        self.skipJunkFilesOnExtract = defaults.object(forKey: Keys.skipJunkFilesOnExtract) as? Bool ?? true
        self.defaultExtractLocationPath = defaults.string(forKey: Keys.defaultExtractLocation)
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
