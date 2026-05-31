import Foundation

enum ArchiveFormat: String, CaseIterable, Hashable, Sendable {
    case zip
    case tar
    case tarGzip
    case gzip
    case tarBzip2
    case bzip2
    case tarXz
    case xz
    case cpio
    case xar
    case sevenZip
    case rar
    case unknown

    var displayName: String {
        switch self {
        case .zip: return "ZIP"
        case .tar: return "TAR"
        case .tarGzip: return "TAR.GZ"
        case .gzip: return "GZ"
        case .tarBzip2: return "TAR.BZ2"
        case .bzip2: return "BZ2"
        case .tarXz: return "TAR.XZ"
        case .xz: return "XZ"
        case .cpio: return "CPIO"
        case .xar: return "XAR"
        case .sevenZip: return "7Z"
        case .rar: return "RAR"
        case .unknown: return "ARCHIVE"
        }
    }

    var isCompoundCompressedFormat: Bool {
        switch self {
        case .tarGzip, .tarBzip2, .tarXz:
            return true
        default:
            return false
        }
    }

    var isSingleFileCompression: Bool {
        switch self {
        case .gzip, .bzip2, .xz:
            return true
        default:
            return false
        }
    }
}

func displayFormatLabel(for format: ArchiveFormat) -> String {
    format.displayName
}

func archiveFormatLabel(from fileName: String) -> String {
    let lower = fileName.lowercased()

    if lower.hasSuffix(".tar.gz") {
        return "TAR.GZ"
    }
    if lower.hasSuffix(".tar.bz2") {
        return "TAR.BZ2"
    }
    if lower.hasSuffix(".tar.xz") {
        return "TAR.XZ"
    }
    if lower.hasSuffix(".tgz") {
        return "TAR.GZ"
    }
    if lower.hasSuffix(".tbz2") || lower.hasSuffix(".tbz") {
        return "TAR.BZ2"
    }
    if lower.hasSuffix(".txz") {
        return "TAR.XZ"
    }

    let fileExtension = (fileName as NSString).pathExtension.lowercased()
    switch fileExtension {
    case "zip":
        return "ZIP"
    case "rar":
        return "RAR"
    case "7z":
        return "7Z"
    case "tar":
        return "TAR"
    case "gz":
        return "GZ"
    case "bz2":
        return "BZ2"
    case "xz":
        return "XZ"
    case "cpio":
        return "CPIO"
    case "xar":
        return "XAR"
    default:
        return "ARCHIVE"
    }
}

func archiveFewItemsHint() -> String {
    L10n.string(.archiveFewItemsHint)
}

struct ArchiveStats: Hashable, Sendable {
    let fileCount: Int
    let folderCount: Int
    let imageCount: Int
    let documentCount: Int
    let codeCount: Int
    let videoCount: Int
    let archiveCount: Int
    let executableCount: Int
    let largeFileCount: Int
    let riskyCount: Int
    let unknownSizeCount: Int
    let totalSize: Int64?

    var summaryDescription: String {
        let sizeDescription: String
        if let totalSize {
            sizeDescription = ByteCountFormatter.string(fromByteCount: totalSize, countStyle: .file)
        } else {
            sizeDescription = "Unknown"
        }
        return "\(fileCount) files · \(folderCount) folders · \(sizeDescription)"
    }
}

struct LoadedArchiveState: Hashable, Sendable {
    let archiveURL: URL
    let archiveName: String
    let detectedFormat: ArchiveFormat
    let entries: [ArchiveEntry]
    let stats: ArchiveStats
    let totalSize: Int64?
}

struct UnsupportedArchiveState: Hashable, Sendable {
    let archiveName: String
    let detectedFormat: ArchiveFormat
    let message: String
}

struct DependencyRequiredArchiveState: Hashable, Sendable {
    let archiveName: String
    let detectedFormat: ArchiveFormat
    let missingTool: String
    let message: String
}

struct PasswordProtectedArchiveState: Hashable, Sendable {
    let archiveName: String
    let detectedFormat: ArchiveFormat
    let message: String
}

struct ArchiveErrorState: Hashable, Sendable {
    let archiveName: String
    let detectedFormat: ArchiveFormat
    let errorMessage: String
    let rawError: String?
}

enum ArchiveLoadState: Hashable, Sendable {
    case empty
    case loading(archiveName: String?)
    case loaded(LoadedArchiveState)
    case unsupported(UnsupportedArchiveState)
    case dependencyRequired(DependencyRequiredArchiveState)
    case passwordProtected(PasswordProtectedArchiveState)
    case error(ArchiveErrorState)

    var archiveName: String? {
        switch self {
        case .empty:
            return nil
        case .loading(let archiveName):
            return archiveName
        case .loaded(let state):
            return state.archiveName
        case .unsupported(let state):
            return state.archiveName
        case .dependencyRequired(let state):
            return state.archiveName
        case .passwordProtected(let state):
            return state.archiveName
        case .error(let state):
            return state.archiveName
        }
    }

