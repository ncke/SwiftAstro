import Foundation

// MARK: - Earth's Moon

extension SwiftAstro {

    public struct Moon : GeocentricallyPositionable, AstronomicallyNameable {

        public let name: String? = "Moon"

    }

    public static let moon = Moon()

}

// MARK: - Geocentric Posiiton of the Moon

extension SwiftAstro.Moon {

    /// Returns the geocentric position of the moon using the method described in Chapter 45,
    /// Meeus, 1991.
    public func geocentricPosition(
        t: SwiftAstro.Time
    ) -> (SwiftAstro.Angle, SwiftAstro.Angle) {
        let T = t.julianCenturiesSinceEpoch(.J2000)
        let T2 = T * T
        let T3 = T * T2
        let T4 = T * T3

        let Ld = SwiftAstro.Angle(
            degrees: 218.3164591 + 481267.88134236 * T - 0.0013268 * T2 + T3 / 538841 - T4 / 65194000)

        let D = SwiftAstro.Angle(
            degrees: 297.8502042 + 445267.1115168 * T - 0.0016300 * T2 + T3 / 545868 - T4 / 113065000)

        let M = SwiftAstro.Angle(
            degrees: 357.5291092 + 35999.0502909 * T - 0.0001536 * T2 + T3 / 24490000)

        let Md = SwiftAstro.Angle(
            degrees: 134.9634114 + 477198.8676313 * T + 0.0089970 * T2 + T3 / 69699 - T4 / 14712000)

        let F = SwiftAstro.Angle(
            degrees: 93.2720993 + 483202.0175273 * T - 0.0034029 * T2 - T3 / 3526000 + T4 / 863310000)

        let A1 = SwiftAstro.Angle(degrees: 119.75 + 131.849 * T)

        let A2 = SwiftAstro.Angle(degrees: 53.09 + 479264.290 * T)

        let A3 = SwiftAstro.Angle(degrees: 313.45 + 481266.484 * T)

        let E = 1 - 0.002516 * T - 0.0000074 * T2

        let E2 = E * E

        func term(mt: MoonTerm) -> (Double, Double) {
            let ec = abs(mt.m) == 1 ? E : abs(mt.m) == 2 ? E2 : 1.0
            let alpha = SwiftAstro.Angle(
                degrees: mt.d * D.degrees
                + mt.m * M.degrees
                + mt.mDash * Md.degrees
                + mt.f * F.degrees)

            return (ec * mt.cSin * sin(alpha), ec * mt.cCos * cos(alpha))
        }

        let lrSum = Self.lrMoonTerms.reduce((0.0, 0.0)) { partial, mt in
            let (l, r) = term(mt: mt)
            return (partial.0 + l, partial.1 + r)
        }

        let bSum = Self.bMoonTerms.reduce(0.0) { partial, mt in
            let (b, _) = term(mt: mt)
            return partial + b
        }

        let lAdditive = SwiftAstro.Angle(
            degrees: (lrSum.0
                      + 3958 * sin(A1)
                      + 1962 * sin(Ld - F)
                      + 318 * sin(A2))
            / 1E6)

        let bAdditive = SwiftAstro.Angle(
            degrees: (bSum
                      - 2235 * sin(Ld)
                      + 382 * sin(A3)
                      + 175 * sin(A1 - F)
                      + 175 * sin(A1 + F)
                      + 127 * sin(Ld - Md)
                      - 115 * sin(Ld + Md))
            / 1E6)

        let (dPsi, dEpsilon) = t.nutation
        let ecliptic = t.meanObliquityOfEcliptic + dEpsilon

        let (lambda, beta) = SwiftAstro.Angle.asEquatorialCoordinates(
            lon: Ld + lAdditive + dPsi,
            lat: bAdditive,
            ecliptic: ecliptic)

        return (lambda.unwound, beta.unwound)
    }

}

// MARK: - Periodic Terms for the Moon

extension SwiftAstro.Moon {

    private struct MoonTerm {
        let d: Double
        let m: Double
        let mDash: Double
        let f: Double
        let cSin: Double
        let cCos: Double

