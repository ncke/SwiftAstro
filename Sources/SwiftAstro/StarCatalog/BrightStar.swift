import Foundation

// MARK: - Bright Star

extension SwiftAstro {
    
    public struct BrightStar {
        
        // MARK: - Catalog Numbers
        
        /// Harvard Revised Star Number (Bright Star Number).
        public let number: Int
        
        /// Common name of the star.
        public let commonName: String?
        
        /// Durchmusterung Identification.
        public let durchmusterungIdentification: String?
        
        /// Henry Draper Catalog Number.
        public let henryDraperCatalogNumber: Int?
        
        /// SAO Catalog Number.
        public let saoCatalogNumber: Int?
        
        /// FK5 Star Number.
        public let fk5StarNumber: Int?
        
        // MARK: - Infrared
        
        let irFlag: Bool
        
        /// True if the star is an infrared source, false otherwise.
        public var isInfraredSource: Bool {
            return irFlag
        }
        
        public enum InfraredSourceReference {
            
            /// NASA Merged Infrared Catalogue, Schmitz et al., 1978.
            case nasaMergedInfraredCatalogue
            
            /// Engles et al., 1982.
            case englesEtAl
            
            /// Reference uncertain.
            case uncertain
        }
        
        /// Reference for the infrared source.
        public var infraredSourceReference: InfraredSourceReference? {
            guard irFlag else {
                return nil
            }
            
            switch irFlagReference {
            case "'": return .englesEtAl
            case ":": return .uncertain
            default: return .nasaMergedInfraredCatalogue
            }
        }
        
        let irFlagReference: String?
        
        // MARK: - Multiple Stars
        
        public enum MultipleStarCode {
            
            /// Astrometric binary.
            case astrometricBinary
            
            /// Duplicity discovered by occultation.
            case discoveredByOccultation
            
            /// Innes, Southern Double Star Catalogue (1927).
            case innesSouthernDoubleStarCatalogue
            
            /// Rossiter, Michigan Publ. 9, 1955.
            case rossiterMichigan
            
            /// Duplicity discovered by speckle inferometry.
            case discoveredBySpeckleInferometry
            
            /// Worley (1978) update of the IDS.
            case worleyUpdate
        }
        
        /// Multiple star coding.
        public var multipleStarCode: MultipleStarCode? {
            guard let code = multipleCode else {
                return nil
            }
            
            switch code {
            case "A": return .astrometricBinary
            case "D": return .discoveredByOccultation
            case "I": return .innesSouthernDoubleStarCatalogue
            case "R": return .rossiterMichigan
            case "S": return .discoveredBySpeckleInferometry
            case "W": return .worleyUpdate
            default: return nil
            }
        }
        
        public var isMultipleStar: Bool {
            multipleCode != nil
            || magnitudeDifference != nil
            || componentsCount != nil
        }
        
        let multipleCode: String?
        
        /// Aitkens Double Star Catalogue designation
        public let aitkensDoubleStarDesignation: String?
        
        /// Aitkens Double Star Catalogue number components
        public let adsNumberComponents: String?
        
        /// Variable star identification.
        public let variableStarIdentification: String?
        
        // MARK: - 1900 Ephemeris
        
        /// Right ascension, equinox B1900, epoch 1900.0.
        public let rightAscension1900: SwiftAstro.Angle?
        
        /// Declination, equinox B1900, epoch 1900.0.
        public let declination1900: SwiftAstro.Angle?
        
        // MARK: - 2000 Ephemeris
        
        /// Right ascension, equinox B2000, epoch 2000.0.
        public let rightAscension: SwiftAstro.Angle?
        
        /// Declination, equinox B2000, epoch 2000.0.
        public let declination: SwiftAstro.Angle?
        
        // MARK: - Galactic Lat Long
        
        /// Galactic longitude.
        public let galacticLongitude: SwiftAstro.Angle?
        
        /// Galactic latitude.
        public let galacticLatitude: SwiftAstro.Angle?
        
        // MARK: - Visual Magnitude
        
