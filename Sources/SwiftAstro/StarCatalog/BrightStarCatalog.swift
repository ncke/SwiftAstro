import Foundation

// MARK: - Bright Star Catalog

extension SwiftAstro {
    
    public struct BrightStarCatalog {
        
        public let stars: [SwiftAstro.BrightStar]
        let notes: [Int: [SwiftAstro.BrightStar.Note]]
        
        init() {
            stars = Self.parseStarCatalog()
            notes = Self.parseStarNotes()
        }
        
        public subscript(number: Int) -> SwiftAstro.BrightStar? {
            let idx = number - 1
            guard idx >= 0, idx < stars.count else {
                return nil
            }
            
            return stars[idx]
        }
        
        public func notes(number: Int) -> [SwiftAstro.BrightStar.Note]? {
            notes[number]
        }
        
    }
    
}

// MARK: - Parse Stars

private extension SwiftAstro.BrightStarCatalog {
    
    static func parseStarCatalog() -> [SwiftAstro.BrightStar] {
        let lines = try! Utility.stringsForResource(
            "yale-bright-star-catalog",
            withExtension: "txt"
        )
        
        var catalog = [SwiftAstro.BrightStar]()
        
        for line in lines {
            
            let (glon, glat) = parseGalactics(line)
            let (raMotion, decMotion) = parseAnnualMotion(line)
            
            let parallax: SwiftAstro.Angle?
            if let arcs: Double = line.cols(162, 5) {
                parallax = SwiftAstro.Angle(arcSeconds: arcs)
            } else {
                parallax = nil
            }
            
            let componentsSeparation: SwiftAstro.Angle?
            if let arcs: Double = line.cols(185, 6) {
                componentsSeparation = SwiftAstro.Angle(arcSeconds: arcs)
            } else {
                componentsSeparation = nil
            }
            
            let star = SwiftAstro.BrightStar(
                number: line.cols(1, 4)!,
                commonName: line.cols(5, 10),
                durchmusterungIdentification: line.cols(15, 11),
                henryDraperCatalogNumber: line.cols(26, 6),
                saoCatalogNumber: line.cols(32, 6),
                fk5StarNumber: line.cols(38, 4),
                irFlag: line.cols(42, 1) == "I" ? true : false,
                irFlagReference: line.cols(43, 1),
                multipleCode: line.cols(44, 1),
                aitkensDoubleStarDesignation: line.cols(45, 5),
                adsNumberComponents: line.cols(50, 2),
                variableStarIdentification: line.cols(52, 9),
                rightAscension1900: parseRightAscension(line, offset: 61),
                declination1900: parseDeclination(line, offset: 69),
                rightAscension: parseRightAscension(line, offset: 76),
                declination: parseDeclination(line, offset: 84),
                galacticLongitude: glon,
                galacticLatitude: glat,
                visualMagnitude: line.cols(103, 5),
                visualMagnitudeCode: line.cols(108, 1),
                isVisualMagnitudeUncertain: line.cols(109, 1) == "?" ? true : false,
                bvColor: line.cols(110, 5),
                isBvColorUncertain: line.cols(115, 1) == "?" ? true : false,
                ubColor: line.cols(116, 5),
                isUbColorUncertain: line.cols(121, 1) == "?" ? true : false,
                riInSystem: line.cols(122, 5),
                riSystemCode: line.cols(127, 1),
                spectralType: line.cols(128, 20),
                spectralTypeCode: line.cols(148, 1),
                raAnnualMotion: raMotion,
                decAnnualMotion: decMotion,
                isTrigonometricParallax: line.cols(161, 1) == "D" ? false : true,
                trigonometricParallax: parallax,
                catHeliocentricRadialVelocity: line.cols(167, 4),
                catHeliocentricRadialVelocityComments: line.cols(171, 4),
                catRotationalVelocityLimitCharacters: line.cols(175, 2),
                catRotationalVelocity: line.cols(177, 3),
                isRotationalVelocityUncertain: line.cols(180, 1) == "?" ? true : false,
                magnitudeDifference: line.cols(181, 4),
                componentsSeparation: componentsSeparation,
                componentsIdentificiation: line.cols(191, 4),
                componentsCount: line.cols(195, 2),
                hasNote: line.cols(197, 1) == "*" ? true : false
            )
            
            catalog.append(star)
        }
        
        return catalog
    }
    
    static func parseRightAscension(
        _ line: String,
        offset: Int
    ) -> SwiftAstro.Angle? {
        guard
            let rah: Int = line.cols(offset, 2),
            let ram: Int = line.cols(offset + 2, 2),
            let ras: Double = line.cols(offset + 4, 4)
        else {
            return nil
        }
        
        return SwiftAstro.Angle(hours: rah, minutes: ram, seconds: ras)
    }
    
    static func parseDeclination(
        _ line: String,
        offset: Int
    ) -> SwiftAstro.Angle? {
        guard
            let sgn: String = line.cols(offset, 1),
            var ded: Int = line.cols(offset + 1, 2),
            let dem: Int = line.cols(offset + 3, 2),
            let des: Double = line.cols(offset + 5, 2)
        else {
            return nil
        }
        
        if sgn == "-" {
            ded = -ded
        }
        
        return SwiftAstro.Angle(degrees: ded, minutes: dem, seconds: des)
    }
    
    static func parseGalactics(
        _ line: String
    ) -> (SwiftAstro.Angle?, SwiftAstro.Angle?) {
        guard
            let glon: Double = line.cols(91, 6),
            let glat: Double = line.cols(97, 6)
        else {
            return (nil, nil)
        }
        
        return (
            SwiftAstro.Angle(degrees: glon),
            SwiftAstro.Angle(degrees: glat))
    }
    
    static func parseAnnualMotion(
        _ line: String
    ) -> (SwiftAstro.Angle?, SwiftAstro.Angle?) {
        guard
            let ra: Double = line.cols(149, 6),
            let dec: Double = line.cols(155, 6)
        else {
            return (nil, nil)
        }
        
        return (
            SwiftAstro.Angle(arcSeconds: ra),
            SwiftAstro.Angle(arcSeconds: dec))
    }
    
    
}

// MARK: - Parse Notes

extension SwiftAstro.BrightStarCatalog {
    
    static func parseStarNotes() -> [Int: [SwiftAstro.BrightStar.Note]] {
        let lines = try! Utility.stringsForResource(
            "yale-bright-star-notes",
            withExtension: "txt"
        )
        
        var notes = [SwiftAstro.BrightStar.Note]()
        
        for line in lines {
            let note = SwiftAstro.BrightStar.Note(
                number: line.cols(2, 4)!,
                counter: line.cols(6, 2)!,
                category: line.cols(8, 4)!,
                remark: line.cols(13))
            
            notes.append(note)
        }
        
        return [Int: [SwiftAstro.BrightStar.Note]](grouping: notes) { note in
            return note.number
        }
    }
    
}