    var detectedFormat: ArchiveFormat? {
        switch self {
        case .empty, .loading:
            return nil
        case .loaded(let state):
            return state.detectedFormat
        case .unsupported(let state):
            return state.detectedFormat
        case .dependencyRequired(let state):
            return state.detectedFormat
        case .passwordProtected(let state):
            return state.detectedFormat
        case .error(let state):
            return state.detectedFormat
        }
    }

    var entries: [ArchiveEntry] {
        switch self {
        case .loaded(let state):
            return state.entries
        default:
            return []
        }
    }

    var stats: ArchiveStats? {
        switch self {
        case .loaded(let state):
            return state.stats
        default:
            return nil
        }
    }

    var totalSize: Int64? {
        switch self {
        case .loaded(let state):
            return state.totalSize
        default:
            return nil
        }
    }

    var message: String? {
        switch self {
        case .unsupported(let state):
            return state.message
        case .dependencyRequired(let state):
            return state.message
        case .passwordProtected(let state):
            return state.message
        case .error(let state):
            return state.errorMessage
        default:
            return nil
        }
    }
}

enum ArchivePreviewContent: Hashable, Sendable {
    case empty
    case imageData(Data)
    case text(String)
}

enum ArchiveParserFailure: Error, Hashable, Sendable {
    case unsupportedFormat
    case dependencyRequired(missingTool: String, message: String)
    case passwordProtected(message: String)
    case failedToRead(message: String, rawError: String? = nil)
}

protocol ArchiveParser: AnyObject {
    var supportedFormats: Set<ArchiveFormat> { get }

    func canParse(_ format: ArchiveFormat) -> Bool
    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool
    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry]
    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws
    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws
}

