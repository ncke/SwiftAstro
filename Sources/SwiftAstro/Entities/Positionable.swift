import Foundation

// MARK: - Heliocentrically Positionable

public protocol HeliocentricallyPositionable {

    func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition

}

// MARK: - Geocentrically Positionable

public protocol GeocentricallyPositionable {

    func geocentricPosition(
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle)

}
