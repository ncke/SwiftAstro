import Foundation

// MARK: - Obliquity Of The Ecliptic

extension SwiftAstro.Time {

    /// The mean obligquity of the ecliptic.
    /// - Note : See Equation 21.3, Meeus (1991), p. 135.
    public var meanObliquityOfEcliptic: SwiftAstro.Angle {
        let U = 0.1 * self.julianMilleniaSinceEpoch(.J2000)

        let e0 = SwiftAstro.Angle.meanObliquityOfEclipticAtJ2000.degrees
        - 4680.93 * U / 3600.0
        - 1.55 * pow(U, 2.0) / 3600.0
        + 1999.25 * pow(U, 3.0) / 3600.0
        - 51.38 * pow(U, 4.0) / 3600.0
        - 249.67 * pow(U, 5.0) / 3600.0
        - 39.05 * pow(U, 6.0) / 3600.0
        + 7.12 * pow(U, 7.0) / 3600.0
        + 27.87 * pow(U, 8.0) / 3600.0
        + 5.79 * pow(U, 9.0) / 3600.0
        + 2.45 * pow(U, 10.0) / 3600.0

        return SwiftAstro.Angle(degrees: e0)
    }

}
