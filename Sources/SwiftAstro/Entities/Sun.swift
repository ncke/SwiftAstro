import Foundation

// MARK: - The Sun

extension SwiftAstro {

    public struct Sun : GeocentricallyPositionable {}

    public static let sun = Sun()

}

// MARK: - Geocentric Position of the Sun

extension SwiftAstro.Sun {

    /// Computes the geocentric position of the Sun.
    /// See: Chapter 24, Solar Coordinates, in Meeus, 1991.
    public func geocentricPosition(
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        let earth = SwiftAstro.Planet.earth.heliocentricPosition(t: t)

        let (lonSun, latSun) = SwiftAstro.Angle.vsopToFK5(
            lon: earth.longitude + SwiftAstro.Angle(degrees: 180),
            lat: -earth.latitude, 
            t: t)

        let (dPsi, dEpsilon) = t.nutation
        let ecliptic = t.meanObliquityOfEcliptic + dEpsilon

        let aberration = SwiftAstro.Angle(
            arcSeconds: -0.005775518
                * earth.radius.astronomicalUnits
                * dailyVariation(t: t).arcSeconds)

        let (ra, decl) = SwiftAstro.Angle.asEquatorialCoordinates(
            lon: lonSun + dPsi + aberration,
            lat: latSun,
            ecliptic: ecliptic)

        return (ra, decl)
    }

    private func dailyVariation(t: SwiftAstro.Time) -> SwiftAstro.Angle {
        let T = t.julianMilleniaSinceEpoch(.J2000)
        let T2 = T * T

        let arcSeconds = 3548.193
        + 118.568 * sin(SwiftAstro.Angle(degrees: 87.5287 + 35993.7286 * T))
        + 2.476 * sin(SwiftAstro.Angle(degrees: 85.0561 + 719987.4571 * T))
        + 1.376 * sin(SwiftAstro.Angle(degrees: 27.8502 + 4452671.1152 * T))
        + 0.119 * sin(SwiftAstro.Angle(degrees: 73.1375 + 450368.8564 * T))
        + 0.114 * sin(SwiftAstro.Angle(degrees: 337.2264 + 329644.6718 * T))
        + 0.086 * sin(SwiftAstro.Angle(degrees: 222.5400 + 659289.3436 * T))
        + 0.078 * sin(SwiftAstro.Angle(degrees: 162.8136 + 9224659.7915 * T))
        + 0.053 * sin(SwiftAstro.Angle(degrees: 82.5823 + 1079981.1857 * T))
        + 0.052 * sin(SwiftAstro.Angle(degrees: 171.5189 + 225184.4282 * T))
        + 0.034 * sin(SwiftAstro.Angle(degrees: 30.3214 + 4092677.3866 * T))
        + 0.033 * sin(SwiftAstro.Angle(degrees: 119.8105 + 337181.4711 * T))
        + 0.023 * sin(SwiftAstro.Angle(degrees: 247.5418 + 299295.6151 * T))
        + 0.023 * sin(SwiftAstro.Angle(degrees: 325.1526 + 315559.5560 * T))
        + 0.021 * sin(SwiftAstro.Angle(degrees: 155.1241 + 675553.2846 * T))
        + 7.311 * T * sin(SwiftAstro.Angle(degrees: 333.4515 + 359993.7286 * T))
        + 0.305 * T * sin(SwiftAstro.Angle(degrees: 330.9184 + 719987.4571 * T))
        + 0.010 * T * sin(SwiftAstro.Angle(degrees: 328.5170 + 1079981.1857 * T))
        + 0.309 * T2 * sin(SwiftAstro.Angle(degrees: 241.4518 + 359993.7286 * T))
        + 0.021 * T2 * sin(SwiftAstro.Angle(degrees: 205.0482 + 719987.4571 * T))
        + 0.004 * T2 * sin(SwiftAstro.Angle(degrees: 297.8610 + 4452671.1152 * T))
        + 0.010 * T * T2 * sin(SwiftAstro.Angle(degrees: 154.7066 + 359993.7286 * T))

        return SwiftAstro.Angle(arcSeconds: arcSeconds)
    }

}
