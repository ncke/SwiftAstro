import Foundation

// MARK: - Decimal Places

extension Double {

    func to(dp: Int) -> Double {
        let power = pow(10, Double(dp))
        let value = (self * power).rounded(.toNearestOrAwayFromZero) / power

        return value
    }

}
