import Foundation

// MARK: - Star

extension SwiftAstro {

    public enum Catalog {
        case yaleBrightStarCatalog
    }

    public protocol Star: HeliocentricallyPositionable {

        var catalog: Catalog { get }

        var catalogIdentifier: String { get }

    }

}
