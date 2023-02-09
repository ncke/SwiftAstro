//
//  Star.swift
//  
//
//  Created by Nick on 09/02/2023.
//

import Foundation

// MARK: - Star

extension SwiftAstro {
    
    public enum Constellation {
        case canisMajor
    }
    
    public struct Star {
        
        /// Harvard Revised Star Number (Bright Star Number).
        public let number: Int
        
        /// Common name of the star.
        public let name: String?
        
        /// Durchmusterung Identification.
        public let durchmusterungIdentification: String?
        
        /// Henry Draper Catalog Number.
        public let henryDraperCatalogNumber: Int?
        
        /// SAO Catalog Number.
        public let saoCatalogNumber: Int?
        
        /// FK5 Star Number.
        public let fk5StarNumber: Int?
        
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
        }
        
        let multipleCode: String?
        
        /// Aitkens Double Star Catalogue designation
        public let aitkensDoubleStarDesignation: String?
        
        /// Aitkens Double Star Catalogue number components
        public let adsNumberComponents: String?
        
        /// Variable star identification.
        public let variableStarIdentification: String?
        
        /// Right ascension, equinox B1900, epoch 1900.0.
        public let rightAscension1900: SwiftAstro.Angle?
        
        /// Declination, equinox B1900, epoch 1900.0.
        public let declination1900: SwiftAstro.Angle?
        
        /// Right ascension, equinox B2000, epoch 2000.0.
        public let rightAscension: SwiftAstro.Angle?
        
        /// Declination, equinox B2000, epoch 2000.0.
        public let declination: SwiftAstro.Angle?
        
        /// Galactic longitude.
        public let galacticLongitude: SwiftAstro.Angle?
        
        /// Galactic latitude.
        public let galacticLatitude: SwiftAstro.Angle?
        
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
        
        /// The purported visual magnitude limit for naked eye visibility.
        public static let magnitudeLimitForNakedEyeVisibility = 6.5
        
        /// True if the star is visible to the naked eye, false otherwise.
        public var isVisibleToNakedEye: Bool {
            guard let mag = visualMagnitude else { return false }
            return mag < Self.magnitudeLimitForNakedEyeVisibility
        }
        
        let bvColor: Double?
        let isBvColorUncertain: Bool
        let ubColor: Double?
        let isUbColorUncertain: Bool
        let riInSystem: Double?
        let riSystemCode: String?
        let spectralType: String?
        let spectralTypeCode: String?
        let raAnnualMotion: SwiftAstro.Angle?
        let decAnnualMotion: SwiftAstro.Angle?
        
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
            
            public var isSpectroscopicBinary: Bool {
                guard let comments = comments else { return false }
                return comments.containsCharacter("S")
            }
            
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
        
        let rotationalVelocityLimitCharacters: String?
        let rotationalVelocity: Int?
        let isRotationalVelocityUncertain: Bool
        let magnitudeDifference: Double?
        let componentsSeparation: SwiftAstro.Angle?
        let componentsIdentificiation: String?
        let componentsCount: Int?
        let hasNote: Bool
        
        var notes: [Note]? {
            SwiftAstro.BrightStarCatalog.catalog.notes(number: number)
        }
        
        public struct Note {
            let number: Int
            let counter: Int
            let category: String
            let remark: String?
        }
    }
    
    
    
}

// MARK: - Bright Stars

extension SwiftAstro.Star {
    
    public static var brightStars: [SwiftAstro.Star] = [
        

        
    ]
    
}
