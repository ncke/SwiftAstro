import XCTest
@testable import SwiftAstro

final class SwiftAstroTests: XCTestCase {
    
    func testHeliocentricPosition() {

        // Examples provided by VSOP87.
        
        // VSOP87B Venus at 1899-12-31T12:00:00Z.
        let date1 = JulianDay(2415020.0)
        let posn1 = Planet.venus.heliocentricPosition(t: date1)
        XCTAssertEqual(posn1.longitude.to(dp: 10), 5.9993518124)
        XCTAssertEqual(posn1.latitude.to(dp: 10), (2.0 * Double.pi).to(dp: 10) - 0.0591709804)
        XCTAssertEqual(posn1.radius.to(dp: 10), 0.7274719352)
        
        // VSOP87B Neptune at 2000-01-01T12:00:00Z.
        let date2 = JulianDay(2451545.0)
        let posn2 = Planet.neptune.heliocentricPosition(t: date2)
        XCTAssertEqual(posn2.longitude.to(dp: 10), 5.3045629284)
        XCTAssertEqual(posn2.latitude.to(dp: 10), 0.0042236790)
        XCTAssertEqual(posn2.radius.to(dp: 10), 30.1205329332)
        
        // VSOP87B Saturn at 1099-12-19T12:00:00Z.
        let date3 = JulianDay(2122820.0)
        let posn3 = Planet.saturn.heliocentricPosition(t: date3)
        XCTAssertEqual(posn3.longitude.to(dp: 10), 3.7760794190)
        XCTAssertEqual(posn3.latitude.to(dp: 10), 0.0422300831)
        XCTAssertEqual(posn3.radius.to(dp: 10), 9.8669939127)
        
    }
    
}
