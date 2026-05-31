import Foundation
import ZIPFoundation

final class ArchiveReader {
    enum ArchiveReaderError: Error {
        case unsupportedFormat
        case failedToRead
    }

    func listEntries(path: String) throws -> [ArchiveEntry] {
        let url = URL(fileURLWithPath: path)
        guard url.pathExtension.lowercased() == "zip" else {
            throw ArchiveReaderError.unsupportedFormat
        }

        do {
            let archive = try Archive(url: url, accessMode: .read)
            let entries = archive.map { entry in
                ArchiveEntry(
                    path: entry.path,
                    parentPath: ArchiveEntry.inferredParentPath(for: entry.path),
                    size: Int64(entry.uncompressedSize),
                    isDirectory: entry.type == .directory,
                    compressedSize: entry.type == .directory ? nil : Int64(entry.compressedSize),
                    modifiedAt: entry.fileAttributes[.modificationDate] as? Date,
                    fileExtension: URL(fileURLWithPath: entry.path).pathExtension.lowercased(),
                    category: ArchiveEntry.inferredCategory(for: entry.path, isDirectory: entry.type == .directory),
                    isRisky: ArchiveEntry.isRiskyExtension(URL(fileURLWithPath: entry.path).pathExtension.lowercased()),
                    method: entry.isCompressed ? "Deflate" : "Stored"
                )
            }

            return entries.sorted {
                if $0.isDirectory != $1.isDirectory {
                    return $0.isDirectory && !$1.isDirectory
                }
                return $0.path.localizedStandardCompare($1.path) == .orderedAscending
            }
        } catch {
            throw ArchiveReaderError.failedToRead
        }
    }
}
