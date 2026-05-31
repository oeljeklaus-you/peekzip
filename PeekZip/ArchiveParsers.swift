import AppKit
import Foundation
import ZIPFoundation

fileprivate func normalizedDirectoryPath(_ path: String) -> String {
    path.hasSuffix("/") ? path : path + "/"
}

fileprivate func sortArchiveEntries(_ entries: [ArchiveEntry]) -> [ArchiveEntry] {
    entries.sorted {
        if $0.isDirectory != $1.isDirectory {
            return $0.isDirectory && !$1.isDirectory
        }
        return $0.path.localizedStandardCompare($1.path) == .orderedAscending
    }
}

fileprivate func synthesizeParentDirectories(from rawEntries: [ArchiveEntry]) -> [ArchiveEntry] {
    var entries: [ArchiveEntry] = []
    var knownPaths = Set<String>()

    func insert(_ entry: ArchiveEntry) {
        guard knownPaths.insert(entry.path).inserted else {
            return
        }
        entries.append(entry)
    }

    for entry in rawEntries {
        insert(entry)

        guard !entry.isDirectory else {
            continue
        }

        var parent = entry.parentPath
        while !parent.isEmpty && parent != "." {
            let directoryPath = normalizedDirectoryPath(parent)
            if !knownPaths.contains(directoryPath) {
                let directoryEntry = ArchiveEntry(
                    path: directoryPath,
                    parentPath: ArchiveEntry.inferredParentPath(for: directoryPath),
                    size: 0,
                    isDirectory: true,
                    compressedSize: nil,
                    modifiedAt: nil,
                    fileExtension: "",
                    category: .folder,
                    isRisky: false,
                    method: nil
                )
                insert(directoryEntry)
            }

            let nextParent = ArchiveEntry.inferredParentPath(for: parent)
            if nextParent.isEmpty || nextParent == parent {
                break
            }
            parent = nextParent
        }
    }

    return sortArchiveEntries(entries)
}

fileprivate func makeDirectoryEntry(path: String, modifiedAt: Date? = nil) -> ArchiveEntry {
    let normalizedPath = normalizedDirectoryPath(path)
    return ArchiveEntry(
        path: normalizedPath,
        parentPath: ArchiveEntry.inferredParentPath(for: normalizedPath),
        size: 0,
        isDirectory: true,
        compressedSize: nil,
        modifiedAt: modifiedAt,
        fileExtension: "",
        category: .folder,
        isRisky: false,
        method: nil
    )
}

fileprivate func makeFileEntry(
    path: String,
    size: Int64,
    isDirectory: Bool = false,
    compressedSize: Int64? = nil,
    modifiedAt: Date? = nil,
    method: String? = nil
) -> ArchiveEntry {
    let normalizedPath = isDirectory ? normalizedDirectoryPath(path) : path
    return ArchiveEntry(
        path: normalizedPath,
        parentPath: ArchiveEntry.inferredParentPath(for: normalizedPath),
        size: size,
        isDirectory: isDirectory,
        compressedSize: compressedSize,
        modifiedAt: modifiedAt,
        fileExtension: URL(fileURLWithPath: normalizedPath).pathExtension.lowercased(),
        category: ArchiveEntry.inferredCategory(for: normalizedPath, isDirectory: isDirectory),
        isRisky: ArchiveEntry.isRiskyExtension(URL(fileURLWithPath: normalizedPath).pathExtension.lowercased()),
        method: method
    )
}

fileprivate func dedupeEntries(_ entries: [ArchiveEntry]) -> [ArchiveEntry] {
    var seen = Set<String>()
    return entries.filter { entry in
        seen.insert(entry.path).inserted
    }
}

fileprivate func classifyArchiveFailure(
    stdout: String,
    stderr: String,
    missingTool: String,
    unsupportedMessage: String
) -> ArchiveParserFailure {
    let combined = (stdout + "\n" + stderr).lowercased()

    if combined.contains("password")
        || combined.contains("encrypted")
        || combined.contains("passphrase")
        || combined.contains("unsupported encryption")
        || combined.contains("aes") {
        return .passwordProtected(message: "Password-protected archive")
    }

    if combined.contains("command not found")
        || combined.contains("no compatible extractor")
        || combined.contains("unsupported archive format")
        || combined.contains("unrecognized archive format")
        || combined.contains("cannot open") {
        return .dependencyRequired(missingTool: missingTool, message: unsupportedMessage)
    }

    if combined.contains("damaged")
        || combined.contains("truncated")
        || combined.contains("checksum error")
        || combined.contains("crc")
        || combined.contains("unexpected eof") {
        return .failedToRead(message: "The file may be damaged, encrypted, or unsupported.", rawError: stderr.isEmpty ? stdout : stderr)
    }

    if combined.contains("unknown format") || combined.contains("not an archive") {
        return .unsupportedFormat
    }

    return .failedToRead(message: unsupportedMessage, rawError: stderr.isEmpty ? stdout : stderr)
}

