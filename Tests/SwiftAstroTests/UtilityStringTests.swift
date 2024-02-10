import XCTest
@testable import SwiftAstro

final class UtilityStringTests: XCTestCase {

    // `cols` is 1-based   12345678901234567
    private let colsSut = "ABCD   123987.45X"

    func testContainsCharacter() throws {
        let sut = "abcdefg"
        XCTAssertTrue(sut.containsCharacter("a"))
        XCTAssertTrue(sut.containsCharacter("e"))
        XCTAssertTrue(sut.containsCharacter("g"))
        XCTAssertFalse(sut.containsCharacter("A"))
        XCTAssertFalse(sut.containsCharacter("z"))
    }

    func testColumns() throws {
        XCTAssertEqual(colsSut.cols(1), "ABCD   123987.45X")
        XCTAssertEqual(colsSut.cols(8), "123987.45X")
        XCTAssertEqual(colsSut.cols(1, 4), "ABCD")
        XCTAssertEqual(colsSut.cols(1, 7), "ABCD")
        XCTAssertEqual(colsSut.cols(8, 3), 123)
        XCTAssertEqual(colsSut.cols(8, 6), 123987)
        XCTAssertEqual(colsSut.cols(8, 9), 123987.45)

        XCTAssertNil(colsSut.cols(-5) as String?)
        XCTAssertNil(colsSut.cols(-5, 3) as String?)
        XCTAssertNil(colsSut.cols(10, 10) as String?)
        XCTAssertNil(colsSut.cols(25, 3) as String?)
        XCTAssertNil(colsSut.cols(8, 10) as Double?)
        XCTAssertNil(colsSut.cols(1, 8) as Int?)
    }

}
