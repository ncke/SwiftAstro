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
    
}

// MARK: - Utility

struct Utility {}

// MARK: - Number Formatters

extension Utility {
    
    static let fractionNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 2
        nf.maximumIntegerDigits = 2
        nf.minimumFractionDigits = 3
        nf.maximumFractionDigits = 3
        
        return nf
    }()
    
    static let twoNumberFormatter: NumberFormatter = {
       let nf = NumberFormatter()
        nf.minimumIntegerDigits = 2
        nf.maximumFractionDigits = 0
        
        return nf
    }()
    
    static let threeNumberFormatter: NumberFormatter = {
       let nf = NumberFormatter()
        nf.minimumIntegerDigits = 3
        nf.maximumFractionDigits = 0
        
        return nf
    }()
    
    static let decimalNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        
        return nf
    }()
    
}


