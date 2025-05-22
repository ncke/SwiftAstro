import Foundation

// MARK: - Star Names Catalog

extension SwiftAstro {

    public struct StarNamesCatalog {
        public let names: [SwiftAstro.StarName]
        private let hdIndex: [Int: Int] // HD Number to array index.
        private let hrIndex: [Int: Int] // HR Number to array index.

        init() {
            let parsedNames = Self.parseStarNames()
            self.names = parsedNames

            self.hdIndex = Self.buildIndex(
                on: \SwiftAstro.StarName.hdNumber,
                names: names)

            self.hrIndex = Self.buildIndex(
                on: \SwiftAstro.StarName.hrNumber,
                names: names)
        }

        private static func buildIndex<T: Hashable>(
            on keyPath: KeyPath<SwiftAstro.StarName, T?>,
            names: [SwiftAstro.StarName]
        ) -> [T: Int] {
            var lookup = [T: Int]()
            for i in 0..<names.count {
                if let idx = names[i][keyPath: keyPath] { lookup[idx] = i }
            }

            return lookup
        }

        func findByHRNumber(_ number: Int) -> StarName? {
            guard let idx = hrIndex[number] else { return nil }
            return names[idx]
        }

        func findByHDNumber(_ number: Int) -> StarName? {
            guard let idx = hdIndex[number] else { return nil }
            return names[idx]
        }

        func findByName(_ name: String) -> StarName? {
            let capName = name.capitalized
            guard let starName = names.first(where: { starName in
                starName.name == capName
            }) else {
                return nil
            }

            return starName
        }

    }

}

// MARK: - Parse Star Names

private extension SwiftAstro.StarNamesCatalog {

    private static func parseStarNames() -> [SwiftAstro.StarName] {
        let lines = try! Utility.stringsForResource(
            "IAU-CSN-2022-04-04",
            withExtension: "txt")

        return lines.compactMap { line in
            parseLine(line: line)
        }
    }

    private static func parseLine(line: String) -> SwiftAstro.StarName? {
        guard
            let name: String = line.cols(1, 18),
            let constellation: String = line.cols(62, 3),
            let magnitude: Double = line.cols(82,5),
            let bandString: String = line.cols(89, 1),
            let ra: Double = line.cols(105, 10),
            let dec: Double = line.cols(116, 10),
            let dateApproved: String = line.cols(127, 10)
        else {
            return nil
        }

        let band: SwiftAstro.StarName.Band
        switch bandString {
        case "V": band = .bandV
        case "G": band = .bandG
        default: fatalError()
        }

        var designations = [SwiftAstro.StarName.Designation]()
        let designationStr: String? = line.cols(37, 12)
        if let designation = parseDesignation(designationStr) {
            designations.append(designation)
        }

        if  let identity: String = line.cols(50, 5),
            let designation = parseIdentity(identity)
        {
            designations.append(designation)
        }

        var bayerGreek: String?
        if let greek: String = line.cols(56, 5), greek != "_" {
            bayerGreek = greek
        }

        if let hip: String = line.cols(91, 6), let number = Int(hip) {
            designations.append(.hip(number: number))
        }

        if let hd: String = line.cols(98, 6), let number = Int(hd) {
            designations.append(.hd(number: number))
        }

        if let wds: String = line.cols(71, 10), wds != "_" {
            let component: String? = line.cols(66, 4)
            designations.append(
                .wds(
                    designation: wds,
                    component: component != "_" ? component : nil))
        }

        let hdNumber = designations.compactMap { designation in
            if case .hd(let number) = designation {
                return number
            } else {
                return nil
            }
        }.first

        let hrNumber = designations.compactMap { designation in
            if case .hr(let number) = designation {
                return number
            } else {
                return nil
            }
        }.first

        let starName = SwiftAstro.StarName(
            name: name,
            designations: designations,
            bayerGreek: bayerGreek,
            constellation: constellation,
            magnitude: magnitude,
            band: band,
            rightAscension: ra,
            declination: dec,
            dateApproved: dateApproved,
            hrNumber: hrNumber,
            hdNumber: hdNumber
        )

        return starName
    }

    private static func parseDesignation(
        _ designation: String?
    ) -> SwiftAstro.StarName.Designation? {
        guard let designation = designation else { return nil }

        if  designation.prefix(2) == "HR",
            let s = designation.cols(4),
            let n = Int(s)
        {
            return .hr(number: n)
        }

        if  designation.prefix(2) == "GJ",
            let s = designation.cols(4),
            let n = Int(s)
        {
            return .gj(number: n)
        }

        if designation.prefix(2) == "HD" || designation.prefix(3) == "HIP" {
            return nil // Obtained from other fields.
        }

        return .other(designation: designation)
    }

    private static func parseIdentity(
        _ identity: String?
    ) -> SwiftAstro.StarName.Designation? {
        guard let identity = identity, identity != "_" else { return nil }

        if let number = Int(identity) {
            return .flamsteed(number: number)
        }

        if  identity.prefix(1) == "V",
            let numberStr = identity.cols(2),
            let number = Int(numberStr)
        {
            return .variable(number: number)
        }

        return .simbadGreek(string: identity)
    }

}
