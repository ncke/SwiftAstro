//
//  Time.swift
//  
//
//  Created by Nick on 09/02/2023.
//

import Foundation

extension SwiftAstro {
    
    public struct Time: Equatable, Comparable, CustomStringConvertible {
        public let julianDays: Double
        
        public var description: String {
            "\(julianDays) jd"
        }
    }
    
}

// MARK: - Constants

extension SwiftAstro.Time {
    
    public static let secondsPerDay: TimeInterval = 86400.0
    
    public static let jd0 = SwiftAstro.Time(julianDays: 0.0)
    
    public static let julianDaysPerMillenia = 365250.0
    
    public enum Epoch {
        case J2000
        
        public var time: SwiftAstro.Time {
            switch self {
            case .J2000: return SwiftAstro.Time(julianDays: 2451545.0)
            }
        }
    }
    
}

// MARK: - Other Julian Measures

extension SwiftAstro.Time {
    
    public func julianMilleniaSinceEpoch(_ epoch: Epoch) -> Double {
        (julianDays - epoch.time.julianDays) / Self.julianDaysPerMillenia
    }
    
}

// MARK: - Time Interval
    
extension SwiftAstro.Time {
    
    private static let j0_interval: TimeInterval = -211845067200.0
    
    public var timeIntervalSinceReferenceDate: TimeInterval {
        let secsSinceJ0 = julianDays * Self.secondsPerDay
        return secsSinceJ0 + Self.j0_interval
    }
    
    public init(timeIntervalSinceReferenceDate interval: TimeInterval) {
        let secsSinceJ0 = interval - Self.j0_interval
        self.julianDays = secsSinceJ0 / Self.secondsPerDay
    }
    
}

// MARK: - Date

extension SwiftAstro.Time {
    
    public var date: Date {
        let interval = timeIntervalSinceReferenceDate
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    public init(date: Date) {
        let interval = date.timeIntervalSinceReferenceDate
        self.init(timeIntervalSinceReferenceDate: interval)
    }
    
}

// MARK: - Operators

extension SwiftAstro.Time {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.julianDays == rhs.julianDays
    }
    
    public static func !=(lhs: Self, rhs: Self) -> Bool {
        lhs.julianDays != rhs.julianDays
    }
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.julianDays < rhs.julianDays
    }
    
    public static func <=(lhs: Self, rhs: Self) -> Bool {
        lhs.julianDays <= rhs.julianDays
    }
    
    public static func >(lhs: Self, rhs: Self) -> Bool {
        lhs.julianDays > rhs.julianDays
    }
    
    public static func >=(lhs: Self, rhs: Self) -> Bool {
        lhs.julianDays >= rhs.julianDays
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

