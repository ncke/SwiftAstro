import Foundation

// MARK: - Greek

extension SwiftAstro {

    public struct Greek {
        public let simbad: Simbad
        public let letter: String
        public let number: Int?

        public init(simbad: Simbad, number: Int? = nil) {
            self.simbad = simbad
            self.letter = simbad.asLetter
            self.number = number
        }

        init?(simbad: Simbad?, number: Int?) {
            guard let simbad = simbad else { return nil }
            self.init(simbad: simbad, number: number)
        }

        public init?(simbadCoding: String) {
            guard let (coding, number) = Self.split(simbadCoding) else {
                return nil
            }

            self.init(
                simbad: Simbad.fromSimbadCoding(coding),
                number: number)
        }

        public init?(hrCoding: String) {
            guard let (coding, number) = Self.split(hrCoding) else {
                return nil
            }

            self.init(
                simbad: Simbad.fromHRCoding(coding),
                number: number)
        }

        public init?(greekLetter: String) {
            guard let (coding, number) = Self.split(greekLetter) else {
                return nil
            }

            self.init(simbad: Simbad.fromLetter(coding), number: number)
        }

        private static func split(_ string: String) -> (String, Int?)? {
            let digitIndex = string.firstIndex { c in c.isNumber }
            guard let idx = digitIndex else { return (string, nil) }
            let coding = string[string.startIndex..<idx]
            let digits = string[idx..<string.endIndex]
            guard let number = Int(digits) else { return nil }
            return (String(coding), number)
        }

    }

}

// MARK: - Simbad

extension SwiftAstro.Greek {

    public enum Simbad: Hashable {
        case alf, bet, gam, del, eps, zet, eta, tet
        case iot, kap, lam, mu,  nu,  ksi, omi, pi
        case rho, sig, tau, ups, phi, khi, psi, ome

        private static let simbadLookup: [String: Simbad] = [
            "alf": .alf, "bet": .bet, "gam": .gam, "del": .del,
            "eps": .eps, "zet": .zet, "eta": .eta, "tet": .tet,
            "iot": .iot, "kap": .kap, "lam": .lam, "mu" : .mu,
            "nu" : .nu,  "ksi": .ksi, "omi": .omi, "pi" : .pi,
            "rho": .rho, "sig": .sig, "tau": .tau, "ups": .ups,
            "phi": .phi, "khi": .khi, "psi": .psi, "ome": .omi
        ]

        private static let hrLookup: [String: Simbad] = [
            "alp": .alf, "bet": .bet, "gam": .gam, "del": .del,
            "eps": .eps, "zet": .zet, "eta": .eta, "the": .tet,
            "iot": .iot, "kap": .kap, "lam": .lam, "mu" : .mu,
            "nu" : .nu,  "xi" : .ksi, "omi": .omi, "pi" : .pi,
            "rho": .rho, "sig": .sig, "tau": .tau, "ups": .ups,
            "phi": .phi, "chi": .khi, "psi": .psi, "ome": .omi
        ]

        private static let letterLookup: [Simbad: String] = [
            .alf: "α", .bet: "β", .gam: "γ", .del: "δ",
            .eps: "ε", .zet: "ζ", .eta: "η", .tet: "θ",
            .iot: "ι", .kap: "κ", .lam: "λ", .mu : "µ",
            .nu : "ν", .ksi: "ξ", .omi: "o", .pi : "π",
            .rho: "ρ", .sig: "σ", .tau: "τ", .ups: "υ",
            .phi: "φ", .khi: "χ", .psi: "ψ", .ome: "ω",
        ]

        static func fromSimbadCoding(_ coding: String) -> Simbad? {
            simbadLookup[coding.lowercased()]
        }

        static func fromHRCoding(_ coding: String) -> Simbad? {
            hrLookup[coding.lowercased()]
        }

        static func fromLetter(_ letter: String) -> Simbad? {
            (letterLookup.first { (s, g) in letter == g })?.0
        }

        var asLetter: String { Self.letterLookup[self]! }

    }

}