fileprivate extension String {
    var trimmedArchiveLine: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

final class ZipArchiveParser: @unchecked Sendable, ArchiveParser, ArchivePasswordAwareParser {
    let supportedFormats: Set<ArchiveFormat> = [.zip]

    private let runner: SystemCommandRunner

    init(runner: SystemCommandRunner) {
        self.runner = runner
    }

    func canParse(_ format: ArchiveFormat) -> Bool {
        format == .zip
    }

    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool {
        format == .zip
    }

    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry] {
        try await listEntries(in: archiveURL, detectedFormat: detectedFormat, password: nil)
    }

    func listEntries(
        in archiveURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws -> [ArchiveEntry] {
        guard detectedFormat == .zip else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        if let password, !password.isEmpty {
            return try await listEntriesUsingUnzip(archiveURL: archiveURL, password: password)
        }

        do {
            let archive = try Archive(url: archiveURL, accessMode: .read)
            let entries = archive.map { entry in
                let isDirectory = entry.type == .directory
                let fileExtension = URL(fileURLWithPath: entry.path).pathExtension.lowercased()
                let size = isDirectory ? 0 : Int64(entry.uncompressedSize)
                let compressedSize = isDirectory ? nil : Int64(entry.compressedSize)
                let modifiedAt = entry.fileAttributes[.modificationDate] as? Date
                return ArchiveEntry(
                    path: entry.path,
                    parentPath: ArchiveEntry.inferredParentPath(for: entry.path),
                    size: size,
                    isDirectory: isDirectory,
                    compressedSize: compressedSize,
                    modifiedAt: modifiedAt,
                    fileExtension: fileExtension,
                    category: ArchiveEntry.inferredCategory(for: entry.path, isDirectory: isDirectory),
                    isRisky: ArchiveEntry.isRiskyExtension(fileExtension),
                    method: entry.isCompressed ? "Deflate" : "Stored"
                )
            }
            return synthesizeParentDirectories(from: entries)
        } catch {
            do {
                let result = try await runner.run(
                    executable: "/usr/bin/unzip",
                    arguments: ["-Z", "-1", archiveURL.path],
                    timeout: 30
                )

                if result.exitCode != 0 {
                    throw classifyArchiveFailure(
                        stdout: result.stdout,
                        stderr: result.stderr,
                        missingTool: "unzip",
                        unsupportedMessage: "Only ZIP files are supported in this version."
                    )
                }

                let rawPaths = result.stdout
                    .split(whereSeparator: \.isNewline)
                    .map(String.init)
                    .map(\.trimmedArchiveLine)
                    .filter { !$0.isEmpty }

                let rawEntries = rawPaths.map { path in
                    makeFileEntry(path: path, size: -1)
                }
                return synthesizeParentDirectories(from: rawEntries)
            } catch let failure as ArchiveParserFailure {
                throw failure
            } catch let missing as MissingToolError {
                throw ArchiveParserFailure.dependencyRequired(
                    missingTool: missing.tool,
                    message: "Only ZIP files are supported in this version."
                )
            } catch {
                throw ArchiveParserFailure.failedToRead(
                    message: "The file may be damaged, encrypted, or unsupported.",
                    rawError: error.localizedDescription
                )
            }
        }
    }

    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws {
        try await extractAll(from: archiveURL, to: destinationURL, detectedFormat: detectedFormat, password: nil)
    }

    func extractAll(
        from archiveURL: URL,
        to destinationURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws {
        guard detectedFormat == .zip else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        if let password, !password.isEmpty {
            let result = try await runner.run(
                executable: "/usr/bin/unzip",
                arguments: ["-P", password, archiveURL.path, "-d", destinationURL.path],
                timeout: 300
            )
            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: "unzip",
                    unsupportedMessage: "This archive could not be read on this Mac."
                )
            }
            return
        }

        do {
            let archive = try Archive(url: archiveURL, accessMode: .read)
            for entry in archive {
                let outputURL = destinationURL.appendingPathComponent(entry.path)
                _ = try archive.extract(entry, to: outputURL)
            }
        } catch {
            _ = try await runner.run(
                executable: "/usr/bin/unzip",
                arguments: [archiveURL.path, "-d", destinationURL.path],
                timeout: 300
            )
        }
    }

    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws {
        try await extractSelected(from: archiveURL, to: destinationURL, entries: entries, detectedFormat: detectedFormat, password: nil)
    }

    func extractSelected(
        from archiveURL: URL,
        to destinationURL: URL,
        entries: [ArchiveEntry],
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws {
        guard detectedFormat == .zip else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        if let password, !password.isEmpty {
            let arguments = ["-P", password, archiveURL.path] + dedupeEntries(entries).map(\.path) + ["-d", destinationURL.path]
            let result = try await runner.run(
                executable: "/usr/bin/unzip",
                arguments: arguments,
                timeout: 300
            )
            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: "unzip",
                    unsupportedMessage: "This archive could not be read on this Mac."
                )
            }
            return
        }

        let archive = try Archive(url: archiveURL, accessMode: .read)
        for entry in dedupeEntries(entries) {
            let outputURL = destinationURL.appendingPathComponent(entry.path)
            if let zipEntry = archive[entry.path] {
                _ = try archive.extract(zipEntry, to: outputURL)
            }
        }
    }

    private func listEntriesUsingUnzip(archiveURL: URL, password: String) async throws -> [ArchiveEntry] {
        let result = try await runner.run(
            executable: "/usr/bin/unzip",
            arguments: ["-Z", "-1", "-P", password, archiveURL.path],
            timeout: 30
        )

        if result.exitCode != 0 {
            throw classifyArchiveFailure(
                stdout: result.stdout,
                stderr: result.stderr,
                missingTool: "unzip",
                unsupportedMessage: "Only ZIP files are supported in this version."
            )
        }

        let rawPaths = result.stdout
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .map(\.trimmedArchiveLine)
            .filter { !$0.isEmpty }

        let rawEntries = rawPaths.map { path in
            makeFileEntry(path: path, size: -1)
        }
        return synthesizeParentDirectories(from: rawEntries)
    }
}

