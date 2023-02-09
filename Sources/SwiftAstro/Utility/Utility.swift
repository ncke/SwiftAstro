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

// MARK: - Resource Loading

extension Utility {
    
    static func stringsForResource(
        _ resource: String,
        withExtension ext: String
    ) throws -> [String] {
        let resourceUrl = Bundle.module.url(
            forResource: resource,
            withExtension: ext)!
        
        let data = try Data(contentsOf: resourceUrl)
        let dataString = String(data: data, encoding: .utf8)!
        
        let lines = dataString.components(separatedBy: .newlines).filter {
            line in !line.isEmpty
        }
        
        return lines
    }
    
}

// MARK: - String Comprehension

extension String {
    
    func containsCharacter(_ character: Character) -> Bool {
        for char in self {
            if char == character {
                return true
            }
        }
        
        return false
    }
    
    private func excerpt(_ n: Int, _ len: Int) -> Substring? {
        guard
            let start = self.index(self.startIndex, offsetBy: n, limitedBy: self.endIndex),
            let finish = self.index(self.startIndex, offsetBy: n + len, limitedBy: self.endIndex)
        else {
            return nil
        }
        
        let excerpt = self[start..<finish]
        return excerpt
    }
    
    private func excerpt(_ n: Int) -> Substring? {
        guard let start = self.index(
            self.startIndex,
            offsetBy: n,
            limitedBy: self.endIndex)
        else {
            return nil
        }
        
        let finish = self.endIndex
        let excerpt = self[start..<finish]
        return excerpt
    }
    
    func cols(_ n: Int) -> String? {
        guard let substr = excerpt(n-1) else { return nil }
        
        let str = substr.trimmingCharacters(in: .whitespaces)
        
        guard !str.isEmpty else { return nil }
        
        return str
    }
    
    func cols(_ n: Int, _ len: Int) -> String? {
        guard let substr = excerpt(n-1, len) else { return nil }
        
        let str = substr.trimmingCharacters(in: .whitespaces)
        
        guard !str.isEmpty else { return nil }
        
        return str
    }
    
    func cols(_ n: Int, _ len: Int) -> Int? {
        guard let substr = excerpt(n-1, len) else { return nil }
        
        let str = substr.trimmingCharacters(in: .whitespaces)
        
        guard !str.isEmpty else { return nil }

        return Int(str)
    }
    
    func cols(_ n: Int, _ len: Int) -> Double? {
        guard let substr = excerpt(n-1, len) else { return nil }
        
        let str = substr.trimmingCharacters(in: .whitespaces)

        guard !str.isEmpty else { return nil }
        
        return Double(str)
    }
    
}
