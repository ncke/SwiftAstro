import XCTest
import SwiftAstro

final class PublicAPITests: XCTestCase {

    func testGeocentricPosition() throws {
        let planet = SwiftAstro.Planet.venus
        let t = SwiftAstro.Time(2024, 2, 10, 19, 0, 0)
        let (ra, decl) = planet.geocentricPosition(t: t)

        XCTAssertEqual(ra.radians, -1.1491852095241037, accuracy: 1E-12)
        XCTAssertEqual(decl.radians, -0.3739027887933675, accuracy: 1E-12)
    }

}
