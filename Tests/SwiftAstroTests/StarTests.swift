import XCTest
@testable import SwiftAstro

final class StarTests: XCTestCase {

    func testHeliocentricPosition() throws {
        guard let thetaPersei = SwiftAstro.brightStarCatalog[799] else {
            XCTFail()
            return
        }

        print(thetaPersei.name)

        print(thetaPersei.rightAscension.rightAscension)
        print(thetaPersei.declination.degreesMinutesSeconds)
        print(thetaPersei.raAnnualMotion.rightAscension)
        print(thetaPersei.decAnnualMotion.degreesMinutesSeconds)

        let t = SwiftAstro.Time(julianDays: 2462088.69)
        let hp = thetaPersei.heliocentricPosition(t: t)
        print("hp:")
        print(hp.longitude.rightAscension)
        print(hp.latitude.degreesMinutesSeconds)


        print("")

    }

}
