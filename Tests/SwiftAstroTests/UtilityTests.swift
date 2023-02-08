//
//  UtilityTests.swift
//  
//
//  Created by Nick on 08/02/2023.
//

import XCTest
@testable import SwiftAstro

final class UtilityTests: XCTestCase {
    
    func testDp() {
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
    
    func testUnwindRadians() {

        let unwound1 = (-68.6592582).unwindRadians()
        XCTAssertEqual(unwound1.to(dp: 10), 0.455780179)
        
        let unwound2 = 0.0.unwindRadians()
        XCTAssertEqual(unwound2.to(dp: 10), 0.0)
        
        let unwound3 = (0.5 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound3.to(dp: 10), (0.5 * Double.pi).to(dp: 10))
        
        let unwound4 = Double.pi.unwindRadians()
        XCTAssertEqual(unwound4.to(dp: 10), Double.pi.to(dp: 10).to(dp: 10))
        
        let unwound5 = (1.5 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound5.to(dp: 10), (1.5 * Double.pi).to(dp: 10))
        
        let unwound6 = (2.0 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound6.to(dp: 10), 0.0)
        
        let unwound7 = (0.25 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound7.to(dp: 10), (0.25 * Double.pi).to(dp: 10))
        
        let unwound8 = (2.5 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound8.to(dp: 10), (0.5 * Double.pi).to(dp: 10))
        
        let unwound9 = (-0.5 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound9.to(dp: 10), (1.5 * Double.pi).to(dp: 10))
        
        let unwound10 = (-10.25 * Double.pi).unwindRadians()
        XCTAssertEqual(unwound10.to(dp: 10), (1.75 * Double.pi).to(dp: 10))
    }
    
    func testUnwindDegrees() {
        
        let unwound1 = 45.0.unwindDegrees()
        XCTAssertEqual(unwound1.to(dp: 10), 45.0)
        
        let unwound2 = 360.0.unwindDegrees()
        XCTAssertEqual(unwound2.to(dp: 10), 0.0)
        
        let unwound3 = 720.0.unwindDegrees()
        XCTAssertEqual(unwound3.to(dp: 10), 0.0)
        
        let unwound4 = 395.0.unwindDegrees()
        XCTAssertEqual(unwound4.to(dp: 10), 35.0)
        
        let unwound5 = (-395.0).unwindDegrees()
        XCTAssertEqual(unwound5.to(dp: 10), 325.0)
        
    }
    
}
