import Foundation

// MARK: - Equatorial Coordinates

extension SwiftAstro.Angle {

    static func asEquatorialCoordinates(
        lon: SwiftAstro.Angle,
        lat: SwiftAstro.Angle,
        ecliptic: SwiftAstro.Angle
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        let ra = atan2(
            sin(lon) * cos(ecliptic) - tan(lat) * sin(ecliptic),
            cos(lon)
        )

        let decl = asin(
            sin(lat) * cos(ecliptic) + cos(lat) * sin(ecliptic) * sin(lon)
        )

        return (
            SwiftAstro.Angle(radians: ra),
            SwiftAstro.Angle(radians: decl))
    }

}

// MARK: - VSOP to FK5 System

extension SwiftAstro.Angle {

    static func vsopToFK5(
        lon: SwiftAstro.Angle,
        lat: SwiftAstro.Angle,
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        // See: Equation 31.3 at Meeus (1991), p. 207.
        let T = t.julianCenturiesSinceEpoch(.J2000)
        let Lmark = SwiftAstro.Angle(
            degrees: lon.degrees - 1.397 * T - 0.00031 * (T * T)
        )

        let deltaL = (-0.09033 / 3600.0) +
            0.03916 * (cos(Lmark) + sin(Lmark)) * tan(lat) / 3600.0

        let deltaB = 0.03916 * (cos(Lmark) - sin(Lmark)) / 3600.0

        return (
            SwiftAstro.Angle(degrees: lon.degrees + deltaL),
            SwiftAstro.Angle(degrees: lat.degrees + deltaB))
    }

}
