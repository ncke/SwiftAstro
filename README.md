# SwiftAstro

A Swift package for astronomy.

## Data structures.

### Julian day.

The `JulianDay` struct represents a date in the Julian calendar: the count of continuous days since midday in the year -4712.

*Example:* given that midday on New Years Day in the year 2000 is Julian Day 2451545.0, instantiate the corresponding `JulianDate`.

`let jd = JulianDay(2451545.0)`

Other initialisers allow a `JulianDay` to be initialised using a 'time interval since reference date' or a plain Swift `Date`.

### Spherical position.

The `SphericalPosition` struct represents the relative spherical coordinates of an object in terms of longitude, latitude, and radius (distance to the origin).

The `unit` property enumerates to either `.radians` or `.degrees`, and the `convertUnit(to unit: Unit)` instance method can be used for conversion.

## Astronomical calculations.

### Heliocentric position of the planets.

The planets are enumerated by the `Planet` enum. The `heliocentricPosition` func returns the heliocentric position of a planet for a given Julian day. The VSOP87B tables are used, so the result is given in spherical coordinates.

*Example:* calculate the position of Mars given `jd` (a `JulianDay`) as declared above.

`let posn = Planet.mars.heliocentricPosition(t: jd)`

Gives longitude 6.273538987210828 rads, latitude 6.2584073248151375 rads, and radius 1.3912076937159727 au (the distance to the Sun).

## Sources.

Bretagnon, P. and Francou, G. (1988) 'Planetary Solutions VSOP87', Astronomy and Astrophysics, vol. 202(309B).

Meeus, J. (1991) 'Astronomical Algorithms', Willmann-Bell: Viriginia, USA.
