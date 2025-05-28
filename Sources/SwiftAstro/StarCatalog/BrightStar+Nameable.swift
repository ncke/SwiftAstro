import Foundation

// MARK: - Nameable

extension SwiftAstro.BrightStar : SwiftAstro.AstronomicallyNameable {

    public var name: String? {
        if let greek = bayerGreek, let constellation = constellation {
            var n = greek.letter
            if let number = greek.number { n += "\(number)" }
            n += " \(constellation)"
            return n
        }

        return nil
    }

}
