import XCTest
@testable import SwiftAstro

final class BrightStarCatalogTests: XCTestCase {

    func test919() throws {
        let bsc = SwiftAstro.brightStarCatalog
        let hr919 = try XCTUnwrap(bsc[919])

        XCTAssertEqual(hr919.flamsteedNumber, 11)
        XCTAssertEqual(hr919.bayerGreek?.simbad, .tau)
        XCTAssertEqual(hr919.bayerGreek?.number, 3)
        XCTAssertEqual(hr919.constellation, "Eri")
    }

    func test972() throws {
        let bsc = SwiftAstro.brightStarCatalog
        let hr947 = try XCTUnwrap(bsc[972])

        XCTAssertEqual(hr947.name, "ζ Ari")
        XCTAssertEqual(hr947.constellation, "Ari")
    }

}
