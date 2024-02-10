import Foundation

// MARK: - Resource Loading

extension Utility {

    /// Returns a file from the bundle's resources as an array of strings.
    static func stringsForResource(
        _ resource: String,
        withExtension ext: String
    ) throws -> [String] {
        let resourceUrl = Bundle.module.url(
            forResource: resource,
            withExtension: ext)!

        let data = try Data(contentsOf: resourceUrl)
        let dataString = String(data: data, encoding: .utf8)!

        let lines = dataString.components(separatedBy: .newlines).filter {
            line in !line.isEmpty
        }

        return lines
    }

}
