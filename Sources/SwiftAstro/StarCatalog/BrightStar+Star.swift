import Foundation

// MARK: - Star Conformance

extension SwiftAstro.BrightStar: SwiftAstro.Star {

    public var catalog: SwiftAstro.Catalog { .yaleBrightStarCatalog }

    public var catalogIdentifier: String { String(number) }

    public func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition {
        let ys = t.julianYearsSinceEpoch(.J2000)
        let raMotion = SwiftAstro.Angle(radians: ys * raAnnualMotion.radians)
        let declMotion = SwiftAstro.Angle(radians: ys * decAnnualMotion.radians)

        return SwiftAstro.SphericalPosition(
            longitude: rightAscension + raMotion,
            latitude: declination + declMotion,
            radius: SwiftAstro.Distance(astronomicalUnits: .infinity))
    }

}

// MARK: - Geocentric Position

extension SwiftAstro.BrightStar: SwiftAstro.GeocentricallyPositionable {

    public func geocentricPosition(
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        let heliocentric = heliocentricPosition(t: t)
        return (heliocentric.longitude, heliocentric.latitude)
    }

}
