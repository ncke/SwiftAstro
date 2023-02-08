//
//  Utility.swift
//  
//
//  Created by Nick on 07/02/2023.
//

import Foundation

extension Double {
    
    func to(dp: Int) -> Double {
        let power = pow(10, Double(dp))
        let value = (self * power).rounded(.toNearestOrAwayFromZero) / power
        
        return value
    }
    
    private static let twopi = 2.0 * Double.pi
    
    func unwindRadians() -> Double {
        var unwound = self.truncatingRemainder(dividingBy: Double.twopi)
        if unwound < 0.0 {
            unwound += Double.twopi
        }
        
        return unwound
    }
    
    func unwindDegrees() -> Double {
        var unwound = self.truncatingRemainder(dividingBy: 360.0)
        if unwound < 0.0 {
            unwound += 360.0
        }
        
        return unwound
    }
    
    func toDegrees() -> Double {
        return (360.0 * self) / Double.twopi
    }
    
    func toRadians() -> Double {
        return (self * Double.twopi) / 360.0
    }
    
}
