import Foundation

// MARK: - Nutation

extension SwiftAstro.Time {

    public var nutation: (SwiftAstro.Angle, SwiftAstro.Angle) {
        nutationUsing1980Theory()
    }

    private func nutationUsing1980Theory() -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        // See Chapter 21, Meeus (1991).

        let T = julianCenturiesSinceEpoch(.J2000)
        let T2 = T * T
        let T3 = T * T2

        let D = SwiftAstro.Angle(
            degrees: 297.85036 + 445267.111480 * T - 0.0019142 * T2 + T3 / 189474.0)

        let M = SwiftAstro.Angle(
            degrees: 357.52772 + 35999.050340 * T - 0.0001603 * T2 - T3 / 300000.0)

        let Mmark = SwiftAstro.Angle(
            degrees: 134.96298 + 477198.867398 * T + 0.0086972 * T2 + T3 / 56250.0)

        let F = SwiftAstro.Angle(
            degrees: 93.27191 + 483202.017538 * T - 0.0036825 * T2 + T3 / 327270.0)

        let Omega = SwiftAstro.Angle(
            degrees: 125.04452 - 1934.136261 * T + 0.0020708 * T2 + T3 / 450000.0)

        var dPsi = 0.0
        var dEpsilon = 0.0

        for n in 0..<Self.nutationTheory.count {
            let s = Self.nutationSineCoefficient(n: n, T: T)
            let c = Self.nutationCosineCoefficient(n: n, T: T)
            let arg = Self.nutationArgument(
                n: n,
                D: D,
                M: M,
                Mmark: Mmark,
                F: F,
                Omega: Omega)

            dPsi += s * sin(arg)
            dEpsilon += c * cos(arg)
        }