        init(
            _ d: Double,
            _ m: Double,
            _ mDash: Double,
            _ f: Double,
            _ cSin: Double,
            _ cCos: Double
        ) {
            self.d = d
            self.m = m
            self.mDash = mDash
            self.f = f
            self.cSin = cSin
            self.cCos = cCos
        }
    }

    private static let lrMoonTerms = [
        MoonTerm(0, 0, 1, 0, 6288774, -20905355),
        MoonTerm(2, 0, -1, 0, 1274027, -3699111),
        MoonTerm(2, 0, 0, 0, 658314, -2955968),
        MoonTerm(0, 0, 2, 0, 213618, -569925),
        MoonTerm(0, 1, 0, 0, -185116, 48888),
        MoonTerm(0, 0, 0, 2, -114332, -3149),
        MoonTerm(2, 0, -2, 0, 58793, 246158),
        MoonTerm(2, -1, -1, 0, 57066, -152138),
        MoonTerm(2, 0, 1, 0, 53322, -170733),
        MoonTerm(2, -1, 0, 0, 45758, -204586),
        MoonTerm(0, 1, -1, 0, -40923, -129620),
        MoonTerm(1, 0, 0, 0, -34720, 108743),
        MoonTerm(0, 1, 1, 0, -30383, 104755),
        MoonTerm(2, 0, 0, -2, 15327, 10321),
        MoonTerm(0, 0, 1, 2, -12528, 0),
        MoonTerm(0, 0, 1, -2, 10980, 79661),
        MoonTerm(4, 0, -1, 0, 10675, -34782),
        MoonTerm(0, 0, 3, 0, 10034, -23210),
        MoonTerm(4, 0, -2, 0, 8548, -21636),
        MoonTerm(2, 1, -1, 0, -7888, 24208),
        MoonTerm(2, 1, 0, 0, -6766, 30824),
        MoonTerm(1, 0, -1, 0, -5163, -8379),
        MoonTerm(1, 1, 0, 0, 4987, -16675),
        MoonTerm(2, -1, 1, 0, 4036, -12831),
        MoonTerm(2, 0, 2, 0, 3994, -10445),
        MoonTerm(4, 0, 0, 0, 3861, -11650),
        MoonTerm(2, 0, -3, 0, 3665, 14403),
        MoonTerm(0, 1, -2, 0, -2689, -7003),
        MoonTerm(2, 0, -1, 2, -2602, 0),
        MoonTerm(2, -1, -2, 0, 2390, 10056),
        MoonTerm(1, 0, 1, 0, -2348, 6322),
        MoonTerm(2, -2, 0, 0, 2236, -9884),
        MoonTerm(0, 1, 2, 0, -2120, 5751),
        MoonTerm(0, 2, 0, 0, -2069, 0),
        MoonTerm(2, -2, -1, 0, 2048, -4950),
        MoonTerm(2, 0, 1, -2, -1773, 4130),
        MoonTerm(2, 0, 0, 2, -1595, 0),
        MoonTerm(4, -1, -1, 0, 1215, -3958),
        MoonTerm(0, 0, 2, 2, -1110, 0),
        MoonTerm(3, 0, -1, 0, -892, 3258),
        MoonTerm(2, 1, 1, 0, -810, 2616),
        MoonTerm(4, -1, -2, 0, 759, -1897),
        MoonTerm(0, 2, -1, 0, -713, -2117),
        MoonTerm(2, 2, -1, 0, -700, 2354),
        MoonTerm(2, 1, -2, 0, 691, 0),
        MoonTerm(2, -1, 0, -2, 596, 0),
        MoonTerm(4, 0, 1, 0, 549, -1423),
        MoonTerm(0, 0, 4, 0, 537, -1117),
        MoonTerm(4, -1, 0, 0, 520, -1571),
        MoonTerm(1, 0, -2, 0, -487, -1739),
        MoonTerm(2, 1, 0, -2, -399, 0),
        MoonTerm(0, 0, 2, -2, -381, -4421),
        MoonTerm(1, 1, 1, 0, 351, 0),
        MoonTerm(3, 0, -2, 0, -340, 0),
        MoonTerm(4, 0, -3, 0, 330, 0),
        MoonTerm(2, -1, 2, 0, 327, 0),
        MoonTerm(0, 2, 1, 0, -323, 1165),
        MoonTerm(1, 1, -1, 0, 299, 0),
        MoonTerm(2, 0, 3, 0, 294, 0),
        MoonTerm(2, 0, -1, -2, 0, 8752)
    ]

