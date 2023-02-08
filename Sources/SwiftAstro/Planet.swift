//
//  Planet.swift
//  
//
//  Created by Nick on 07/02/2023.
//

import Foundation

public enum Planet {
    case mercury
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    
    public func heliocentricPosition(t: JulianDay) -> SphericalPosition {
        let vsop = VSOP87Store.shared.vsop87(for: self)
        
        let lon = vsop.computeSum(t, index: .sphericalLongitude)
        let lat = vsop.computeSum(t, index: .sphericalLatitude)
        let rad = vsop.computeSum(t, index: .sphericalRadius)
        
        return SphericalPosition(
            unit: .radians,
            longitude: lon.unwindRadians(),
            latitude: lat.unwindRadians(),
            radius: rad)
    }
    
}

public extension Planet {
    
    var name: String {
        switch self {
        case .mercury: return "Mercury"
        case .venus: return "Venus"
        case .earth: return "Earth"
        case .mars: return "Mars"
        case .jupiter: return "Jupiter"
        case .saturn: return "Saturn"
        case .uranus: return "Uranus"
        case .neptune: return "Neptune"
        }
    }
    
}
