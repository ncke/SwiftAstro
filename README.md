# SwiftAstro

A Swift package for astronomy.

## About SwiftAstro.
SwiftAstro is a Swift package that provides:
* A swifty interface for the Yale Bright Star Catalog of 9,110 stars that are considered visible to the naked eye.
* Computation of the motion of the planets using the VSOP87 theory.
* Data structures to represent quantities of distance, time, and angles for astronomical calculations.

## Yale Bright Star Catalog.
The `SwiftAstro.brightStarCatalog` property provides access to a `BrightStarCatalog` instance.

The `stars` property provides access to all stars in the catalog. The catalog can also be subscripted with the Harvard Revised Star Number (HR).

**Example:** Find the visual magnitude of Vega, HR number 7001.

```Swift
if let vega = SwiftAstro.brightStarCatalog[7001] {
  print(vega.visualMagnitude).        // 0.03
}
```

**Example:** Find all stars with a visual magnitude of 1.0 or lower.

```Swift
let brightest = SwiftAstro.brightStarCatalog.stars.filter {
  star in

  guard let magnitude = star.visualMagnitude else {
    return false
  }
            
  return magnitude <= 1.0
}
```

## Astronomical calculations.

### Heliocentric position of the planets.
The planets are enumerated by the `Planet` enum. The `heliocentricPosition` func returns the heliocentric position of a planet for a given Julian day. The VSOP87B tables are used, so the result is given in spherical coordinates.

**Example:** Calculate the position of Mars on Julian Day 2460156.0 (noon on 30th July 2023).

```Swift
let t = SwiftAstro.Time(julianDays: 2460156.0)
let posn = SwiftAstro.Planet.mars.heliocentricPosition(t: t)
```

Gives longitude -3.0927667317253196 radians, latitude 0.023473327404147742 radians, and radius 1.6478994217781984 astronomical units (the distance between Mars and the Sun).

## Data structures.

### Distance.
The `SwiftAstro.Distance` data structure represents an astronomical distance. The underlying unit of measurement is the astronomical unit. Initialisers and accessors are also available for light years, light minutes, light seconds, meters, and parsecs.

**Example:** For a distance of 1 light year, find the corresponding distance in astronomical units and parsecs.

```Swift
let distance = SwiftAstro.Distance(lightYears: 1.0)
let au = distance.astronomicalUnits    // 63241.07708426628
let pc = distance.parsecs              // 0.30660139378555057
```

### Angle.
The `SwiftAstro.Angle` data structure represents an angular measurement. The underlying unit is the radian. Accessors and initialisers are also available for degrees and arc seconds. Additionally, the `SwiftAstro.Angle.RightAscension` property provides a view of an angle as a right ascension. Similarly, the `SwiftAstro.Angle.DegreesMinutesSeconds` property provides a view of an angle in DMS form. Angles may also be initialised using right ascension and DMS values.

**Example:** Find the right ascension and declination of Sirius, star number 2491 in the Yale Bright Star Catalog.

```Swift
if  let sirius = SwiftAstro.brightStarCatalog[2491],
  let ra = sirius.rightAscension?.rightAscension,
  let dec = sirius.declination?.degreesMinutesSeconds
{
  print (ra)               // 06h 45m 08.900s
  print (dec)              // -016° 42' 58.000"
}
```

### Time.
The 'SwiftAstro.Time` data structure represents a moment in time. The underlying unit is the Julian Day, which measures the number of continuous days since noon on 1st January -4713.

Accessors and initialisers are also available for the corresponding Foundation `Date` and for the `timeIntervalSinceReferenceDate`.

### Spherical position.
The `SphericalPosition` struct represents the relative spherical coordinates of an object in terms of longitude, latitude, and radius (distance to the origin).

## Sources.

Bretagnon, P. and Francou, G. (1988) 'Planetary Solutions VSOP87', Astronomy and Astrophysics, vol. 202(309B).

Meeus, J. (1991) 'Astronomical Algorithms', Willmann-Bell: Viriginia, USA.

Hoffleit, D. and Warren Jr, W. H. (1991) 'Yale Bright Star Catalog: 5th Revised Edition', Available at <http://cdsarc.u-strasbg.fr/viz-bin/cat/V/50>
