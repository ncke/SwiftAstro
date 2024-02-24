import Foundation

// MARK: - Heliocentrically Positionable

protocol HeliocentricallyPositionable {

    func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition

}

// MARK: - Geocentrically Positionable

protocol GeocentricallyPositionable {

    func geocentricPosition(
        t: SwiftAstro.Time,
        adjustForLightTime: Bool
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle)

}
