//
//  JulianDayTests.swift
//  
//
//  Created by Nick on 07/02/2023.
//

import XCTest
@testable import SwiftAstro

final class JulianDayTests: XCTestCase {
    
    private func date(
        _ year: Int,
        _ month: Int,
        _ day: Int,
        _ hour: Int,
        _ minute: Int,
        _ second: Int
    ) -> Date {
        let components = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        
        return components.date!
    }
    
    func testConstruction() throws {
        
        // Example dates from Meeus, p. 62.
        
        XCTAssertEqual(JulianDay.zero.value, 0)
        
        let date0a = date(-4712, 1, 1, 12, 0, 0)
        XCTAssertEqual(JulianDay(date: date0a).value, 0)
        
        let date1 = date(2000, 1, 1, 12, 0, 0)
        XCTAssertEqual(JulianDay(date: date1).value, 2451545.0)
        
        let date2 = date(1987, 1, 27, 0, 0, 0)
        XCTAssertEqual(JulianDay(date: date2).value, 2446822.5)
        
        let date3 = date(1988, 6, 19, 12, 0, 0)
        XCTAssertEqual(JulianDay(date: date3).value, 2447332.0)
        
        let date4 = date(1600, 12, 31, 0, 0, 0)
        XCTAssertEqual(JulianDay(date: date4).value, 2305812.5)
        
        let date5 = date(-1000, 2, 29, 0, 0, 0)
        XCTAssertEqual(JulianDay(date: date5).value, 1355866.5)
    }
    
    func testDate() throws {
        
        // Example dates from Meeus, p. 62.
        
        let jd1 = JulianDay(2415020.5)
        XCTAssertEqual(jd1.date(), date(1900, 1, 1, 0, 0, 0))
        
        let jd2 = JulianDay(2026871.8)
        XCTAssertEqual(jd2.date(), date(837, 4, 10, 7, 12, 0))
    }
    
    func testTau2000() throws {
        
        // Example from Meeus, p. 207.
        
        let jd1 = JulianDay(2448976.5)
        XCTAssertEqual(jd1.tau2000.to(dp: 12), -0.007032169747)
    }
    
}