        /// Visual magnitude.
        public let visualMagnitude: Double?
        
        public enum VisualMagnitudeSystem {
            
            /// V on UBV Johnson system.
            case vOnUBVJohnson
            
            /// HR magnitudes reduced to the UBV system.
            case hrReduced
            
            /// Original HR magnitude.
            case hrOriginal
        }
        
        public var visualMagnitudeSystem: VisualMagnitudeSystem? {
            switch visualMagnitudeCode {
            case "V": return .vOnUBVJohnson
            case "R": return .hrReduced
            case "H": return .hrOriginal
            default: return nil
            }
        }
        
        let visualMagnitudeCode: String?
        
        /// Is the visual magnitude uncertain.
        public let isVisualMagnitudeUncertain: Bool
        
        // MARK: - UBV Color
        
        public struct UBVColor {
            public let bv: Double?
            public let ub: Double?
            public let isBvUncertain: Bool
            public let isUbUncertain: Bool
            public let isUncertain: Bool
        }
        
        public var ubvColor: UBVColor? {
            guard bvColor != nil || ubColor != nil else { return nil }
            
            return UBVColor(
                bv: bvColor,
                ub: ubColor,
                isBvUncertain: isBvColorUncertain,
                isUbUncertain: isUbColorUncertain,
                isUncertain: isBvColorUncertain || isUbColorUncertain)
        }
        
        let bvColor: Double?
        let isBvColorUncertain: Bool
        let ubColor: Double?
        let isUbColorUncertain: Bool
        
        // MARK: - RI Color
        
        public struct RIColor {
            public let ri: Double
            
            public enum System {
                case cousin
                case eggen
                case unknown
            }
            
            public let system: System
        }
        
        public var riColor: RIColor? {
            guard let ri = riInSystem else { return nil }
            
            var system = RIColor.System.unknown
            if let code = riSystemCode {
                if code.containsCharacter("C") {
                    system = .cousin
                } else if code.containsCharacter("E") {
                    system = .eggen
                }
            }
            
            return RIColor(ri: ri, system: system)
        }
        
        let riInSystem: Double?
        let riSystemCode: String?
        
        // MARK: - Spectral Type
        
        let spectralType: String?
        let spectralTypeCode: String?
        
        // MARK: - Annual Motion
        
        public struct AnnualMotion {
            public let rightAscension: SwiftAstro.Angle
            public let declination: SwiftAstro.Angle
        }
        
        public var annualMotion: AnnualMotion? {
            guard
                let ra = raAnnualMotion,
                let dec = decAnnualMotion
            else {
                return nil
            }
            
            return AnnualMotion(rightAscension: ra, declination: dec)
        }
        
        let raAnnualMotion: SwiftAstro.Angle?
        let decAnnualMotion: SwiftAstro.Angle?
        
        // MARK: - Parallax
        
        public enum Parallax {
            
            /// Trigonometric parallax.
            case trigonometric(angle: SwiftAstro.Angle)
            
            /// Dynamical parallax.
            case dynamical
        }
        
        /// Star parallax.
        public var parallax: Parallax {
            if let angle = trigonometricParallax {
                return .trigonometric(angle: angle)
            }
            
            return .dynamical
        }
        
        let isTrigonometricParallax: Bool
        let trigonometricParallax: SwiftAstro.Angle?
        
        // MARK: - Heliocentric Radial Velocity
        
        public struct HeliocentricRadialVelocity {
            
            /// Heliocentric radial velocity km/s.
            public let velocity: Int
            
            /// True if orbital data is available, false otherwise.
            public var isOrbitalDataAvailable: Bool {
                guard let comments = comments else { return false }
                return comments.containsCharacter("O")
            }
            
            /// True if variable radial velocity is suspected, false otherwise.
            public var isVariabilitySuspected: Bool {
                guard let comments = comments else { return false }
                return comments.containsCharacter("?")
            }
            
            /// True if flagged as a spectroscopic binary, false otherwise.
            public var isSpectroscopicBinary: Bool {
                guard let comments = comments else { return false }
                return comments.containsCharacter("S")
            }
            
