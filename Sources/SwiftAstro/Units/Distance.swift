//
//  Distance.swift
//  
//
//  Created by Nick on 09/02/2023.
//

import Foundation

// MARK: - Distance

extension SwiftAstro {
    
    public struct Distance: Equatable, Comparable, CustomStringConvertible {
        public var astronomicalUnits: Double
        
        public var description: String {
            return "\(astronomicalUnits) au"
        }

        public static let zero = Distance(astronomicalUnits: 0.0)
    }
    
}

// MARK: - Public Constants

extension SwiftAstro.Distance {
    
    public static let metersPerAstronomicalUnit = 149597870700.0
    public static let metersPerLightYear = 9460730472580800.0
    public static let lightSecondsPerLightYear = 31557600.0
    public static let metersPerLightSecond = 299792458.0
    public static let metersPerLightMinute = 17987547480.0
    public static let astronomicalUnitsPerParsec = 206264.80624709636
    public static let astronomicalUnitsPerLightYear = 63241.07708426628
    public static let lightSecondsPerAstronomicalUnit = 499.00478383615643

}

// MARK: - Meters

extension SwiftAstro.Distance {
    
    public var meters: Double {
        astronomicalUnits * Self.metersPerAstronomicalUnit
    }
    
    public init(meters: Double) {
        astronomicalUnits = meters / Self.metersPerAstronomicalUnit
    }
    
}

// MARK: - Light Years etc

extension SwiftAstro.Distance {
    
    public var lightYears: Double {
        astronomicalUnits / Self.astronomicalUnitsPerLightYear
    }
    
    public init(lightYears: Double) {
        astronomicalUnits = lightYears * Self.astronomicalUnitsPerLightYear
    }

    public var lightDays: Double {
        lightSeconds / SwiftAstro.Time.secondsPerDay
    }

    public init(lightDays: Double) {
        self.init(lightSeconds: lightDays * SwiftAstro.Time.secondsPerDay)
    }

    public var lightMinutes: Double {
        lightSeconds / 60.0
    }

    public init(lightMinutes: Double) {
        self.init(lightSeconds: 60.0 * lightMinutes)
    }

    public var lightSeconds: Double {
        astronomicalUnits * Self.lightSecondsPerAstronomicalUnit
    }
    
    public init(lightSeconds: Double) {
        astronomicalUnits = lightSeconds / Self.lightSecondsPerAstronomicalUnit
    }

}

// MARK: - Parsecs

extension SwiftAstro.Distance {
    
    public var parsecs: Double {
        astronomicalUnits / Self.astronomicalUnitsPerParsec
    }
    
    public init(parsecs: Double) {
        astronomicalUnits = parsecs * Self.astronomicalUnitsPerParsec
    }

}

// MARK: - Operators

extension SwiftAstro.Distance {
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(astronomicalUnits: lhs.astronomicalUnits + rhs.astronomicalUnits)
    }
    
    public static func +=(lhs: inout Self, rhs: Self) -> Self {
        lhs + rhs
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(astronomicalUnits: lhs.astronomicalUnits - rhs.astronomicalUnits)
    }
    
    public static func -=(lhs: inout Self, rhs: Self) -> Self {
        lhs - rhs
    }
    
    public static func *(lhs: Self, rhs: Self) -> Self {
        return Self(astronomicalUnits: lhs.astronomicalUnits * rhs.astronomicalUnits)
    }
    
    public static func *=(lhs: inout Self, rhs: Self) -> Self {
        lhs * rhs
    }
    
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(astronomicalUnits: lhs.astronomicalUnits / rhs.astronomicalUnits)
    }
    
    public static func /=(lhs: inout Self, rhs: Self) -> Self {
        lhs / rhs
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.astronomicalUnits == rhs.astronomicalUnits
    }
    
    public static func !=(lhs: Self, rhs: Self) -> Bool {
        lhs.astronomicalUnits != rhs.astronomicalUnits
    }
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.astronomicalUnits < rhs.astronomicalUnits
    }
    
    public static func <=(lhs: Self, rhs: Self) -> Bool {
        lhs.astronomicalUnits <= rhs.astronomicalUnits
    }
    
    public static func >(lhs: Self, rhs: Self) -> Bool {
        lhs.astronomicalUnits > rhs.astronomicalUnits
    }
    
    public static func >=(lhs: Self, rhs: Self) -> Bool {
        lhs.astronomicalUnits >= rhs.astronomicalUnits
    }
    
    public static prefix func -(lhs: Self) -> Self {
        Self(astronomicalUnits: -lhs.astronomicalUnits)
    }
    
    public static prefix func +(lhs: Self) -> Self {
        lhs
    }
    
    public static prefix func ..<(lhs: Self) -> PartialRangeUpTo<Self> {
        PartialRangeUpTo(lhs)
    }
    
    public static prefix func ...(lhs: Self) -> PartialRangeThrough<Self> {
        PartialRangeThrough(lhs)
    }
    
    public static postfix func ...(lhs: Self) -> PartialRangeFrom<Self> {
        PartialRangeFrom(lhs)
    }
    
}
