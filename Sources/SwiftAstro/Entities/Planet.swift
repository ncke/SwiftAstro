//
//  Planet.swift
//  
//
//  Created by Nick on 07/02/2023.
//

import Foundation

// MARK: - Planet

extension SwiftAstro {
    
    public enum Planet: Equatable, Hashable, CaseIterable {
        case mercury
        case venus
        case earth
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
    }

}

// MARK: - Data

extension SwiftAstro.Planet {
    
    public var name: String {
        switch self {
        case .mercury: return "Mercury"
        case .venus: return "Venus"
        case .earth: return "Earth"
        case .mars: return "Mars"
        case .jupiter: return "Jupiter"
        case .saturn: return "Saturn"
        case .uranus: return "Uranus"
        case .neptune: return "Neptune"
        }
    }
    
}

// MARK: - Heliocentric Position

extension SwiftAstro.Planet {
    
    public func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition {
        let vsop = VSOP87Store.shared.vsop87(for: self)
        
        let tau = t.julianMilleniaSinceEpoch(.J2000)
        let lon = vsop.computeSum(tau, index: .sphericalLongitude)
        let lat = vsop.computeSum(tau, index: .sphericalLatitude)
        let rad = vsop.computeSum(tau, index: .sphericalRadius)
        
        return SwiftAstro.SphericalPosition(
            longitude: SwiftAstro.Angle(radians: lon).unwound,
            latitude: SwiftAstro.Angle(radians: lat).unwound,
            radius: SwiftAstro.Distance(astronomicalUnits: rad))
    }
    
}

// MARK: - Geocentric Position

extension SwiftAstro.Planet {

    private static let maximumIterationsForLightTime = 100
    private static let lightTimeAccuracyThreshold = 1E-12

    /// Returns the geocentric position of the planet at the given time as a pair of angles representing
    /// its apparent right ascension and declination.
    /// - Note: See Meeus (1991), p. 209
    public func geocentricPosition(
        t: SwiftAstro.Time,
        adjustForLightTime: Bool = true
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {

        let tActual = adjustForLightTime ? lightTimeAdjusted(t: t) : t

        let (x, y, z) = xyz(
            rblPlanet: RBL(object: self, t: tActual),
            rblEarth: RBL(object: .earth, t: tActual))

        let geocentricLon = SwiftAstro.Angle(radians: atan2(y, x))
        let geocentricLat = SwiftAstro.Angle(radians: atan2(z, sqrt(x * x + y * y)))
        let (fk5lon, fk5lat) = toFK5(
            lon: geocentricLon,
            lat: geocentricLat, 
            t: tActual)
        let (dPsi, dEpsilon) = tActual.nutation
        let ecliptic = tActual.meanObliquityOfEcliptic + dEpsilon

        let (ra, decl) = toEquatorialCoordinates(
            lon: fk5lon + dPsi,
            lat: fk5lat,
            ecliptic: ecliptic)

        return (ra, decl)
    }

    private func lightTimeAdjusted(t: SwiftAstro.Time) -> SwiftAstro.Time {
        var separation = 0.0
        var tActual = SwiftAstro.Time(julianDays: t.julianDays)

        for _ in (1...Self.maximumIterationsForLightTime) {

            let (x, y, z) = xyz(
                rblPlanet: RBL(object: self, t: tActual),
                rblEarth: RBL(object: .earth, t: tActual))

            let nextSeparation = sqrt(x * x + y * y + z * z)
            let secs = nextSeparation * SwiftAstro.Distance.lightSecondsPerAstronomicalUnit
            let lightDays = secs / SwiftAstro.Time.secondsPerDay
            tActual = SwiftAstro.Time(julianDays: t.julianDays - lightDays)

            if abs(nextSeparation - separation) < Self.lightTimeAccuracyThreshold {
                return tActual
            }

            separation = nextSeparation
        }

        return tActual
    }

    private func RBL(
        object: SwiftAstro.Planet,
        t: SwiftAstro.Time
    ) -> (Double, Double, Double) {
        let heliocentric = object.heliocentricPosition(t: t)

        return (
            heliocentric.radius.astronomicalUnits,
            heliocentric.latitude.radians,
            heliocentric.longitude.radians)
    }

    private func xyz(
        rblPlanet: (Double, Double, Double),
        rblEarth: (Double, Double, Double)
    ) -> (Double, Double, Double) {
        let (R, B, L) = rblPlanet
        let (R0, B0, L0) = rblEarth

        let x = R * cos(B) * cos(L) - R0 * cos(B0) * cos(L0)
        let y = R * cos(B) * sin(L) - R0 * cos(B0) * sin(L0)
        let z = R * sin(B) - R0 * sin(B0)

        return (x, y, z)
    }

    private func toFK5(
        lon: SwiftAstro.Angle,
        lat: SwiftAstro.Angle,
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        // See: Equation 31.3 at Meeus (1991), p. 207.
        let T = 10.0 * t.julianMilleniaSinceEpoch(.J2000)

        let Lmark = SwiftAstro.Angle(
            degrees: lon.degrees - 1.397 * T - 0.00031 * (T * T))

        let deltaL = (-0.09033 / 3600.0)
        + 0.03916 * (cos(Lmark.radians) + sin(Lmark.radians)) * tan(lat.radians) / 3600.0

        let deltaB = 0.03916 * (cos(Lmark.radians) - sin(Lmark.radians)) / 3600.0

        return (
            SwiftAstro.Angle(degrees: lon.degrees + deltaL),
            SwiftAstro.Angle(degrees: lat.degrees + deltaB)
        )
    }

    private func toEquatorialCoordinates(
        lon: SwiftAstro.Angle,
        lat: SwiftAstro.Angle,
        ecliptic: SwiftAstro.Angle
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        let ra = atan2(
            sin(lon.radians) * cos(ecliptic.radians) - tan(lat.radians) * sin(ecliptic.radians),
            cos(lon.radians)
        )

        let decl = asin(
            sin(lat.radians) * cos(ecliptic.radians)
            + cos(lat.radians) * sin(ecliptic.radians) * sin(lon.radians)
        )

        return (
            SwiftAstro.Angle(radians: ra),
            SwiftAstro.Angle(radians: decl)
        )
    }

}
