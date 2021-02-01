import Foundation
import FigmaExportCore

final public class XcodeDesignSystemRoot {

    public static func export(rootPath: String, systemName: String) -> [FileContents] {
        var files: [FileContents] = []

        let fileURL = URL(string: "\(systemName).swift")!
        let dirURL =  URL(string: rootPath)!

        let contents = """
        \(header)

        public class \(systemName) { }

        """

        let data = contents.data(using: .utf8)!

        files.append(FileContents(
            destination: Destination(directory: dirURL, file: fileURL),
            data: data
        ))

        return files
    }
}