final class BsdtarArchiveParser: @unchecked Sendable, ArchiveParser {
    let supportedFormats: Set<ArchiveFormat> = [.tar, .tarGzip, .tarBzip2, .tarXz, .cpio]

    private let runner: SystemCommandRunner

    init(runner: SystemCommandRunner) {
        self.runner = runner
    }

    func canParse(_ format: ArchiveFormat) -> Bool {
        supportedFormats.contains(format)
    }

    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool {
        supportedFormats.contains(format)
    }

    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry] {
        guard canParse(detectedFormat) else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        do {
            let result = try await runner.run(
                executable: "/usr/bin/bsdtar",
                arguments: ["-tf", archiveURL.path],
                timeout: 30
            )

            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: "bsdtar",
                    unsupportedMessage: "This archive could not be read on this Mac."
                )
            }

            let rawPaths = result.stdout
                .split(whereSeparator: \.isNewline)
                .map(String.init)
                .map(\.trimmedArchiveLine)
                .filter { !$0.isEmpty }

            let rawEntries = rawPaths.map { path in
                let isDirectory = path.hasSuffix("/")
                return isDirectory
                ? makeDirectoryEntry(path: path)
                : makeFileEntry(path: path, size: -1)
            }
            return synthesizeParentDirectories(from: rawEntries)
        } catch let failure as ArchiveParserFailure {
            throw failure
        } catch let missing as MissingToolError {
            throw ArchiveParserFailure.dependencyRequired(
                missingTool: missing.tool,
                message: "This archive could not be read on this Mac."
            )
        } catch {
            throw ArchiveParserFailure.failedToRead(
                message: "This archive could not be read on this Mac.",
                rawError: error.localizedDescription
            )
        }
    }

    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws {
        guard canParse(detectedFormat) else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        _ = try await runner.run(
            executable: "/usr/bin/bsdtar",
            arguments: ["-xf", archiveURL.path, "-C", destinationURL.path],
            timeout: 300
        )
    }

    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws {
        guard canParse(detectedFormat) else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        var arguments = ["-xf", archiveURL.path, "-C", destinationURL.path]
        arguments.append(contentsOf: dedupeEntries(entries).map(\.path))

        let _ = try await runner.run(
            executable: "/usr/bin/bsdtar",
            arguments: arguments,
            timeout: 300
        )
    }
}

final class SingleFileCompressionParser: @unchecked Sendable, ArchiveParser {
    let supportedFormats: Set<ArchiveFormat> = [.gzip, .bzip2, .xz]

    private let runner: SystemCommandRunner

    init(runner: SystemCommandRunner) {
        self.runner = runner
    }

    func canParse(_ format: ArchiveFormat) -> Bool {
        supportedFormats.contains(format)
    }

    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool {
        supportedFormats.contains(format)
    }

    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry] {
        guard canParse(detectedFormat) else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        let archiveName = archiveURL.deletingPathExtension().lastPathComponent
        let virtualPath = archiveName.isEmpty ? archiveURL.deletingPathExtension().path : archiveName
        let virtualEntry = makeFileEntry(path: virtualPath, size: -1)
        return [virtualEntry]
    }

    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws {
        let outputFileName = archiveURL.deletingPathExtension().lastPathComponent
        let outputURL = destinationURL.appendingPathComponent(outputFileName)
        try await extractSingleFile(
            from: archiveURL,
            to: outputURL,
            detectedFormat: detectedFormat
        )
    }

    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws {
        guard let entry = entries.first else {
            return
        }

        let outputURL = destinationURL.appendingPathComponent(entry.path)
        try await extractSingleFile(
            from: archiveURL,
            to: outputURL,
            detectedFormat: detectedFormat
        )
    }

    private func extractSingleFile(from archiveURL: URL, to outputURL: URL, detectedFormat: ArchiveFormat) async throws {
        guard canParse(detectedFormat) else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        let tool: String
        let arguments: [String]
        switch detectedFormat {
        case .gzip:
            tool = "/usr/bin/gunzip"
            arguments = ["-c", archiveURL.path]
        case .bzip2:
            tool = "/usr/bin/bunzip2"
            arguments = ["-c", archiveURL.path]
        case .xz:
            tool = "/usr/local/bin/xz"
            arguments = ["-dc", archiveURL.path]
        default:
            throw ArchiveParserFailure.unsupportedFormat
        }

        let resolvedTool = runner.which([tool])
        guard let resolvedTool else {
            throw ArchiveParserFailure.dependencyRequired(
                missingTool: URL(fileURLWithPath: tool).lastPathComponent,
                message: "This archive requires an additional system extractor."
            )
        }

        try FileManager.default.createDirectory(
            at: outputURL.deletingLastPathComponent(),
            withIntermediateDirectories: true,
            attributes: nil
        )
        try? FileManager.default.removeItem(at: outputURL)
        FileManager.default.createFile(atPath: outputURL.path, contents: nil)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: resolvedTool)
        process.arguments = arguments
        let stderrPipe = Pipe()
        process.standardError = stderrPipe

        let outputHandle = try FileHandle(forWritingTo: outputURL)
        process.standardOutput = outputHandle

        try process.run()

        let deadline = Date().addingTimeInterval(300)
        while process.isRunning {
            if Date() >= deadline {
                process.terminate()
                process.waitUntilExit()
                outputHandle.closeFile()
                throw ArchiveParserFailure.failedToRead(
                    message: "This archive could not be read on this Mac.",
                    rawError: "Timed out running \(resolvedTool)"
                )
            }
            try await Task.sleep(nanoseconds: 50_000_000)
        }

        outputHandle.closeFile()
        let stderr = String(data: stderrPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        if process.terminationStatus != 0 {
            throw classifyArchiveFailure(
                stdout: "",
                stderr: stderr,
                missingTool: URL(fileURLWithPath: resolvedTool).lastPathComponent,
                unsupportedMessage: "This archive requires an additional system extractor."
            )
        }
    }
}