            /// Number of spectra lines for spectroscopic binary, if known.
            public var spectraLines: Int? {
                guard let comments = comments else { return nil }
                
                if comments.containsCharacter("1") {
                    return 1
                } else if comments.containsCharacter("2") {
                    return 2
                } else if comments.containsCharacter("3") {
                    return 3
                }
                
                return nil
            }
            
            let comments: String?
            
        }
        
        public var heliocentricRadialVelocity: HeliocentricRadialVelocity? {
            guard let velocity = catHeliocentricRadialVelocity else {
                return nil
            }
            
            return HeliocentricRadialVelocity(
                velocity: velocity,
                comments: catHeliocentricRadialVelocityComments
            )
        }
        
        let catHeliocentricRadialVelocity: Int?
        let catHeliocentricRadialVelocityComments: String?
        
        // MARK: - Rotational Velocity
        
        public struct RotationalVelocity {
            
            /// Rotational velocity, v sin i (km/s).
            public let velocity: Int
            
            /// Uncertainty or variability of rotational velocity.
            public let isUncertain: Bool
            
            /// Rotational velocity limit characters.
            public let limitCharacters: String?
        }
        
        public var rotationalVelocity: RotationalVelocity? {
            guard let velocity = catRotationalVelocity else {
                return nil
            }
            
            return RotationalVelocity(
                velocity: velocity,
                isUncertain: isRotationalVelocityUncertain,
                limitCharacters: catRotationalVelocityLimitCharacters)
        }
        
        let catRotationalVelocityLimitCharacters: String?
        let catRotationalVelocity: Int?
        let isRotationalVelocityUncertain: Bool
        
        // MARK: - Multiple Star Magnitudes
        
        /// Magnitude difference of double or brightest multiple.
        public let magnitudeDifference: Double?
        
        /// Separation of components in Dmag if occultation binary.
        public let componentsSeparation: SwiftAstro.Angle?
        
        /// Identification of components in DMag.
        public let componentsIdentificiation: String?
        
        /// Number of components assigned to a multiple.
        public let componentsCount: Int?
        
        // MARK: - Notes
        
        /// True if there are accompanying notes, false otherwise.
        public let hasNote: Bool
        
        /// Accompanying notes.
        public var notes: [Note]? {
            SwiftAstro.brightStarCatalog.notes(number: number)
        }
        
    }
}

// MARK: - Note

extension SwiftAstro.BrightStar {
    
    public struct Note {
        
        /// Harvard Revised Star Number.
        public let number: Int
        
        /// Index number for note.
        public let counter: Int
        
        public enum NoteCategory {
            case colors
            case doubleAndMultipleStars
            case dynamicalParallaxes
            case groupMembership
            case miscellaneous
            case starNames
            case polarization
            case stellarRadiiOrDiameters
            case radialOrRotationalVelocities
            case spectra
            case spectroscopicBinaries
            case variability
            case unknown
        }
        
        public var noteCategory: NoteCategory {
            if category.containsCharacter("C") {
                return .colors
            } else if category.containsCharacter("Y") {
                return .dynamicalParallaxes
            } else if category.containsCharacter("D") {
                return .doubleAndMultipleStars
            } else if category.containsCharacter("G") {
                return .groupMembership
            } else if category.containsCharacter("M") {
                return .miscellaneous
            } else if category.containsCharacter("N") {
                return .starNames
            } else if category.containsCharacter("P") {
                return .polarization
            } else if category.containsCharacter("A") {
                return .variability
            } else if category.containsCharacter("V") {
                return .radialOrRotationalVelocities
            } else if category.containsCharacter("R") {
                return .stellarRadiiOrDiameters
            } else if category.containsCharacter("B") {
                return .spectroscopicBinaries
            } else if category.containsCharacter("S") {
                return .spectra
            }
            
            return .unknown
        }
        
        let category: String
        
        /// Remark.
        public let remark: String?
    }
    
}
