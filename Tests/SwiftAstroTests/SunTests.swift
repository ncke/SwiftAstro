import XCTest
@testable import SwiftAstro

final class SunTests: XCTestCase {

    func testGeocentricPosition() throws {
        // From an example is Meeus, 1991, p. 157.
        let t = SwiftAstro.Time(1992, 10, 13, 0, 0, 0)
        let (ra, decl) = SwiftAstro.sun.geocentricPosition(t: t)

        // SwiftAstro gives 13h 13m 53.345s -7º49'20.152"
        // Meeus gives 13h 13m 30.763s -7º47'01.94" (abridged VSOP87)
        // JPL Horizon gives 13h 13m 53.80s -7º49'21.8"
        XCTAssertEqual(ra.degrees, -161.52772727655758, accuracy: 1E-12)
        XCTAssertEqual(decl.degrees, -7.822264529738101, accuracy: 1E-12)
    }

    func testReadmeExample() throws {
        let t = SwiftAstro.Time(2024, 7, 1, 15, 0, 0)

        let (raSun, declSun) = SwiftAstro.sun.geocentricPosition(t: t)
        print(raSun.rightAscension)
        print(declSun.degreesMinutesSeconds)

        let (raMoon, declMoon) = SwiftAstro.moon.geocentricPosition(t: t)
        print(raMoon.rightAscension)
        print(declMoon.degreesMinutesSeconds)
        print()
    }

}
