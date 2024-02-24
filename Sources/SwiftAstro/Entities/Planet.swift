import Foundation

// MARK: - Planet

extension SwiftAstro {
    
    public enum Planet: Equatable, Hashable, CaseIterable {
        case mercury
        case venus
        case earth
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
    }

}

// MARK: - Data

extension SwiftAstro.Planet: AstronomicallyNameable {
    
    public var name: String? {
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

// MARK: - Heliocentric Position

extension SwiftAstro.Planet: HeliocentricallyPositionable {

    public func heliocentricPosition(
        t: SwiftAstro.Time
    ) -> SwiftAstro.SphericalPosition {
        let vsop = VSOP87Store.shared.vsop87(for: self)
        
        let tau = t.julianMilleniaSinceEpoch(.J2000)
        let lon = vsop.computeSum(tau, index: .sphericalLongitude)
        let lat = vsop.computeSum(tau, index: .sphericalLatitude)
        let rad = vsop.computeSum(tau, index: .sphericalRadius)
        
        return SwiftAstro.SphericalPosition(
            longitude: SwiftAstro.Angle(radians: lon).unwound,
            latitude: SwiftAstro.Angle(radians: lat).unwound,
            radius: SwiftAstro.Distance(astronomicalUnits: rad))
    }
    
}

// MARK: - Geocentric Position

extension SwiftAstro.Planet: GeocentricallyPositionable {}
