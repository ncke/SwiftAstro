import Foundation

extension SwiftAstro.BrightStar : AstronomicallyNameable {

    public var name: String? {
        namedInNotes ?? commonlyNamed
    }

    private var namedInNotes: String? {
        guard 
            let namingRemark = notes?.filter({ note in
                note.noteCategory == .starNames
            }).first?.remark,
            let name = namingRemark.split(separator: ";").first
        else {
            return nil
        }

        return name.trimmingCharacters(in: .whitespaces)
    }

    private var commonlyNamed: String? {
        guard let commonName = commonName else { return nil }
        let parts = commonName
            .components(separatedBy: .whitespaces)
            .filter { p in !p.isEmpty }
        
        return parts.joined(separator: " ")
    }

}
