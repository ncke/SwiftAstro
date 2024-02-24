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
        
        let date0a = date(-4712, 1, 1, 12, 0, 0)
        XCTAssertEqual(SwiftAstro.Time(date: date0a).julianDays, 0.0)
        
        let date1 = date(2000, 1, 1, 12, 0, 0)
        XCTAssertEqual(SwiftAstro.Time(date: date1).julianDays, 2451545.0)
        
        let date2 = date(1988, 6, 19, 12, 0, 0)
        XCTAssertEqual(SwiftAstro.Time(date: date2).julianDays, 2447332.0)
        
        let interval1 = date(1987, 1, 27, 0, 0, 0).timeIntervalSinceReferenceDate
        XCTAssertEqual(
            SwiftAstro.Time(timeIntervalSinceReferenceDate: interval1).julianDays,
            2446822.5
        )

        let interval2 = date(1600, 12, 31, 0, 0, 0).timeIntervalSinceReferenceDate
        XCTAssertEqual(
            SwiftAstro.Time(timeIntervalSinceReferenceDate: interval2).julianDays,
            2305812.5
        )

        let interval3 = date(-1000, 2, 29, 0, 0, 0).timeIntervalSinceReferenceDate
        XCTAssertEqual(
            SwiftAstro.Time(timeIntervalSinceReferenceDate: interval3).julianDays,
            1355866.5
        )
    }
    
    func testDate() throws {
        
        // Example dates from Meeus, p. 62.
        
        let jd1 = SwiftAstro.Time(julianDays: 2415020.5)
        XCTAssertEqual(jd1.date, date(1900, 1, 1, 0, 0, 0))
        
        let jd2 = SwiftAstro.Time(julianDays: 2026871.8)
        XCTAssertEqual(jd2.date, date(837, 4, 10, 7, 12, 0))
    }
    
    func testInterval() throws {
        
        XCTAssertEqual(SwiftAstro.Time(julianDays: 2451545.0).timeIntervalSinceReferenceDate, -31579200.0)
        
        XCTAssertEqual(SwiftAstro.Time(julianDays: 2447332.0).timeIntervalSinceReferenceDate, -395582400.0)
        
        XCTAssertEqual(SwiftAstro.Time(julianDays: 0.0).timeIntervalSinceReferenceDate, -211845067200.0)
    }
    
    func testEpoch() throws {

        XCTAssertEqual(
            SwiftAstro.Time.Epoch.J2000.time,
            SwiftAstro.Time(julianDays: 2451545.0)
        )

    }
    
    func testJulianMilleniaSinceEpoch() throws {

        // Example from Meeus, p. 207.

        let jd1 = SwiftAstro.Time(julianDays: 2448976.5)
        XCTAssertEqual(jd1.julianMilleniaSinceEpoch(.J2000).to(dp: 12), -0.007032169747)

    }

    func testUnderConstruction() throws {

        //let d = date(1987, 4, 10, 0, 0, 0)
        //let d = date(1992, 12, 20, 0, 0, 0)
        //let d = date(2024, 02, 10, 19, 0, 0)
        //let d = date(2000, 1, 1, 12, 0, 0)

        //let t = SwiftAstro.Time(date: d)
        //let t = SwiftAstro.Time(julianDays: 2446895.5)
        let t = SwiftAstro.Time(2024, 02, 10, 19, 0, 0)
        let (lon, lat) = SwiftAstro.Planet.venus.geocentricPosition(t: t)

        print(lon.rightAscension.description, lat.degreesMinutesSeconds)

        let distance = SwiftAstro.Distance(lightYears: 1.0)
        
        let au = distance.astronomicalUnits
        
        let pc = distance.parsecs
        
        if  let sirius = SwiftAstro.brightStarCatalog[2491],
            let ra = sirius.rightAscension?.rightAscension,
            let dec = sirius.declination?.degreesMinutesSeconds
        {
            print (ra)
            print (dec)
        }
        
        if let vega = SwiftAstro.brightStarCatalog[7001] {
            print(vega.name)
            print(vega.visualMagnitude)
        }

        let brightest = SwiftAstro.brightStarCatalog.stars.filter {
            star in
            
            guard let magnitude = star.visualMagnitude else {
                return false
            }
            
            return magnitude <= 1.0
        }
        
        
    }
    
}
