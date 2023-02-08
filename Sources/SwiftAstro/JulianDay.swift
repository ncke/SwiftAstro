//
//  JulianDay.swift
//  
//
//  Created by Nick on 07/02/2023.
//

import Foundation

public struct JulianDay {
    
    private static let secondsPerDay: TimeInterval = 86400
    
    private static let daysPerMillenia: Double = 365250
    
    private static let t0: TimeInterval = -211845067200.0
    
    private static let j2000: Double = 2451545.0
    
    public static let zero: JulianDay = {
        return JulianDay(timeIntervalSinceReferenceDate: t0)
    }()
    
    public let value: Double
    let tau2000: Double
    
    public init(_ daysSinceJ0: Double) {
        value = daysSinceJ0
        tau2000 = (value - JulianDay.j2000) / JulianDay.daysPerMillenia
    }
    
    public init(timeIntervalSinceReferenceDate: TimeInterval) {
        let secsSinceJ0 = timeIntervalSinceReferenceDate - JulianDay.t0
        let daysSinceJ0 = secsSinceJ0 / JulianDay.secondsPerDay
        self.init(daysSinceJ0)
    }
    
    public init(date: Date) {
        let interval = date.timeIntervalSinceReferenceDate
        self.init(timeIntervalSinceReferenceDate: interval)
    }
    
    public func date() -> Date {
        let secsSinceJ0 = value * JulianDay.secondsPerDay
        
        return Date(
            timeIntervalSinceReferenceDate: secsSinceJ0 + JulianDay.t0)
    }
    
}