final class XarArchiveParser: @unchecked Sendable, ArchiveParser {
    let supportedFormats: Set<ArchiveFormat> = [.xar]

    private let runner: SystemCommandRunner
    private let bsdtarParser: BsdtarArchiveParser

    init(runner: SystemCommandRunner, bsdtarParser: BsdtarArchiveParser) {
        self.runner = runner
        self.bsdtarParser = bsdtarParser
    }

    func canParse(_ format: ArchiveFormat) -> Bool {
        format == .xar
    }

    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool {
        format == .xar
    }

    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry] {
        guard detectedFormat == .xar else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        do {
            let result = try await runner.run(
                executable: "/usr/bin/xar",
                arguments: ["-tf", archiveURL.path],
                timeout: 30
            )
            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: "xar",
                    unsupportedMessage: "This XAR archive could not be read on this Mac."
                )
            }

            let rawEntries = result.stdout
                .split(whereSeparator: \.isNewline)
                .map(String.init)
                .map(\.trimmedArchiveLine)
                .filter { !$0.isEmpty }
                .map { path in
                    path.hasSuffix("/") ? makeDirectoryEntry(path: path) : makeFileEntry(path: path, size: -1)
                }
            return synthesizeParentDirectories(from: rawEntries)
        } catch {
            let fallback = try await bsdtarParser.listEntries(in: archiveURL, detectedFormat: detectedFormat)
            return fallback
        }
    }

    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws {
        do {
            let result = try await runner.run(
                executable: "/usr/bin/xar",
                arguments: ["-xf", archiveURL.path, "-C", destinationURL.path],
                timeout: 300
            )
            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: "xar",
                    unsupportedMessage: "This XAR archive could not be read on this Mac."
                )
            }
        } catch {
            try await bsdtarParser.extractAll(from: archiveURL, to: destinationURL, detectedFormat: detectedFormat)
        }
    }

    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws {
        try await bsdtarParser.extractSelected(from: archiveURL, to: destinationURL, entries: entries, detectedFormat: detectedFormat)
    }
}

final class SevenZipArchiveParser: @unchecked Sendable, ArchiveParser, ArchivePasswordAwareParser {
    let supportedFormats: Set<ArchiveFormat> = [.sevenZip]

    private let runner: SystemCommandRunner
    private let bsdtarParser: BsdtarArchiveParser

    init(runner: SystemCommandRunner, bsdtarParser: BsdtarArchiveParser) {
        self.runner = runner
        self.bsdtarParser = bsdtarParser
    }

