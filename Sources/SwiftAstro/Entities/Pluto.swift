import Foundation

// MARK: - Pluto

extension SwiftAstro {

    public struct Pluto : 
        HeliocentricallyPositionable,
        GeocentricallyPositionable,
        AstronomicallyNameable
    {
        public let name: String? = "Pluto"
    }

    public static let pluto = Pluto()

}

// MARK: - Heliocentric Position of Pluto

extension SwiftAstro.Pluto {

    /// Computes the heliocentric position of Pluto using the method described in Chapter 36 of
    /// Meeus (1991).
    /// - Note: The position is considered accurate only for the years 1885 to 2099.
    public func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition {
        let T = t.julianCenturiesSinceEpoch(.J2000)
        let J = 34.35 + 3034.9057 * T
        let S = 50.08 + 1222.1138 * T
        let P = 238.96 + 144.96 * T

        func term(_ pt: PlutoTerm) -> (Double, Double, Double) {
            let alpha = SwiftAstro.Angle(degrees: pt.j * J + pt.s * S + pt.p * P)
            let sina = sin(alpha)
            let cosa = cos(alpha)
            return (
                pt.aLon * sina + pt.bLon * cosa,
                pt.aLat * sina + pt.bLat * cosa,
                pt.aRad * sina + pt.bRad * cosa)
        }

        let (lonSum, latSum, radSum) = Self.plutoTerms.reduce((0.0, 0.0, 0.0)) {
            partial, pt in

            let (lonAcc, latAcc, radAcc) = partial
            let (lon, lat, rad) = term(pt)
            return (lonAcc + lon, latAcc + lat, radAcc + rad)
        }

        let lon = 238.956785 + 144.96 * T + (lonSum / 1E6)
        let lat = -3.908202 + (latSum / 1E6)
        let rad = 40.7247248 + (radSum / 1E7)

        return SwiftAstro.SphericalPosition(
            longitude: SwiftAstro.Angle(degrees: lon).unwound,
            latitude: SwiftAstro.Angle(degrees: lat).unwound,
            radius: SwiftAstro.Distance(astronomicalUnits: rad))
    }

}

// MARK: - Periodic Terms for Pluto

extension SwiftAstro.Pluto {

    private struct PlutoTerm {
        let j: Double
        let s: Double
        let p: Double
        let aLon: Double
        let bLon: Double
        let aLat: Double
        let bLat: Double
        let aRad: Double
        let bRad: Double

        init(
            _ j: Double,
            _ s: Double,
            _ p: Double,
            _ aLon: Double,
            _ bLon: Double,
            _ aLat: Double,
            _ bLat: Double,
            _ aRad: Double,
            _ bRad: Double
        ) {
            self.j = j
            self.s = s
            self.p = p
            self.aLon = aLon
            self.bLon = bLon
            self.aLat = aLat
            self.bLat = bLat
            self.aRad = aRad
            self.bRad = bRad
        }

    }

    private static let plutoTerms = [
        PlutoTerm(0, 0, 1, -19798886, 19848454, -5453098, -14974876, 66867334, 68955876),
        PlutoTerm(0, 0, 2, 897499, -4955707, 3527363, 1672673, -11826086, -333765),
        PlutoTerm(0, 0, 3, 610820, 1210521, -1050939, 327763, 1593657, -1439953),
        PlutoTerm(0, 0, 4, -341639, -189719, 178691, -291925, -18948, 482443),
        PlutoTerm(0, 0, 5, 129027, -34863, 18763, 100448, -66634, -85576),
        PlutoTerm(0, 0, 6, -38215, 31061, -30594, -25838, 30841, -5765),
        PlutoTerm(0, 1, -1, 20349, -9886, 4965, 11263, -6140, 22254),
        PlutoTerm(0, 1, 0, -4045, -4904, 310, -132, 4434, 4443),
        PlutoTerm(0, 1, 1, -5885, -3238, 2036, -947, -1518, 641),
        PlutoTerm(0, 1, 2, -3812, 3011, -2, -674, -5, 792),
        PlutoTerm(0, 1, 3, -601, 3468, -329, -563, 518, 518),
        PlutoTerm(0, 2, -2, 1237, 463, -64, 39, -13, -221),
        PlutoTerm(0, 2, -1, 1086, -911, -94, 210, 837, -494),
        PlutoTerm(0, 2, 0, 595, -1229, -8, -160, -281, 616),
        PlutoTerm(1, -1, 0, 2484, -485, -177, 259, 260, -395),
        PlutoTerm(1, -1, 1, 839, -1414, 17, 234, -191, -396),
        PlutoTerm(1, 0, -3, -964, 1059, 582, -285, -3218, 370),
        PlutoTerm(1, 0, -2, -2303, -1038, -298, 692, 8019, -7869),
        PlutoTerm(1, 0, -1, 7049, 747, 157, 201, 105, 45637),
        PlutoTerm(1, 0, 0, 1179, -358, 304, 825, 8623, 8444),
        PlutoTerm(1, 0, 1, 393, -63, -124, -29, -896, -801),
        PlutoTerm(1, 0, 2, 111, -268, 15, 8, 208, -122),
        PlutoTerm(1, 0, 3, -52, -154, 7, 15, -133, 65),
        PlutoTerm(1, 0, 4, -78, -30, 2, 2, -16, 1),
        PlutoTerm(1, 1, -3, -34, -26, 4, 2, -22, 7),
        PlutoTerm(1, 1, -2, -43, 1, 3, 0, -8, 16),
        PlutoTerm(1, 1, -1, -15, 21, 1, -1, 2, 9),
        PlutoTerm(1, 1, 0, -1, 15, 0, -2, 12, 5),
        PlutoTerm(1, 1, 1, 4, 7, 1, 0, 1, -3),
        PlutoTerm(1, 1, 3, 1, 5, 1, -1, 1, 0),
        PlutoTerm(2, 0, -6, 8, 3, -2, -3, 9, 5),
        PlutoTerm(2, 0, -5, -3, 6, 1, 2, 2, -1),
        PlutoTerm(2, 0, -4, 6, -13, -8, 2, 14, 10),
        PlutoTerm(2, 0, -3, 10, 22, 10, -7, -65, 12),
        PlutoTerm(2, 0, -2, -57, -32, 0, 21, 126, -233),
        PlutoTerm(2, 0, -1, 157, -46, 8, 5, 270, 1068),
        PlutoTerm(2, 0, 0, 12, -18, 13, 16, 254, 155),
        PlutoTerm(2, 0, 1, -4, 8, -2, -3, -26, -2),
        PlutoTerm(2, 0, 2, -5, 0, 0, 0, 7, 0),
        PlutoTerm(2, 0, 3, 3, 4, 0, 1, -11, 4),
        PlutoTerm(3, 0, -2, -1, -1, 0, 1, 4, -14),
        PlutoTerm(3, 0, -1, 6, -3, 0, 0, 18, 35),
        PlutoTerm(3, 0, 0, -1, -2, 0, 1, 13, 3)
    ]

}
