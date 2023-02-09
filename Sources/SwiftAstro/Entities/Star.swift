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
        let name: String?
        let bayerDesignation: String?
        let distance: Distance?
        let rightAscension: Angle
        let declination: Angle
        let apparentMagnitude: Double
        let constellation: Constellation
        
        
        
    }
    
}

// MARK: - Bright Stars

extension SwiftAstro.Star {
    
    public static var brightStars: [SwiftAstro.Star] = [
        
        SwiftAstro.Star(
            name: "Sirius A",
            bayerDesignation: "α CMa",
            distance: SwiftAstro.Distance(lightYears: 8.60),
            rightAscension: SwiftAstro.Angle(hours: 6, minutes: 45, seconds: 8.917),
            declination: SwiftAstro.Angle(degrees: -16, minutes: 42, seconds: 58.02),
            apparentMagnitude: 8.44,
            constellation: .canisMajor
        )
        
    ]
    
}
