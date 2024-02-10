import Foundation

// MARK: - Number Formatters

extension Utility {

    /// A number formatter that guarantees two integer digits and three fraction digits.
    /// For example: 19.280, 05.418.
    static let fractionNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 2
        nf.maximumIntegerDigits = 2
        nf.minimumFractionDigits = 3
        nf.maximumFractionDigits = 3

        return nf
    }()

    /// A number formatter that guarantees at least two integer digits with no
    /// fractional part. For example: 19, 05, 201.
    static let twoNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 2
        nf.maximumFractionDigits = 0

        return nf
    }()

    /// A number formatter that guarantees at least three integer digits with no
    /// fractional part. For example: 019, 005, 201.
    static let threeNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 3
        nf.maximumFractionDigits = 0

        return nf
    }()

    /// A number formatter for decimals.
    static let decimalNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal

        return nf
    }()

}