        let dPsiAngle = SwiftAstro.Angle(degrees: dPsi)
        let dEpsilsonAngle = SwiftAstro.Angle(degrees: dEpsilon)
        return (dPsiAngle, dEpsilsonAngle)
    }

    private static func nutationArgument(
        n: Int,
        D: SwiftAstro.Angle,
        M: SwiftAstro.Angle,
        Mmark: SwiftAstro.Angle,
        F: SwiftAstro.Angle,
        Omega: SwiftAstro.Angle
    ) -> SwiftAstro.Angle {
        let (m, _, _) = Self.nutationTheory[n]

        let arg = m[0] * D.degrees
        + m[1] * M.degrees 
        + m[2] * Mmark.degrees
        + m[3] * F.degrees
        + m[4] * Omega.degrees
        
        return SwiftAstro.Angle(degrees: arg)
    }

    private static func nutationSineCoefficient(n: Int, T: Double) -> Double {
        let (_, (t1, t2), _) = Self.nutationTheory[n]
        let degs = (0.0001 * t1 / 3600) + (0.0001 * t2 / 3600) * T
        return degs
    }

    private static func nutationCosineCoefficient(n: Int, T: Double) -> Double {
        let (_, _, (t1, t2)) = Self.nutationTheory[n]
        let degs = (t1 / 36000000) + (t2 / 36000000) * T
        return degs
    }

    private static let nutationTheory: [(
        [Double],
        (Double, Double),
        (Double, Double)
    )] = [
        ([ 0,  0,  0,  0,  1], (-171996, -174.2), (92025, 8.9)),
        ([-2,  0,  0,  2,  2], (-13187, -1.6), (5736, -3.1)),
        ([ 0,  0,  0,  2,  2], (-2274, -0.2), (977, -0.5)),
        ([ 0,  0,  0,  0,  2], (2062, 0.2), (-895, 0.5)),
        ([ 0,  1,  0,  0,  0], (1426, -3.4), (54, -0.1)),
        ([ 0,  0,  1,  0,  0], (712, 0.1), (-7, 0)),
        ([-2,  1,  0,  2,  2], (-517, 1.2), (224, -0.6)),
        ([ 0,  0,  0,  2,  1], (-386, -0.4), (200, 0)),
        ([ 0,  0,  1,  2,  2], (-301, 0), (129, -0.1)),
        ([-2, -1,  0,  2,  2], (217, -0.5), (-95, 0.3)),
        ([-2,  0,  1,  0,  0], (-158, 0), (0, 0)),
        ([-2,  0,  0,  2,  1], (129, 0.1), (-70, 0)),
        ([ 0,  0, -1,  2,  2], (123, 0), (-53, 0)),
        ([ 2,  0,  0,  0,  0], (63, 0), (0, 0)),
        ([ 0,  0,  1,  0,  1], (63, 0.1), (-33, 0)),
        ([ 2,  0, -1,  2,  2], (-59, 0), (26, 0)),
        ([ 0,  0, -1,  0,  1], (-58, -0.1), (32, 0)),
        ([ 0,  0,  1,  2,  1], (-51, 0), (27, 0)),
        ([-2,  0,  2,  0,  0], (48, 0), (0, 0)),
        ([ 0,  0, -2,  2,  1], (46, 0), (-24, 0)),
        ([ 2,  0,  0,  2,  2], (-38, 0), (16, 0)),
        ([ 0,  0,  2,  2,  2], (-31, 0), (13, 0)),
        ([ 0,  0,  2,  0,  0], (29, 0), (0, 0)),
        ([-2,  0,  1,  2,  2], (29, 0), (-12, 0)),
        ([ 0,  0,  0,  2,  0], (26, 0), (0, 0)),
        ([-2,  0,  0,  2,  0], (-22, 0), (0, 0)),
        ([ 0,  0, -1,  2,  1], (21, 0), (-10, 0)),
        ([ 0,  2,  0,  0,  0], (17, -0.1), (0, 0)),
        ([ 2,  0, -1,  0,  1], (16, 0), (-8, 0)),
        ([-2,  2,  0,  2,  2], (-16, 0.1), (7, 0)),
        ([ 0,  1,  0,  0,  1], (-15, 0), (9, 0)),
        ([-2,  0,  1,  0,  1], (-13, 0), (7, 0)),
        ([ 0, -1,  0,  0,  1], (-12, 0), (6, 0)),
        ([ 0,  0,  2, -2,  0], (11, 0), (0, 0)),
        ([ 2,  0, -1,  2,  1], (-10, 0), (5, 0)),
        ([ 2,  0,  1,  2,  2], (-8, 0), (3, 0)),
        ([ 0,  1,  0,  2,  2], (7, 0), (-3, 0)),
        ([-2,  1,  1,  0,  0], (-7, 0), (0, 0)),
        ([ 0, -1,  0,  2,  2], (-7, 0), (3, 0)),
        ([ 2,  0,  0,  2,  1], (-7, 0), (3, 0)),
        ([ 2,  0,  1,  0,  0], (6, 0), (0, 0)),
        ([-2,  0,  2,  2,  2], (6, 0), (-3, 0)),
        ([-2,  0,  1,  2,  1], (6, 0), (-3, 0)),
        ([ 2,  0, -2,  0,  1], (-6, 0), (3, 0)),
        ([ 2,  0,  0,  0,  1], (-6, 0), (3, 0)),
        ([ 0, -1,  1,  0,  0], (5, 0), (0, 0)),
        ([-2, -1,  0,  2,  1], (-5, 0), (3, 0)),
        ([-2,  0,  0,  0,  1], (-5, 0), (3, 0)),
        ([ 0,  0,  2,  2,  1], (-5, 0), (3, 0)),
        ([-2,  0,  2,  0,  1], (4, 0), (0, 0)),
        ([-2,  1,  0,  2,  1], (4, 0), (0, 0)),
        ([ 0,  0,  1, -2,  0], (4, 0), (0, 0)),
        ([-1,  0,  1,  0,  0], (-4, 0), (0, 0)),
        ([-2,  1,  0,  0,  0], (-4, 0), (0, 0)),
        ([ 1,  0,  0,  0,  0], (-4, 0), (0, 0)),
        ([ 0,  0,  1,  2,  0], (3, 0), (0, 0)),
        ([ 0,  0, -2,  2,  2], (-3, 0), (0, 0)),
        ([-1, -1,  1,  0,  0], (-3, 0), (0, 0)),
        ([ 0,  1,  1,  0,  0], (-3, 0), (0, 0)),
        ([ 0, -1,  1,  2,  2], (-3, 0), (0, 0)),
        ([ 2, -1, -1,  2,  2], (-3, 0), (0, 0)),
        ([ 0,  0,  3,  2,  2], (-3, 0), (0, 0)),
        ([ 2, -1,  0,  2,  2], (-3, 0), (0, 0))
    ]

}
