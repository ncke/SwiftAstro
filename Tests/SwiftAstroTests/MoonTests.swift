import XCTest
import SwiftAstro

final class MoonTests: XCTestCase {

    func testGeocentricPosition() throws {
        // Example from Meeus, 1991, p. 313.
        let t = SwiftAstro.Time(1992, 4, 12, 0, 0, 0)
        let mp = SwiftAstro.moon.geocentricPosition(t: t)
        
        // SwiftAstro gives  08h 58m 45.234s 13º46'06.113"
        // Meeus gives       08h 58m 45.1s   13º46'06"
        // JPL Horizon gives 08h 59m 11.28s  13º44'12.4"
        XCTAssertEqual(mp.0.degrees, 134.68847356749924, accuracy: 1E-12)
        XCTAssertEqual(mp.1.degrees, 13.768364773287606, accuracy: 1E-12)
    }

}
