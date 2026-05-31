import Foundation

enum ArchiveEntryCategory: String, Hashable, CaseIterable, Sendable {
    case folder
    case image
    case document
    case code
    case video
    case archive
    case executable
    case other
}

struct ArchiveEntry: Identifiable, Hashable, Sendable {
    let id: UUID
    let path: String
    let parentPath: String
    let size: Int64
    let isDirectory: Bool
    let compressedSize: Int64?
    let modifiedAt: Date?
    let fileExtension: String
    let category: ArchiveEntryCategory
    let isRisky: Bool
    let method: String?

    init(
        id: UUID = UUID(),
        path: String,
        parentPath: String? = nil,
        size: Int64,
        isDirectory: Bool,
        compressedSize: Int64? = nil,
        modifiedAt: Date? = nil,
        fileExtension: String? = nil,
        category: ArchiveEntryCategory? = nil,
        isRisky: Bool? = nil,
        method: String? = nil
    ) {
        self.id = id
        self.path = path
        self.parentPath = parentPath ?? Self.inferredParentPath(for: path)
        self.size = size
        self.isDirectory = isDirectory
        self.compressedSize = compressedSize
        self.modifiedAt = modifiedAt
        self.fileExtension = (fileExtension ?? URL(fileURLWithPath: path).pathExtension).lowercased()
        self.category = category ?? Self.inferredCategory(for: path, isDirectory: isDirectory)
        self.isRisky = isRisky ?? Self.isRiskyExtension(self.fileExtension)
        self.method = method
    }

    var name: String {
        let lastComponent = (path as NSString).lastPathComponent
        return lastComponent.isEmpty ? path : lastComponent
    }

    var formattedSize: String {
        formatSize(size)
    }

    var modificationDate: Date? {
        modifiedAt
    }

    var compressionMethod: String? {
        method
    }

    func updating(isRisky: Bool) -> ArchiveEntry {
        ArchiveEntry(
            id: id,
            path: path,
            parentPath: parentPath,
            size: size,
            isDirectory: isDirectory,
            compressedSize: compressedSize,
            modifiedAt: modifiedAt,
            fileExtension: fileExtension,
            category: category,
            isRisky: isRisky,
            method: method
        )
    }

    static func inferredCategory(for path: String, isDirectory: Bool) -> ArchiveEntryCategory {
        if isDirectory {
            return .folder
        }

        let ext = URL(fileURLWithPath: path).pathExtension.lowercased()
        if ["png", "jpg", "jpeg", "gif", "heic", "heif", "webp", "tif", "tiff", "bmp", "svg", "avif"].contains(ext) {
            return .image
        }
        if ["mp4", "mov", "avi", "mkv", "webm", "m4v", "mpg", "mpeg", "3gp"].contains(ext) {
            return .video
        }
        if ["swift", "m", "mm", "c", "cpp", "h", "hpp", "json", "js", "ts", "css", "scss", "py", "rb", "kt", "java", "go", "rs"].contains(ext) {
            return .code
        }
        if ["zip", "rar", "7z", "tar", "gz", "tgz", "bz2", "xz", "cpio", "xar", "tbz", "tbz2", "txz"].contains(ext) {
            return .archive
        }
        if ["app", "command", "sh", "bash", "zsh", "pkg", "dmg", "exe", "bat", "ps1", "jar", "workflow"].contains(ext) {
            return .executable
        }
        if ["pdf", "txt", "rtf", "md", "html", "htm", "xml", "csv", "log", "ini", "yml", "yaml", "plist"].contains(ext) {
            return .document
        }
        return .other
    }

    static func inferredParentPath(for path: String) -> String {
        let parent = URL(fileURLWithPath: path).deletingLastPathComponent().path
        return parent == "." ? "" : parent
    }

    static func isRiskyExtension(_ fileExtension: String) -> Bool {
        switch fileExtension.lowercased() {
        case "app", "command", "sh", "bash", "zsh", "pkg", "dmg", "exe", "bat", "ps1", "jar", "workflow":
            return true
        default:
            return false
        }
    }

    private func formatSize(_ size: Int64) -> String {
        guard size >= 0 else {
            return "—"
        }

        let byteCount = Double(size)
        let kilobyte = 1024.0
        let megabyte = kilobyte * 1024.0
        let gigabyte = megabyte * 1024.0

        switch byteCount {
        case ..<kilobyte:
            return "\(size) B"
        case ..<megabyte:
            return String(format: "%.1f KB", byteCount / kilobyte)
        case ..<gigabyte:
            return String(format: "%.1f MB", byteCount / megabyte)
        default:
            return String(format: "%.1f GB", byteCount / gigabyte)
        }
    }
}

enum ArchiveFileKind: String, Sendable {
    case folder
    case image
    case document
    case code
    case video
    case largeFile
    case archive
    case text
    case other
    case executable

    var title: String {
        switch self {
        case .folder: return "Folder"
        case .image: return "Image"
        case .document: return "Document"
        case .code: return "Code"
        case .video: return "Video"
        case .largeFile: return "Large File"
        case .archive: return "Archive"
        case .text: return "Text"
        case .other: return "File"
        case .executable: return "Executable"
        }
    }

    var symbolName: String {
        switch self {
        case .folder: return "folder.fill"
        case .image: return "photo"
        case .document: return "doc.text"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .video: return "video"
        case .largeFile: return "tray.full"
        case .archive: return "archivebox.fill"
        case .text: return "text.alignleft"
        case .other: return "doc"
        case .executable: return "terminal.fill"
        }
    }
}

extension ArchiveEntry {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var fileExtensionLowercased: String {
        fileExtension.lowercased()
    }

    var kind: ArchiveFileKind {
        if isDirectory {
            return .folder
        }

        switch category {
        case .folder:
            return .folder
        case .image:
            return .image
        case .document:
            if ["txt", "rtf", "md", "html", "htm", "xml", "csv", "log", "ini", "yml", "yaml", "plist"].contains(fileExtensionLowercased) {
                return .text
            }
            return .document
        case .code:
            return .code
        case .video:
            return .video
        case .archive:
            return .archive
        case .executable:
            return .executable
        case .other:
            if size >= 1_048_576 {
                return .largeFile
            }
            if ["txt", "rtf", "md", "html", "htm", "xml", "csv", "log", "ini", "yml", "yaml", "plist"].contains(fileExtensionLowercased) {
                return .text
            }
            return .other
        }
    }

    var symbolName: String {
        kind.symbolName
    }

    var kindLabel: String {
        kind.title
    }

    var formattedModifiedDate: String {
        guard let modifiedAt else { return "—" }
        return Self.dateFormatter.string(from: modifiedAt)
    }

    var formattedCompressionMethod: String {
        method ?? "—"
    }

    var formattedCompressedSize: String {
        guard let compressedSize, compressedSize >= 0 else { return "—" }
        return ByteCountFormatter.string(fromByteCount: compressedSize, countStyle: .file)
    }

    var isHidden: Bool {
        let components = path.split(separator: "/").map(String.init)
        return components.contains { $0.hasPrefix(".") || $0 == "__MACOSX" }
            || name.hasPrefix(".")
    }

    var isJunkFile: Bool {
        let lower = name.lowercased()
        return lower == ".ds_store"
            || lower == "thumbs.db"
            || lower == "desktop.ini"
            || parentPath.contains("__MACOSX")
    }

    var isHiddenOrJunk: Bool {
        isHidden || isJunkFile
    }

    var displayPath: String {
        if isDirectory {
            return parentPath.isEmpty ? path : parentPath
        }
        return parentPath.isEmpty ? "—" : parentPath
    }
}
