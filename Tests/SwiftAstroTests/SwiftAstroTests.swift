import XCTest
@testable import SwiftAstro

final class SwiftAstroTests: XCTestCase {
    
    func testHeliocentricPosition() {
        
        // Examples provided by VSOP87.
        
        // VSOP87B Venus at 1899-12-31T12:00:00Z.
        let date1 = SwiftAstro.Time(julianDays: 2415020.0)
        let posn1 = SwiftAstro.Planet.venus.heliocentricPosition(t: date1)
        XCTAssertEqual(posn1.longitude.radians.to(dp: 10), -0.2838334947)
        XCTAssertEqual(posn1.latitude.radians.to(dp: 10), -0.0591709804)
        XCTAssertEqual(posn1.radius.astronomicalUnits.to(dp: 10), 0.7274719352)
        
        // VSOP87B Neptune at 2000-01-01T12:00:00Z.
        let date2 = SwiftAstro.Time(julianDays: 2451545.0)
        let posn2 = SwiftAstro.Planet.neptune.heliocentricPosition(t: date2)
        XCTAssertEqual(posn2.longitude.radians.to(dp: 10), -0.9786223788)
        XCTAssertEqual(posn2.latitude.radians.to(dp: 10), 0.0042236790)
        XCTAssertEqual(posn2.radius.astronomicalUnits.to(dp: 10), 30.1205329332)
        
        // VSOP87B Saturn at 1099-12-19T12:00:00Z.
        let date3 = SwiftAstro.Time(julianDays: 2122820.0)
        let posn3 = SwiftAstro.Planet.saturn.heliocentricPosition(t: date3)
        XCTAssertEqual(posn3.longitude.radians.to(dp: 10), -2.5071058882)
        XCTAssertEqual(posn3.latitude.radians.to(dp: 10), 0.0422300831)
        XCTAssertEqual(posn3.radius.astronomicalUnits.to(dp: 10), 9.8669939127)
        
    }
    
}
