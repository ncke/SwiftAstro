import Foundation

// MARK: - Star Conformance

extension SwiftAstro.BrightStar: SwiftAstro.Star {

    public var catalog: SwiftAstro.Catalog { .yaleBrightStarCatalog }

    public var catalogIdentifier: String { String(number) }

    private static let helioZeta1  = 2306.2181
    private static let helioZeta2  = 0.30188
    private static let helioZeta3  = 0.017998
    private static let helioZed1   = 2306.2181
    private static let helioZed2   = 1.09468
    private static let helioZed3   = 0.018203
    private static let helioTheta1 = 2004.3109
    private static let helioTheta2 = 0.42665
    private static let helioTheta3 = 0.041833

    public func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition {
        let (raMe, decMe) = positionAfterProperMotion(
            t: t,
            rightAscension: rightAscension,
            raMotion: raAnnualMotion,
            declination: declination,
            declMotion: decAnnualMotion)

        let (raPre, decPre) = precessFromMeanEquinox(
            t: t,
            rightAscesion: raMe,
            decelination: decMe)

        return SwiftAstro.SphericalPosition(
            longitude: raPre,
            latitude: decPre,
            radius: SwiftAstro.Distance(astronomicalUnits: .infinity))
    }

    private func positionAfterProperMotion(
        t: SwiftAstro.Time,
        rightAscension: SwiftAstro.Angle,
        raMotion: SwiftAstro.Angle,
        declination: SwiftAstro.Angle,
        declMotion: SwiftAstro.Angle
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        // Find position for the mean equinox of J2000.
        // See: Meeus, Example 20.b.
        let ys = t.julianYearsSinceEpoch(.J2000)
        let raMoved = SwiftAstro.Angle(radians: ys * raAnnualMotion.radians)
        let declMoved = SwiftAstro.Angle(radians: ys * decAnnualMotion.radians)
        let ra = rightAscension + raMoved
        let decl = declination + declMoved

        return (ra, decl)
    }

    private func precessFromMeanEquinox(
        t: SwiftAstro.Time,
        rightAscesion raMe: SwiftAstro.Angle,
        decelination decMe: SwiftAstro.Angle
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        // Meeus, equation 20.3 for J2000.
        let tc = t.julianCenturiesSinceEpoch(.J2000)
        let tcsq = tc * tc, tccu = tcsq * tc

        let zeta = SwiftAstro.Angle(
            arcSeconds: Self.helioZeta1 * tc
            + Self.helioZeta2 * tcsq
            + Self.helioZeta3 * tccu)

        let zed = SwiftAstro.Angle(
            arcSeconds: Self.helioZed1 * tc
            + Self.helioZed2 * tcsq
            + Self.helioZed3 * tccu)

        let theta = SwiftAstro.Angle(
            arcSeconds: Self.helioTheta1 * tc
            - Self.helioTheta2 * tcsq
            - Self.helioTheta3 * tccu)

        let A = cos(decMe) * sin(raMe + zeta)
        let temp = cos(decMe) * cos(raMe + zeta)
        let B = cos(theta) * temp - sin(theta) * sin(decMe)
        let C = sin(theta) * temp + cos(theta) * sin(decMe)

        let amz = atan2(A, B)
        let delta = asin(C)

        return (
            SwiftAstro.Angle(radians: amz) + zed,
            SwiftAstro.Angle(radians: delta))
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