    func canParse(_ format: ArchiveFormat) -> Bool {
        format == .sevenZip
    }

    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool {
        format == .sevenZip
    }

    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry] {
        try await listEntries(in: archiveURL, detectedFormat: detectedFormat, password: nil)
    }

    func listEntries(
        in archiveURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws -> [ArchiveEntry] {
        guard detectedFormat == .sevenZip else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        do {
            return try await bsdtarParser.listEntries(in: archiveURL, detectedFormat: detectedFormat)
        } catch {
            let tool = runner.which([
                "/usr/local/bin/7zz",
                "/opt/homebrew/bin/7zz",
                "/usr/local/bin/7z",
                "/opt/homebrew/bin/7z",
                "/usr/local/bin/7za",
                "/opt/homebrew/bin/7za"
            ])

            guard let tool else {
                throw ArchiveParserFailure.dependencyRequired(
                    missingTool: "7zz or 7z or 7za",
                    message: "This archive requires an additional system extractor."
                )
            }

            let result = try await runner.run(
                executable: tool,
                arguments: ["l", "-slt"] + (password.map { ["-p\($0)"] } ?? []) + [archiveURL.path],
                timeout: 30
            )

            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: URL(fileURLWithPath: tool).lastPathComponent,
                    unsupportedMessage: "This archive requires an additional system extractor."
                )
            }

            return parseSevenZipListing(result.stdout)
        }
    }

    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws {
        try await extractAll(from: archiveURL, to: destinationURL, detectedFormat: detectedFormat, password: nil)
    }

    func extractAll(
        from archiveURL: URL,
        to destinationURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws {
        do {
            try await bsdtarParser.extractAll(from: archiveURL, to: destinationURL, detectedFormat: detectedFormat)
        } catch {
            let tool = runner.which([
                "/usr/local/bin/7zz",
                "/opt/homebrew/bin/7zz",
                "/usr/local/bin/7z",
                "/opt/homebrew/bin/7z",
                "/usr/local/bin/7za",
                "/opt/homebrew/bin/7za"
            ])

            guard let tool else {
                throw ArchiveParserFailure.dependencyRequired(
                    missingTool: "7zz or 7z or 7za",
                    message: "This archive requires an additional system extractor."
                )
            }

            let result = try await runner.run(
                executable: tool,
                arguments: ["x", archiveURL.path] + (password.map { ["-p\($0)"] } ?? []) + ["-o\(destinationURL.path)", "-y"],
                timeout: 300
            )
            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: URL(fileURLWithPath: tool).lastPathComponent,
                    unsupportedMessage: "This archive requires an additional system extractor."
                )
            }
        }
    }

    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws {
        try await extractSelected(from: archiveURL, to: destinationURL, entries: entries, detectedFormat: detectedFormat, password: nil)
    }

    func extractSelected(
        from archiveURL: URL,
        to destinationURL: URL,
        entries: [ArchiveEntry],
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws {
        try await bsdtarParser.extractSelected(from: archiveURL, to: destinationURL, entries: entries, detectedFormat: detectedFormat)
    }

    private func parseSevenZipListing(_ output: String) -> [ArchiveEntry] {
        var current: [String: String] = [:]
        var entries: [ArchiveEntry] = []

        func flushCurrent() {
            guard let path = current["Path"], !path.isEmpty else {
                current.removeAll()
                return
            }

            let isDirectory = current["Folder"] == "+"
            let size = Int64(current["Size"] ?? "-1") ?? -1
            let compressedSize = Int64(current["Packed Size"] ?? current["Compressed Size"] ?? "-1") ?? -1
            let modifiedAt = parseSevenZipDate(current["Modified"])
            let method = current["Method"]
            let fileEntry = ArchiveEntry(
                path: isDirectory ? normalizedDirectoryPath(path) : path,
                parentPath: ArchiveEntry.inferredParentPath(for: path),
                size: isDirectory ? 0 : size,
                isDirectory: isDirectory,
                compressedSize: compressedSize >= 0 ? compressedSize : nil,
                modifiedAt: modifiedAt,
                fileExtension: URL(fileURLWithPath: path).pathExtension.lowercased(),
                category: ArchiveEntry.inferredCategory(for: path, isDirectory: isDirectory),
                isRisky: ArchiveEntry.isRiskyExtension(URL(fileURLWithPath: path).pathExtension.lowercased()),
                method: method
            )
            entries.append(fileEntry)
            current.removeAll()
        }

        for rawLine in output.split(whereSeparator: \.isNewline) {
            let line = String(rawLine).trimmedArchiveLine
            if line == "----------" {
                flushCurrent()
                continue
            }

            guard let equalsIndex = line.firstIndex(of: "=") else {
                continue
            }

            let key = String(line[..<equalsIndex]).trimmedArchiveLine
            let value = String(line[line.index(after: equalsIndex)...]).trimmedArchiveLine
            current[key] = value
        }

        flushCurrent()
        return synthesizeParentDirectories(from: entries)
    }

    private func parseSevenZipDate(_ value: String?) -> Date? {
        guard let value else { return nil }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: value)
    }
}

final class RarArchiveParser: @unchecked Sendable, ArchiveParser, ArchivePasswordAwareParser {
    let supportedFormats: Set<ArchiveFormat> = [.rar]

    private let runner: SystemCommandRunner
    private let bsdtarParser: BsdtarArchiveParser

    init(runner: SystemCommandRunner, bsdtarParser: BsdtarArchiveParser) {
        self.runner = runner
        self.bsdtarParser = bsdtarParser
    }

    func canParse(_ format: ArchiveFormat) -> Bool {
        format == .rar
    }

    func supportsExtractSelected(_ format: ArchiveFormat) -> Bool {
        format == .rar
    }

    func listEntries(in archiveURL: URL, detectedFormat: ArchiveFormat) async throws -> [ArchiveEntry] {
        try await listEntries(in: archiveURL, detectedFormat: detectedFormat, password: nil)
    }

