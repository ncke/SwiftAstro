import Foundation

// MARK: - Geocentric Position of a Heliocentrically Positionable Body

extension GeocentricallyPositionable where Self: HeliocentricallyPositionable {

    /// Returns the geocentric position of a heliocentrically positionable body at the given time as a
    /// pair of angles representing its apparent right ascension and declination.
    /// - Note: See Meeus (1991), p. 209
    public func geocentricPosition(
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        let tActual = tAdjustedForLightTime(t: t)
        let (x, y, z) = xyz(t: tActual)
        let geoLon = SwiftAstro.Angle(radians: atan2(y, x))
        let geoLat = SwiftAstro.Angle(radians: atan2(z, sqrt(x * x + y * y)))
        let (fk5lon, fk5lat) = SwiftAstro.Angle.vsopToFK5(
            lon: geoLon,
            lat: geoLat,
            t: tActual)
        let (dPsi, dEpsilon) = tActual.nutation
        let ecliptic = tActual.meanObliquityOfEcliptic + dEpsilon
        let (ra, decl) = SwiftAstro.Angle.asEquatorialCoordinates(
            lon: fk5lon + dPsi,
            lat: fk5lat,
            ecliptic: ecliptic)

        return (ra, decl)
    }

    private func tAdjustedForLightTime(
        t: SwiftAstro.Time,
        maximumIterationsForLightTime: Int = 100,
        lightTimeAccuracyThreshold: Double = 1E-12
    ) -> SwiftAstro.Time {
        guard maximumIterationsForLightTime > 0 else { return t }

        var previous = SwiftAstro.Distance.zero
        var tActual = SwiftAstro.Time(julianDays: t.julianDays)
        for _ in (1...maximumIterationsForLightTime) {
            let (x, y, z) = xyz(t: tActual)
            let distance = sqrt(x * x + y * y + z * z)
            let separation = SwiftAstro.Distance(astronomicalUnits: distance)
            tActual = SwiftAstro.Time(julianDays: t.julianDays - separation.lightDays)

            let difference = (separation - previous).lightSeconds
            if abs(difference) < lightTimeAccuracyThreshold {
                return tActual
            }

            previous = separation
        }

        return tActual
    }

    private func xyz(t: SwiftAstro.Time) -> (Double, Double, Double) {

        func RBL(
            _ body: HeliocentricallyPositionable
        ) -> (Double, Double, Double) {
            let heliocentric = body.heliocentricPosition(t: t)

            return (
                heliocentric.radius.astronomicalUnits,
                heliocentric.latitude.radians,
                heliocentric.longitude.radians)
        }

        let (R, B, L) = RBL(self)
        let (R0, B0, L0) = RBL(SwiftAstro.Planet.earth)

        let x = R * cos(B) * cos(L) - R0 * cos(B0) * cos(L0)
        let y = R * cos(B) * sin(L) - R0 * cos(B0) * sin(L0)
        let z = R * sin(B) - R0 * sin(B0)

        return (x, y, z)
    }

}
