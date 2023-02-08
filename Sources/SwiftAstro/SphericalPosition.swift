//
//  SphericalPosition.swift
//  
//
//  Created by Nick on 08/02/2023.
//

import Foundation

public struct SphericalPosition {
    
    public enum Unit {
        case radians, degrees
    }
    
    let unit: Unit
    let longitude: Double
    let latitude: Double
    let radius: Double
    
    public func convertUnit(to unit: Unit) -> SphericalPosition {
        guard unit != self.unit else {
            return self
        }
        
        switch unit {
            
        case .degrees:
            return SphericalPosition(
                unit: .degrees,
                longitude: self.longitude.toDegrees(),
                latitude: self.latitude.toDegrees(),
                radius: self.radius)
            
        case .radians:
            return SphericalPosition(
                unit: .radians,
                longitude: self.longitude.toRadians(),
                latitude: self.latitude.toRadians(),
                radius: self.radius)
        }
    }
    
}