    func listEntries(
        in archiveURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws -> [ArchiveEntry] {
        guard detectedFormat == .rar else {
            throw ArchiveParserFailure.unsupportedFormat
        }

        do {
            return try await bsdtarParser.listEntries(in: archiveURL, detectedFormat: detectedFormat)
        } catch {
            let tool = runner.which([
                "/usr/local/bin/unrar",
                "/opt/homebrew/bin/unrar"
            ])

            guard let tool else {
                throw ArchiveParserFailure.dependencyRequired(
                    missingTool: "unrar",
                    message: "This archive requires an additional system extractor."
                )
            }

            let result = try await runner.run(
                executable: tool,
                arguments: ["lb"] + (password.map { ["-p\($0)"] } ?? []) + [archiveURL.path],
                timeout: 30
            )

            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: URL(fileURLWithPath: tool).lastPathComponent,
                    unsupportedMessage: "This archive requires an additional system extractor."
                )
            }

            let rawPaths = result.stdout
                .split(whereSeparator: \.isNewline)
                .map(String.init)
                .map(\.trimmedArchiveLine)
                .filter { !$0.isEmpty }

            let rawEntries = rawPaths.map { path in
                path.hasSuffix("/") ? makeDirectoryEntry(path: path) : makeFileEntry(path: path, size: -1)
            }
            return synthesizeParentDirectories(from: rawEntries)
        }
    }

    func extractAll(from archiveURL: URL, to destinationURL: URL, detectedFormat: ArchiveFormat) async throws {
        try await extractAll(from: archiveURL, to: destinationURL, detectedFormat: detectedFormat, password: nil)
    }

    func extractAll(
        from archiveURL: URL,
        to destinationURL: URL,
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws {
        do {
            try await bsdtarParser.extractAll(from: archiveURL, to: destinationURL, detectedFormat: detectedFormat)
        } catch {
            let tool = runner.which([
                "/usr/local/bin/unrar",
                "/opt/homebrew/bin/unrar"
            ])

            guard let tool else {
                throw ArchiveParserFailure.dependencyRequired(
                    missingTool: "unrar",
                    message: "This archive requires an additional system extractor."
                )
            }

            let result = try await runner.run(
                executable: tool,
                arguments: ["x"] + (password.map { ["-p\($0)"] } ?? []) + ["-o+", archiveURL.path, destinationURL.path],
                timeout: 300
            )
            if result.exitCode != 0 {
                throw classifyArchiveFailure(
                    stdout: result.stdout,
                    stderr: result.stderr,
                    missingTool: URL(fileURLWithPath: tool).lastPathComponent,
                    unsupportedMessage: "This archive requires an additional system extractor."
                )
            }
        }
    }

    func extractSelected(from archiveURL: URL, to destinationURL: URL, entries: [ArchiveEntry], detectedFormat: ArchiveFormat) async throws {
        try await extractSelected(from: archiveURL, to: destinationURL, entries: entries, detectedFormat: detectedFormat, password: nil)
    }

    func extractSelected(
        from archiveURL: URL,
        to destinationURL: URL,
        entries: [ArchiveEntry],
        detectedFormat: ArchiveFormat,
        password: String?
    ) async throws {
        try await bsdtarParser.extractSelected(from: archiveURL, to: destinationURL, entries: entries, detectedFormat: detectedFormat)
    }
}

final class ArchiveParserRegistry: @unchecked Sendable {
    private let detector: ArchiveFormatDetector
    private let validator: ArchivePathSafetyValidator
    private let runner: SystemCommandRunner
    private let zipParser: ZipArchiveParser
    private let bsdtarParser: BsdtarArchiveParser
    private let singleFileParser: SingleFileCompressionParser
    private let xarParser: XarArchiveParser
    private let sevenZipParser: SevenZipArchiveParser
    private let rarParser: RarArchiveParser

    init(
        detector: ArchiveFormatDetector = ArchiveFormatDetector(),
        validator: ArchivePathSafetyValidator = ArchivePathSafetyValidator(),
        runner: SystemCommandRunner = SystemCommandRunner()
    ) {
        self.detector = detector
        self.validator = validator
        self.runner = runner
        self.bsdtarParser = BsdtarArchiveParser(runner: runner)
        self.zipParser = ZipArchiveParser(runner: runner)
        self.singleFileParser = SingleFileCompressionParser(runner: runner)
        self.xarParser = XarArchiveParser(runner: runner, bsdtarParser: bsdtarParser)
        self.sevenZipParser = SevenZipArchiveParser(runner: runner, bsdtarParser: bsdtarParser)
        self.rarParser = RarArchiveParser(runner: runner, bsdtarParser: bsdtarParser)
    }

    func detectFormat(fileURL: URL) -> ArchiveFormat {
        detector.detectFormat(for: fileURL)
    }

    func parserFor(format: ArchiveFormat) -> (any ArchiveParser)? {
        switch format {
        case .zip:
            return zipParser
        case .tar, .tarGzip, .tarBzip2, .tarXz, .cpio:
            return bsdtarParser
        case .gzip, .bzip2, .xz:
            return singleFileParser
        case .xar:
            return xarParser
        case .sevenZip:
            return sevenZipParser
        case .rar:
            return rarParser
        case .unknown:
            return nil
        }
    }

