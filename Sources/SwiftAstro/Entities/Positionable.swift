import Foundation

// MARK: - Heliocentrically Positionable

extension SwiftAstro {

    public protocol HeliocentricallyPositionable {

        func heliocentricPosition(
            t: SwiftAstro.Time
        ) -> SwiftAstro.SphericalPosition

    }

}

// MARK: - Geocentrically Positionable

extension SwiftAstro {
    
    public protocol GeocentricallyPositionable {
        
        func geocentricPosition(
            t: SwiftAstro.Time
        ) -> (SwiftAstro.Angle, SwiftAstro.Angle)
        
    }
    
}
