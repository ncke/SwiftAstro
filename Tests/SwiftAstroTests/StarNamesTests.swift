import XCTest
@testable import SwiftAstro

final class StarNamesCatalogTests: XCTestCase {

    func testStarNamesPolarius() throws {
        let snc = SwiftAstro.StarNamesCatalog()
        let polaris = try XCTUnwrap(snc.findByName("polaris"))

        XCTAssertEqual(polaris.name, "Polaris")
        XCTAssertEqual(polaris.bayerGreek, "α")
        XCTAssertEqual(polaris.constellation, "UMi")
        XCTAssertEqual(polaris.magnitude, 2.13, accuracy: 1E-8)
        XCTAssertEqual(polaris.band, .bandV)
        XCTAssertEqual(polaris.rightAscension, 37.954561, accuracy: 1E-8)
        XCTAssertEqual(polaris.declination, 89.264109, accuracy: 1E-8)
        XCTAssertEqual(polaris.dateApproved, "2016-06-30")
        XCTAssertEqual(polaris.hrNumber, 424)
        XCTAssertEqual(polaris.hdNumber, 8890)
        XCTAssertEqual(polaris.simbadGreek, "alf")
        let wds = polaris.wdsNumber
        XCTAssertEqual(wds?.wds, "02318+8916")
        XCTAssertEqual(wds?.component, "Aa")
    }

    func testStarNamesAltair() throws {
        let snc = SwiftAstro.StarNamesCatalog()
        let altair = try XCTUnwrap(snc.findByHRNumber(7557))

        XCTAssertEqual(altair.name, "Altair")
    }

    func testStarNamesVega() throws {
        let snc = SwiftAstro.StarNamesCatalog()
        let vega = try XCTUnwrap(snc.findByHDNumber(172167))

        XCTAssertEqual(vega.name, "Vega")
    }

    func testStarNamesMalmok() throws {
        let snc = SwiftAstro.StarNamesCatalog()
        let malmok = try XCTUnwrap(snc.findByName("Malmok"))

        XCTAssertEqual(malmok.name, "Malmok")
        XCTAssertNil(malmok.hrNumber)
        XCTAssertNil(malmok.hdNumber)
        XCTAssertEqual(malmok.otherDesignation, "WASP-39")
        XCTAssertEqual(malmok.variableNumber, 732)
        XCTAssertEqual(malmok.band, .bandG)
        let wds = malmok.wdsNumber
        XCTAssertEqual(wds?.wds, "14293-0327")
        XCTAssertNil(wds?.component)
    }

    func testStarNamesMerope() throws {
        let snc = SwiftAstro.StarNamesCatalog()
        let merope = try XCTUnwrap(snc.findByName("Merope"))

        XCTAssertEqual(merope.name, "Merope")
        XCTAssertNil(merope.bayerGreek)
        XCTAssertEqual(merope.flamsteedNumber, 23)
    }

    func testStarNamesPhoenicia() throws {
        let snc = SwiftAstro.StarNamesCatalog()
        let phoenicia = try XCTUnwrap(snc.findByName("Phoenicia"))

        XCTAssertEqual(phoenicia.name, "Phoenicia")
        XCTAssertNil(phoenicia.bayerGreek)
        XCTAssertEqual(phoenicia.variableNumber, 1703)
    }

}
