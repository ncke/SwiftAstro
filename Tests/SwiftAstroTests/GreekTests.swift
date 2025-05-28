import XCTest
@testable import SwiftAstro

final class GreekTests: XCTestCase {

    func testSimbad() throws {
        let g = SwiftAstro.Greek(simbad: .ome)
        XCTAssertEqual(g.simbad, .ome)
        XCTAssertEqual(g.letter, "ω")
    }

    func testSimbadCoding() throws {
        let g = try XCTUnwrap(SwiftAstro.Greek(simbadCoding: "tet"))
        XCTAssertEqual(g.simbad, .tet)
        XCTAssertEqual(g.letter, "θ")

        let noSuch = SwiftAstro.Greek(simbadCoding: "nonsense")
        XCTAssertNil(noSuch)
    }

    func testHRCoding() throws {
        let g = try XCTUnwrap(SwiftAstro.Greek(hrCoding: "the"))
        XCTAssertEqual(g.simbad, .tet)
        XCTAssertEqual(g.letter, "θ")

        let noSuch = SwiftAstro.Greek(hrCoding: "nonsense")
        XCTAssertNil(noSuch)
    }

    func testGreekLetter() throws {
        let g = try XCTUnwrap(SwiftAstro.Greek(greekLetter: "ξ"))
        XCTAssertEqual(g.simbad, .ksi)
        XCTAssertEqual(g.letter, "ξ")

        let noSuch = SwiftAstro.Greek(simbadCoding: "a")
        XCTAssertNil(noSuch)
    }

    func testSimbadWithNumber() throws {
        let g = try XCTUnwrap(SwiftAstro.Greek(simbadCoding: "alf02"))
        XCTAssertEqual(g.simbad, .alf)
        XCTAssertEqual(g.letter, "α")
        XCTAssertEqual(g.number, 2)

        let noSuch = SwiftAstro.Greek(simbadCoding: "alf02yyy")
        XCTAssertNil(noSuch)
    }

    func testGreekLetterWithNumber() throws {
        let g = try XCTUnwrap(SwiftAstro.Greek(greekLetter: "σ5"))
        XCTAssertEqual(g.simbad, .sig)
        XCTAssertEqual(g.letter, "σ")
        XCTAssertEqual(g.number, 5)
    }

    func testHRCodingWithNumber() throws {
        let g = try XCTUnwrap(SwiftAstro.Greek(hrCoding: "Eta1"))
        XCTAssertEqual(g.simbad, .eta)
        XCTAssertEqual(g.letter, "η")
        XCTAssertEqual(g.number, 1)
    }

}