    private static let bMoonTerms = [
        MoonTerm(0, 0, 0, 1, 5128122, 0),
        MoonTerm(0, 0, 1, 1, 280602, 0),
        MoonTerm(0, 0, 1, -1, 277693, 0),
        MoonTerm(2, 0, 0, -1, 173237, 0),
        MoonTerm(2, 0, -1, 1, 55413, 0),
        MoonTerm(2, 0, -1, -1, 46271, 0),
        MoonTerm(2, 0, 0, 1, 32573, 0),
        MoonTerm(0, 0, 2, 1, 17198, 0),
        MoonTerm(2, 0, 1, -1, 9266, 0),
        MoonTerm(0, 0, 2, -1, 8822, 0),
        MoonTerm(2, -1, 0, -1, 8216, 0),
        MoonTerm(2, 0, -2, -1, 4324, 0),
        MoonTerm(2, 0, 1, 1, 4200, 0),
        MoonTerm(2, 1, 0, -1, -3359, 0),
        MoonTerm(2, -1, -1, 1, 2463, 0),
        MoonTerm(2, -1, 0, 1, 2211, 0),
        MoonTerm(2, -1, -1, -1, 2065, 0),
        MoonTerm(0, 1, -1, -1, -1870, 0),
        MoonTerm(4, 0, -1, -1, 1828, 0),
        MoonTerm(0, 1, 0, 1, -1794, 0),
        MoonTerm(0, 0, 0, 3, -1749, 0),
        MoonTerm(0, 1, -1, 1, -1565, 0),
        MoonTerm(1, 0, 0, 1, -1491, 0),
        MoonTerm(0, 1, 1, 1, -1475, 0),
        MoonTerm(0, 1, 1, -1, -1410, 0),
        MoonTerm(0, 1, 0, -1, -1344, 0),
        MoonTerm(1, 0, 0, -1, -1335, 0),
        MoonTerm(0, 0, 3, 1, 1107, 0),
        MoonTerm(4, 0, 0, -1, 1021, 0),
        MoonTerm(4, 0, -1, 1, 833, 0),
        MoonTerm(0, 0, 1, -3, 777, 0),
        MoonTerm(4, 0, -2, 1, 671, 0),
        MoonTerm(2, 0, 0, -3, 607, 0),
        MoonTerm(2, 0, 2, -1, 596, 0),
        MoonTerm(2, -1, 1, -1, 491, 0),
        MoonTerm(2, 0, -2, 1, -451, 0),
        MoonTerm(0, 0, 3, -1, 439, 0),
        MoonTerm(2, 0, 2, 1, 422, 0),
        MoonTerm(2, 0, -3, -1, 421, 0),
        MoonTerm(2, 1, -1, 1, -366, 0),
        MoonTerm(2, 1, 0, 1, -351, 0),
        MoonTerm(4, 0, 0, 1, 331, 0),
        MoonTerm(2, -1, 1, 1, 315, 0),
        MoonTerm(2, -2, 0, -1, 302, 0),
        MoonTerm(0, 0, 1, 3, -283, 0),
        MoonTerm(2, 1, 1, -1, -229, 0),
        MoonTerm(1, 1, 0, -1, 223, 0),
        MoonTerm(1, 1, 0, 1, 223, 0),
        MoonTerm(0, 1, -2, -1, -220, 0),
        MoonTerm(2, 1, -1, -1, -220, 0),
        MoonTerm(1, 0, 1, 1, -185, 0),
        MoonTerm(2, -1, -2, -1, 181, 0),
        MoonTerm(0, 1, 2, 1, -177, 0),
        MoonTerm(4, 0, -2, -1, 176, 0),
        MoonTerm(4, -1, -1, -1, 166, 0),
        MoonTerm(1, 0, 1, -1, -164, 0),
        MoonTerm(4, 0, 1, -1, 132, 0),
        MoonTerm(1, 0, -1, -1, -119, 0),
        MoonTerm(4, -1, 0, -1, 115, 0),
        MoonTerm(2, -2, 0, 1, 107, 0)
    ]

}
