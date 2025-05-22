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

        public init(
            name: String,
            designations: [Designation],
            bayerGreek: String?,
            constellation: String,
            magnitude: Double,
            band: Band,
            rightAscension: Double,
            declination: Double,
            dateApproved: String,
            hrNumber: Int?,
            hdNumber: Int?
        ) {
            self.name = name
            self.designations = designations
            self.bayerGreek = bayerGreek
            self.constellation = constellation
            self.magnitude = magnitude
            self.band = band
            self.rightAscension = rightAscension
            self.declination = declination
            self.dateApproved = dateApproved
            self.hrNumber = hrNumber
            self.hdNumber = hdNumber
        }
    }

}

// MARK: - Designation Accessors

extension SwiftAstro.StarName {

    var hipNumber: Int? {
        for designation in self.designations {
            if case .hip(let n) = designation { return n }
        }
        return nil
    }

    var gjNumber: Int? {
        for designation in self.designations {
            if case .gj(let n) = designation { return n }
        }
        return nil
    }

    var otherDesignation: String? {
        for designation in self.designations {
            if case .other(let s) = designation { return s }
        }
        return nil
    }

    var wdsNumber: (wds: String, component: String?)? {
        for designation in self.designations {
            if case .wds(let s, let c) = designation { return (s, c) }
        }
        return nil
    }

    var flamsteedNumber: Int? {
        for designation in self.designations {
            if case .flamsteed(let n) = designation { return n }
        }
        return nil
    }

    var variableNumber: Int? {
        for designation in self.designations {
            if case .variable(let n) = designation { return n }
        }
        return nil
    }

    var simbadGreek: String? {
        for designation in self.designations {
            if case .simbadGreek(let s) = designation { return s }
        }
        return nil
    }

}
