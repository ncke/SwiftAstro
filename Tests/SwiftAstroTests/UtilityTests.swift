import XCTest
@testable import SwiftAstro

final class UtilityTests: XCTestCase {
    
    func testToDp() throws {
        XCTAssertEqual(-19.8.to(dp: 0),         -20.0)
        XCTAssertEqual(-19.5.to(dp: 0),         -20.0)
        XCTAssertEqual(-19.1.to(dp: 0),         -19.0)
        XCTAssertEqual(10.2.to(dp: 0),           10.0)
        XCTAssertEqual(-8.925.to(dp: 2),        -8.93)
        XCTAssertEqual(-8.924999.to(dp: 2),     -8.92)
        XCTAssertEqual(10.0.to(dp: 2),           10.0)
        XCTAssertEqual(10.255.to(dp: 2),        10.26)
        XCTAssertEqual(10.256.to(dp: 2),        10.26)
        XCTAssertEqual(2.583925.to(dp: 0),        3.0)
        XCTAssertEqual(2.583925.to(dp: 1),        2.6)
        XCTAssertEqual(2.583925.to(dp: 2),       2.58)
        XCTAssertEqual(2.583925.to(dp: 3),      2.584)
        XCTAssertEqual(2.583925.to(dp: 4),     2.5839)
        XCTAssertEqual(2.583925.to(dp: 5),    2.58392)
        XCTAssertEqual(2.583925.to(dp: 6),   2.583925)
        XCTAssertEqual(2.583925.to(dp: 7),   2.583925)
    }
    
}