protocol ArchivePasswordAwareParser: AnyObject {
    func listEntries(
        in archiveURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws -> [ArchiveEntry]

    func extractAll(
        from archiveURL: URL,
        to destinationURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws

    func extractSelected(
        from archiveURL: URL,
        to destinationURL: URL,
        entries: [ArchiveEntry],
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws
}

struct SystemCommandResult: Sendable {
    let exitCode: Int32
    let stdout: String
    let stderr: String
}

struct MissingToolError: Error, Hashable, Sendable {
    let tool: String
}

final class SystemCommandRunner: @unchecked Sendable {
    private let fileManager = FileManager.default

    @discardableResult
    func run(
        executable: String,
        arguments: [String] = [],
        timeout: TimeInterval = 30
    ) async throws -> SystemCommandResult {
        let resolvedExecutable = try resolveExecutable(executable)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: resolvedExecutable)
        process.arguments = arguments

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        try process.run()

        let deadline = Date().addingTimeInterval(timeout)
        while process.isRunning {
            if Date() >= deadline {
                process.terminate()
                process.waitUntilExit()
                throw ArchiveParserFailure.failedToRead(
                    message: "The archive tool timed out.",
                    rawError: "Timed out running \(resolvedExecutable)"
                )
            }

            try await Task.sleep(nanoseconds: 50_000_000)
        }

        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
        let stderr = String(data: stderrData, encoding: .utf8) ?? ""

        return SystemCommandResult(
            exitCode: process.terminationStatus,
            stdout: stdout,
            stderr: stderr
        )
    }

    func which(_ candidates: [String]) -> String? {
        for candidate in candidates {
            if candidate.hasPrefix("/") {
                if fileManager.isExecutableFile(atPath: candidate) {
                    return candidate
                }
                continue
            }

            if let resolved = resolveFromPath(candidate) {
                return resolved
            }
        }

        return nil
    }

    private func resolveExecutable(_ executable: String) throws -> String {
        if executable.hasPrefix("/") {
            guard fileManager.isExecutableFile(atPath: executable) else {
                throw MissingToolError(tool: executable)
            }
            return executable
        }

        if let resolved = resolveFromPath(executable) {
            return resolved
        }

        throw MissingToolError(tool: executable)
    }

    private func resolveFromPath(_ executable: String) -> String? {
        let environment = ProcessInfo.processInfo.environment
        let pathValue = environment["PATH"] ?? ""
        for component in pathValue.split(separator: ":") {
            let candidate = URL(fileURLWithPath: String(component))
                .appendingPathComponent(executable)
                .path
            if fileManager.isExecutableFile(atPath: candidate) {
                return candidate
            }
        }
        return nil
    }
}

struct ArchiveFormatDetector {
    func detectFormat(for archiveURL: URL) -> ArchiveFormat {
        let fileName = archiveURL.lastPathComponent.lowercased()
        let extensionFormat = formatFromExtension(fileName)

        guard let header = readHeader(from: archiveURL) else {
            return extensionFormat ?? .unknown
        }

        if let compoundFormat = compoundFormatFromExtension(fileName, header: header) {
            return compoundFormat
        }

        if header.starts(with: [0x50, 0x4B]) {
            return .zip
        }

        if header.starts(with: [0x1F, 0x8B]) {
            return extensionFormat == .tarGzip ? .tarGzip : .gzip
        }

        if header.starts(with: [0x42, 0x5A, 0x68]) {
            return extensionFormat == .tarBzip2 ? .tarBzip2 : .bzip2
        }

        if header.starts(with: [0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00]) {
            return extensionFormat == .tarXz ? .tarXz : .xz
        }

        if header.starts(with: [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]) {
            return .sevenZip
        }

        if header.starts(with: [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]) {
            return .rar
        }

        if header.starts(with: [0x78, 0x61, 0x72, 0x21]) {
            return .xar
        }

        if isTarHeader(header) {
            return extensionFormat == .tarGzip ? .tarGzip : (extensionFormat == .tarBzip2 ? .tarBzip2 : (extensionFormat == .tarXz ? .tarXz : .tar))
        }

        return extensionFormat ?? .unknown
    }

    private func formatFromExtension(_ fileName: String) -> ArchiveFormat? {
        if fileName.hasSuffix(".tar.gz") || fileName.hasSuffix(".tgz") {
            return .tarGzip
        }
        if fileName.hasSuffix(".tar.bz2") || fileName.hasSuffix(".tbz2") || fileName.hasSuffix(".tbz") {
            return .tarBzip2
        }
        if fileName.hasSuffix(".tar.xz") || fileName.hasSuffix(".txz") {
            return .tarXz
        }
        if fileName.hasSuffix(".zip") {
            return .zip
        }
        if fileName.hasSuffix(".tar") {
            return .tar
        }
        if fileName.hasSuffix(".gz") {
            return .gzip
        }
        if fileName.hasSuffix(".bz2") {
            return .bzip2
        }
        if fileName.hasSuffix(".xz") {
            return .xz
        }
        if fileName.hasSuffix(".cpio") {
            return .cpio
        }
        if fileName.hasSuffix(".xar") {
            return .xar
        }
        if fileName.hasSuffix(".7z") {
            return .sevenZip
        }
        if fileName.hasSuffix(".rar") {
            return .rar
        }
        return nil
    }

    private func compoundFormatFromExtension(_ fileName: String, header: Data) -> ArchiveFormat? {
        if fileName.hasSuffix(".tar.gz") || fileName.hasSuffix(".tgz") {
            return header.starts(with: [0x1F, 0x8B]) ? .tarGzip : .tarGzip
        }
        if fileName.hasSuffix(".tar.bz2") || fileName.hasSuffix(".tbz2") || fileName.hasSuffix(".tbz") {
            return header.starts(with: [0x42, 0x5A, 0x68]) ? .tarBzip2 : .tarBzip2
        }
        if fileName.hasSuffix(".tar.xz") || fileName.hasSuffix(".txz") {
            return header.starts(with: [0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00]) ? .tarXz : .tarXz
        }
        return nil
    }

    private func readHeader(from archiveURL: URL) -> Data? {
        do {
            let handle = try FileHandle(forReadingFrom: archiveURL)
            defer { try? handle.close() }
            let data = try handle.read(upToCount: 512) ?? Data()
            return data
        } catch {
            return nil
        }
    }

    private func isTarHeader(_ data: Data) -> Bool {
        guard data.count >= 262 else {
            return false
        }

        let tarSignature = Array("ustar".utf8)
        let startIndex = 257
        let signature = data[startIndex..<(startIndex + tarSignature.count)]
        return Array(signature) == tarSignature
    }
}

struct ArchivePathSafetyValidator {
    func isSafeArchivePath(_ path: String) -> Bool {
        guard !path.isEmpty else { return false }
        guard !path.contains("\0") else { return false }
        guard !path.hasPrefix("/") else { return false }
        guard !path.hasPrefix("\\") else { return false }
        guard !path.contains("../") else { return false }
        guard !path.contains("..\\") else { return false }

        if path.range(of: #"^[A-Za-z]:[\\/]"#, options: .regularExpression) != nil {
            return false
        }

        return true
    }

    func markRiskyEntries(_ entries: [ArchiveEntry]) -> [ArchiveEntry] {
        entries.map { entry in
            let pathRisk = !isSafeArchivePath(entry.path)
            if pathRisk {
                return entry.updating(isRisky: true)
            }
            return entry
        }
    }

    func validateEntriesForExtraction(_ entries: [ArchiveEntry], destination: URL) throws {
        for entry in entries {
            try validate(entry: entry, destination: destination)
        }
    }

    func validate(entry: ArchiveEntry, destination: URL) throws {
        guard isSafeArchivePath(entry.path) else {
            throw ArchiveParserFailure.failedToRead(
                message: "Unsafe archive paths detected. Extraction was blocked.",
                rawError: entry.path
            )
        }

        let destinationRoot = destination.standardizedFileURL
        let candidate = destination.appendingPathComponent(entry.path).standardizedFileURL
        let destinationPath = destinationRoot.path.hasSuffix("/") ? destinationRoot.path : destinationRoot.path + "/"
        guard candidate.path == destinationRoot.path || candidate.path.hasPrefix(destinationPath) else {
            throw ArchiveParserFailure.failedToRead(
                message: "Unsafe archive paths detected. Extraction was blocked.",
                rawError: entry.path
            )
        }
    }
}
