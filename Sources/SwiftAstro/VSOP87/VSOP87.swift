import Foundation

class VSOP87Store {
    
    static let shared = VSOP87Store()
    
    private var vsops = [SwiftAstro.Planet: VSOP87]()
    
    private let mutex = NSLock()
    
    func vsop87(for planet: SwiftAstro.Planet) -> VSOP87 {
        mutex.lock()
        defer { mutex.unlock() }
        
        if let cached = vsops[planet] {
            return cached
        }
        
        let loaded = loadVsop(for: planet)
        vsops[planet] = loaded
        
        return loaded
    }
    
    private func loadVsop(for planet: SwiftAstro.Planet) -> VSOP87 {
        switch planet {
        case .mercury: return VSOP87(resource: "VSOP87B", withExtension: "mer")
        case .venus: return VSOP87(resource: "VSOP87B", withExtension: "ven")
        case .earth: return VSOP87(resource: "VSOP87B", withExtension: "ear")
        case .mars: return VSOP87(resource: "VSOP87B", withExtension: "mar")
        case .jupiter: return VSOP87(resource: "VSOP87B", withExtension: "jup")
        case .saturn: return VSOP87(resource: "VSOP87B", withExtension: "sat")
        case .uranus: return VSOP87(resource: "VSOP87B", withExtension: "ura")
        case .neptune: return VSOP87(resource: "VSOP87B", withExtension: "nep")
        }
    }
    
}

struct VSOP87 {
    
    enum Index {
        case sphericalLongitude
        case sphericalLatitude
        case sphericalRadius
        
        var iv: Int {
            switch self {
            default: return 2
            }
        }
        
        var ic: Int {
            switch self {
            case .sphericalLongitude: return 1
            case .sphericalLatitude: return 2
            case .sphericalRadius: return 3
            }
        }
    }
    
    private struct Table {
        var header: Header
        var terms: [Term]
    }
    
    private struct Header {
        let iv: Int
        let bo: String
        let ic: Int
        let it: Int
        let `in`: String
    }
    
    private struct Term {
        let iv: Int
        let ib: Int
        let ic: Int
        let it: Int
        let n: Int
        let a: [Int]
        let S: Double
        let K: Double
        let A: Double
        let B: Double
        let C: Double
    }
    
    private let tables: [Table]
    
    init(resource: String, withExtension ext: String) {
        let lines = try! Utility.stringsForResource(resource, withExtension: ext)
        var tables = [Table]()
        var header: Header?
        var terms = [Term]()
        
        func tableComplete() {
            guard let currentHeader = header else { return }
            let table = Table(header: currentHeader, terms: terms)
            tables.append(table)
            header = nil
            terms = []
        }
        
        for (nth, line) in lines.enumerated() {
            let preamble: String = line.cols(2, 4)!
            
            if (preamble == "VSOP") {
                tableComplete()
                header = VSOP87.processHeader(line)
                continue
            }
            
            let term = VSOP87.processTerm(line)
            terms.append(term)
            
            let isLastLine = nth == lines.count - 1
            if isLastLine {
                tableComplete()
            }
        }
        
        self.tables = tables
    }
    
}

extension VSOP87 {
    
    private static func processHeader(_ line: String) -> Header {
        return Header(
            iv: line.cols(18, 1)!,
            bo: line.cols(23, 7)!,
            ic: line.cols(42, 1)!,
            it: line.cols(60, 1)!,
            in: line.cols(61, 7)!)
    }
    
    private static func processTerm(_ line: String) -> Term {
        var aArray: [Int] = []
        for aIndex in 0..<11 {
            let aColumn = 11 + (aIndex * 3)
            let aValue = line.cols(aColumn, 3)! as Int
            aArray.append(aValue)
        }
        
        return Term(
            iv: line.cols(2, 1)!,
            ib: line.cols(3,1)!,
            ic: line.cols(4, 1)!,
            it: line.cols(5, 1)!,
            n: line.cols(6, 5)!,
            a: aArray,
            S: line.cols(47, 15)!,
            K: line.cols(62, 18)!,
            A: line.cols(80, 18)!,
            B: line.cols(98, 14)!,
            C: line.cols(112, 20)!)
    }
    
}

extension VSOP87 {
    
    func computeSum(_ tau: Double, index: Index) -> Double {
        var sum = 0.0

        for table in tables(forIndex: index) {
            let Talpha = pow(tau, Double(table.header.it))
            var tableSum = 0.0

            for term in table.terms {
                let calc = Talpha * term.A * cos(term.B + term.C * tau)
                tableSum += calc
            }

            sum += tableSum
        }
        
        return sum
    }
    
    private func tables(forIndex index: Index) -> [Table] {
        tables.filter { table in
            table.header.iv == index.iv && table.header.ic == index.ic
        }
    }
    
}