    func supportsExtractSelected(format: ArchiveFormat) -> Bool {
        parserFor(format: format)?.supportsExtractSelected(format) ?? false
    }

    func loadArchive(url: URL, password: String? = nil) async -> ArchiveLoadState {
        let archiveName = url.lastPathComponent
        let format = detectFormat(fileURL: url)

        guard let parser = parserFor(format: format) else {
            return .unsupported(
                UnsupportedArchiveState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    message: "PeekZip could not recognize this archive format."
                )
            )
        }

        do {
            let entries = try await listEntries(parser: parser, url: url, format: format, password: password)
            let findings = RiskScanner.scan(items: entries)
            let riskyEntries = RiskScanner.flaggedEntries(from: entries, findings: findings)
            let stats = Self.computeStats(entries: riskyEntries)
            return .loaded(
                LoadedArchiveState(
                    archiveURL: url,
                    archiveName: archiveName,
                    detectedFormat: format,
                    entries: riskyEntries,
                    stats: stats,
                    totalSize: stats.totalSize
                )
            )
        } catch let failure as ArchiveParserFailure {
            return failure.toLoadState(archiveName: archiveName, format: format)
        } catch let missing as MissingToolError {
            return .dependencyRequired(
                DependencyRequiredArchiveState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    missingTool: missing.tool,
                    message: "PeekZip recognizes this archive, but this Mac does not have a compatible extractor available for previewing it."
                )
            )
        } catch {
            return .error(
                ArchiveErrorState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    errorMessage: "The file may be damaged, encrypted, or unsupported.",
                    rawError: error.localizedDescription
                )
            )
        }
    }

    func extractAll(url: URL, destination: URL, password: String? = nil, skipJunkFiles: Bool = true) async throws {
        let format = detectFormat(fileURL: url)
        guard let parser = parserFor(format: format) else {
            throw ArchiveParserFailure.unsupportedFormat
        }
        let entries = try await listEntries(parser: parser, url: url, format: format, password: password)
        let findings = RiskScanner.scan(items: entries)
        let safeEntries = RiskScanner.flaggedEntries(from: entries, findings: findings)
        let filteredEntries = filterJunkFiles(safeEntries, skipJunkFiles: skipJunkFiles)
        try validator.validateEntriesForExtraction(filteredEntries, destination: destination)
        try await extractEntries(parser: parser, url: url, destination: destination, entries: filteredEntries, format: format, password: password)
    }

    func extractSelected(
        url: URL,
        destination: URL,
        selectedEntries: [ArchiveEntry],
        allEntries: [ArchiveEntry],
        password: String? = nil,
        skipJunkFiles: Bool = true
    ) async throws {
        let format = detectFormat(fileURL: url)
        guard let parser = parserFor(format: format) else {
            throw ArchiveParserFailure.unsupportedFormat
        }
        let expandedEntries = Self.expandSelectedEntries(selectedEntries, within: allEntries)
        let findings = RiskScanner.scan(items: expandedEntries)
        let safeEntries = RiskScanner.flaggedEntries(from: expandedEntries, findings: findings)
        let filteredEntries = filterJunkFiles(safeEntries, skipJunkFiles: skipJunkFiles)
        try validator.validateEntriesForExtraction(filteredEntries, destination: destination)
        try await extractEntries(parser: parser, url: url, destination: destination, entries: filteredEntries, format: format, password: password)
    }

    func preview(url: URL, entry: ArchiveEntry, password: String? = nil) async -> ArchivePreviewContent {
        guard !entry.isDirectory else {
            return .empty
        }

        let format = detectFormat(fileURL: url)
        guard let parser = parserFor(format: format) else {
            return .empty
        }

        let tempRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent("PeekZipPreview", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: tempRoot, withIntermediateDirectories: true, attributes: nil)
            defer { try? FileManager.default.removeItem(at: tempRoot) }

            try await extractEntries(parser: parser, url: url, destination: tempRoot, entries: [entry], format: format, password: password)

            let previewURL = tempRoot.appendingPathComponent(entry.path)
            if entry.kind == .image {
                if let data = try? Data(contentsOf: previewURL) {
                    return .imageData(data)
                }
            }

            if entry.kind == .text || entry.kind == .code || entry.kind == .document {
                let text = try String(contentsOf: previewURL, encoding: .utf8)
                return .text(text)
            }
        } catch {
            return .empty
        }

        return .empty
    }

    private func listEntries(
        parser: any ArchiveParser,
        url: URL,
        format: ArchiveFormat,
        password: String?
    ) async throws -> [ArchiveEntry] {
        if let password, let passwordAware = parser as? any ArchivePasswordAwareParser {
            return try await passwordAware.listEntries(in: url, detectedFormat: format, password: password)
        }
        return try await parser.listEntries(in: url, detectedFormat: format)
    }

    private func extractEntries(
        parser: any ArchiveParser,
        url: URL,
        destination: URL,
        entries: [ArchiveEntry],
        format: ArchiveFormat,
        password: String?
    ) async throws {
        if let password, let passwordAware = parser as? any ArchivePasswordAwareParser {
            try await passwordAware.extractSelected(from: url, to: destination, entries: entries, detectedFormat: format, password: password)
            return
        }
        try await parser.extractSelected(from: url, to: destination, entries: entries, detectedFormat: format)
    }

    private func filterJunkFiles(_ entries: [ArchiveEntry], skipJunkFiles: Bool) -> [ArchiveEntry] {
        guard skipJunkFiles else { return entries }
        return entries.filter { entry in
            let loweredPath = entry.path.lowercased()
            let loweredName = entry.name.lowercased()
            return loweredName != ".ds_store"
                && loweredName != "thumbs.db"
                && loweredName != "desktop.ini"
                && !loweredPath.contains("__macosx")
        }
    }

    private static func computeStats(entries: [ArchiveEntry]) -> ArchiveStats {
        var fileCount = 0
        var folderCount = 0
        var imageCount = 0
        var documentCount = 0
        var codeCount = 0
        var videoCount = 0
        var archiveCount = 0
        var executableCount = 0
        var largeFileCount = 0
        var riskyCount = 0
        var unknownSizeCount = 0
        var totalSize: Int64 = 0

        for entry in entries {
            if entry.isDirectory {
                folderCount += 1
            } else {
                fileCount += 1
            }

            if entry.kind == .image {
                imageCount += 1
            }
            if entry.kind == .document || entry.kind == .text {
                documentCount += 1
            }
            if entry.kind == .code {
                codeCount += 1
            }
            if entry.kind == .video {
                videoCount += 1
            }
            if entry.kind == .archive {
                archiveCount += 1
            }
            if entry.kind == .executable {
                executableCount += 1
            }
            if entry.size >= 1_048_576 && !entry.isDirectory {
                largeFileCount += 1
            }
            if entry.isRisky {
                riskyCount += 1
            }

            if entry.size < 0 {
                unknownSizeCount += 1
            } else {
                totalSize += entry.size
            }
        }

        let summarySize: Int64? = unknownSizeCount > 0 ? nil : totalSize

        return ArchiveStats(
            fileCount: fileCount,
            folderCount: folderCount,
            imageCount: imageCount,
            documentCount: documentCount,
            codeCount: codeCount,
            videoCount: videoCount,
            archiveCount: archiveCount,
            executableCount: executableCount,
            largeFileCount: largeFileCount,
            riskyCount: riskyCount,
            unknownSizeCount: unknownSizeCount,
            totalSize: summarySize
        )
    }

    private static func expandSelectedEntries(_ selectedEntries: [ArchiveEntry], within allEntries: [ArchiveEntry]) -> [ArchiveEntry] {
        var expanded: [ArchiveEntry] = []
        var seen = Set<String>()

        for entry in selectedEntries {
            if entry.isDirectory {
                let prefix = normalizedDirectoryPath(entry.path)
                for candidate in allEntries where candidate.path == entry.path || candidate.path.hasPrefix(prefix) {
                    if seen.insert(candidate.path).inserted {
                        expanded.append(candidate)
                    }
                }
            } else {
                if seen.insert(entry.path).inserted {
                    expanded.append(entry)
                }
            }
        }

        return sortArchiveEntries(expanded)
    }
}

