import XCTest
@testable import SwiftAstro

final class PlutoTests: XCTestCase {

    func testHeliocentricPosition() throws {
        // From an example in Meeus, 1991, p. 250.
        let t = SwiftAstro.Time(1992, 10, 13, 0, 0, 0)
        let hp = SwiftAstro.pluto.heliocentricPosition(t: t)

        XCTAssertEqual(hp.longitude.degrees, -127.25990696998649, accuracy: 1E-12)
        XCTAssertEqual(hp.latitude.degrees, 14.587687257384879, accuracy: 1E-12)
        XCTAssertEqual(hp.radius.astronomicalUnits, 29.71138254224995, accuracy: 1E-12)
    }

    func testGeocentricPosition() throws {
        let t = SwiftAstro.Time(1992, 10, 13, 0, 0, 0)
        let (ra, decl) = SwiftAstro.pluto.geocentricPosition(t: t)

        // SwiftAstro gives     15h 31m 43.497s, -4º27'28.189"
        // JPL Horizon gives    15h 31m 43.76,   -4º27'28.9"
        // Meeus, p. 251, gives 15h 31m 43.6,    -4º27'29"
        XCTAssertEqual(ra.degrees, -127.06876421517995, accuracy: 1E-12)
        XCTAssertEqual(decl.degrees, -4.457830413871118, accuracy: 1E-12)
    }

}
