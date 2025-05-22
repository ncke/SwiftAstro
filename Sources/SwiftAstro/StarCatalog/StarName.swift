import Foundation

// MARK: - Star Name

extension SwiftAstro {

    public struct StarName {

        public enum Designation {
            case hd(number: Int)
            case hr(number: Int)
            case hip(number: Int)
            case gj(number: Int)
            case other(designation: String)
            case wds(designation: String, component: String?)
            case flamsteed(number: Int)
            case variable(number: Int)
            case simbadGreek(string: String)
        }

        public enum Band {
            case bandV
            case bandG
        }

        public let name: String
        public let designations: [Designation]
        public let bayerGreek: String?
        public let constellation: String
        public let magnitude: Double
        public let band: Band
        public let rightAscension: Double
        public let declination: Double
        public let dateApproved: String
        public let hrNumber: Int?
        public let hdNumber: Int?
    }

}

// MARK: - Designation Accessors

extension SwiftAstro.StarName {

    public var hipNumber: Int? {
        for designation in self.designations {
            if case .hip(let n) = designation { return n }
        }
        return nil
    }

    public var gjNumber: Int? {
        for designation in self.designations {
            if case .gj(let n) = designation { return n }
        }
        return nil
    }

    public var otherDesignation: String? {
        for designation in self.designations {
            if case .other(let s) = designation { return s }
        }
        return nil
    }

    public var wdsNumber: (wds: String, component: String?)? {
        for designation in self.designations {
            if case .wds(let s, let c) = designation { return (s, c) }
        }
        return nil
    }

    public var flamsteedNumber: Int? {
        for designation in self.designations {
            if case .flamsteed(let n) = designation { return n }
        }
        return nil
    }

    public var variableNumber: Int? {
        for designation in self.designations {
            if case .variable(let n) = designation { return n }
        }
        return nil
    }

    public var simbadGreek: String? {
        for designation in self.designations {
            if case .simbadGreek(let s) = designation { return s }
        }
        return nil
    }

}