final class ArchiveService: @unchecked Sendable {
    private let registry = ArchiveParserRegistry()

    func loadArchive(url: URL, password: String? = nil) async -> ArchiveLoadState {
        await registry.loadArchive(url: url, password: password)
    }

    func supportsSelectedExtraction(for format: ArchiveFormat) -> Bool {
        registry.supportsExtractSelected(format: format)
    }

    func extractAll(from url: URL, to destination: URL, password: String? = nil, skipJunkFiles: Bool = true) async throws {
        try await registry.extractAll(url: url, destination: destination, password: password, skipJunkFiles: skipJunkFiles)
    }

    func extractSelected(
        from url: URL,
        to destination: URL,
        selectedEntries: [ArchiveEntry],
        allEntries: [ArchiveEntry],
        password: String? = nil,
        skipJunkFiles: Bool = true
    ) async throws {
        try await registry.extractSelected(
            url: url,
            destination: destination,
            selectedEntries: selectedEntries,
            allEntries: allEntries,
            password: password,
            skipJunkFiles: skipJunkFiles
        )
    }

    func preview(from url: URL, entry: ArchiveEntry, password: String? = nil) async -> ArchivePreviewContent {
        await registry.preview(url: url, entry: entry, password: password)
    }
}

extension ArchiveParserFailure {
    func toLoadState(archiveName: String, format: ArchiveFormat) -> ArchiveLoadState {
        switch self {
        case .unsupportedFormat:
            return .unsupported(
                UnsupportedArchiveState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    message: "PeekZip could not recognize this archive format."
                )
            )
        case .dependencyRequired(let missingTool, let message):
            return .dependencyRequired(
                DependencyRequiredArchiveState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    missingTool: missingTool,
                    message: message
                )
            )
        case .passwordProtected(let message):
            return .passwordProtected(
                PasswordProtectedArchiveState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    message: message
                )
            )
        case .failedToRead(let message, let rawError):
            return .error(
                ArchiveErrorState(
                    archiveName: archiveName,
                    detectedFormat: format,
                    errorMessage: message,
                    rawError: rawError
                )
            )
        }
    }
}
