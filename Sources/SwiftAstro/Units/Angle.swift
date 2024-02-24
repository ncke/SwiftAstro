import Foundation

// MARK: - Angle

extension SwiftAstro {
    
    public struct Angle:
        CustomStringConvertible,
        Equatable,
        Comparable,
        Hashable
    {
        public let radians: Double
        
        public var description: String {
            "\(radians) rads"
        }
    }
    
}

// MARK: - Degrees

extension SwiftAstro.Angle {
        
    static let twopi = 2.0 * Double.pi

    public var degrees: Double {
        (radians * 360.0) / Self.twopi
    }
    
    public init(degrees: Double) {
        radians = (degrees * Self.twopi) / 360.0
    }

    public var arcSeconds: Double {
        degrees * 3600.0
    }

    public init(arcSeconds: Double) {
        self.init(degrees: arcSeconds / 3600.0)
    }
    
}

// MARK: - Unwinding

extension SwiftAstro.Angle {
    
    public var unwound: Self {
        var rads = radians.truncatingRemainder(dividingBy: Self.twopi)
        
        if rads > Double.pi {
            rads -= Self.twopi
        } else if rads < -Double.pi {
            rads += Self.twopi
        }
        
        return SwiftAstro.Angle(radians: rads)
    }
    
}

// MARK: - Right Ascension

extension SwiftAstro.Angle {
    
    public struct RightAscension: CustomStringConvertible {
        public let hours: Int
        public let minutes: Int
        public let seconds: Double
        
        public init(_ hours: Int, _ minutes: Int, _ seconds: Double) {
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
        }
        
        public var description: String {
            let h = Utility.twoNumberFormatter.string(
                from: hours as NSNumber)!
            let m = Utility.twoNumberFormatter.string(
                from: minutes as NSNumber)!
            let s = Utility.fractionNumberFormatter.string(
                from: seconds as NSNumber)!
            
            return "\(h)h \(m)m \(s)s"
        }
        
        var asRadians: Double {
            let sign = hours < 0 ? -1.0 : 1.0
            var clock = Double(hours)
                + sign * Double(minutes) / 60.0
                + sign * seconds / 3600.0
            
            if clock > 12.0 { clock -= 24.0 }
            
            return (clock * twopi) / 24.0
        }
        
        init(radians: Double) {
            var clock = (radians * 24.0) / twopi
            if radians < 0 {
                clock += 24.0
            }
            
            let hours = Int(clock)
            clock = abs(clock.truncatingRemainder(dividingBy: 1.0) * 60.0)
            let minutes = Int(clock)
            clock = clock.truncatingRemainder(dividingBy: 1.0)
            let seconds = clock * 60.0
            
            self.init(hours, minutes, seconds)
        }
        
    }
    
    public var rightAscension: RightAscension {
        let unwound = self.unwound
        return RightAscension(radians: unwound.radians)
    }
    
    public init(rightAscension: RightAscension) {
        radians = rightAscension.asRadians
    }
    
    public init(hours: Int, minutes: Int, seconds: Double) {
        let ra = RightAscension(hours, minutes, seconds)
        self.init(rightAscension: ra)
    }
    
}

// MARK: - Degrees Minutes Seconds

extension SwiftAstro.Angle {
    
    public struct DegreesMinutesSeconds: CustomStringConvertible {
        public let degrees: Int
        public let minutes: Int
        public let seconds: Double
        
        public init(_ degrees: Int, _ minutes: Int, _ seconds: Double) {
            self.degrees = degrees
            self.minutes = minutes
            self.seconds = seconds
        }
        
        public var description: String {
            let d = Utility.threeNumberFormatter.string(
                from: degrees as NSNumber)!
            let m = Utility.twoNumberFormatter.string(
                from: minutes as NSNumber)!
            let s = Utility.fractionNumberFormatter.string(
                from: seconds as NSNumber)!
            
            return "\(d)° \(m)' \(s)\""
        }
        
        var asRadians: Double {
            let sign = degrees < 0 ? -1.0 : 1.0
            let circle = Double(degrees)
                + sign * Double(minutes) / 60.0
                + sign * seconds / 3600.0
            
            return (circle * twopi) / 360.0
        }
        
        init(radians: Double) {
            var circle = (radians * 360.0) / twopi
            let hours = Int(circle)
            circle = abs(circle.truncatingRemainder(dividingBy: 1.0) * 60.0)
            let minutes = Int(circle)
            circle = circle.truncatingRemainder(dividingBy: 1.0)
            let seconds = circle * 60.0
            
            self.init(hours, minutes, seconds)
        }
        
    }
    
    public var degreesMinutesSeconds: DegreesMinutesSeconds {
        let unwound = self.unwound
        return DegreesMinutesSeconds(radians: unwound.radians)
    }
    
    public init(dms: DegreesMinutesSeconds) {
        radians = dms.asRadians
    }
    
    public init(degrees: Int, minutes: Int, seconds: Double) {
        let dms = DegreesMinutesSeconds(degrees, minutes, seconds)
        self.init(dms: dms)
    }
    
}

// MARK: - Mean Obliguity Of The Ecliptic

extension SwiftAstro.Angle {
    
    /// The mean obliquity of the ecliptic in the standard equinox of J2000.
    public static let meanObliquityOfEclipticAtJ2000 = SwiftAstro.Angle(
        degrees: 23.43929111111111
    )

}

// MARK: - Operators

extension SwiftAstro.Angle {
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(radians: lhs.radians + rhs.radians)
    }
    
    public static func +=(lhs: inout Self, rhs: Self) -> Self {
        lhs + rhs
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(radians: lhs.radians - rhs.radians)
    }
    
    public static func -=(lhs: inout Self, rhs: Self) -> Self {
        lhs - rhs
    }
    
    public static func *(lhs: Self, rhs: Self) -> Self {
        return Self(radians: lhs.radians * rhs.radians)
    }
    
    public static func *=(lhs: inout Self, rhs: Self) -> Self {
        lhs * rhs
    }
    
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(radians: lhs.radians / rhs.radians)
    }
    
    public static func /=(lhs: inout Self, rhs: Self) -> Self {
        lhs / rhs
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.radians == rhs.radians
    }
    
    public static func !=(lhs: Self, rhs: Self) -> Bool {
        lhs.radians != rhs.radians
    }
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.radians < rhs.radians
    }
    
    public static func <=(lhs: Self, rhs: Self) -> Bool {
        lhs.radians <= rhs.radians
    }
    
    public static func >(lhs: Self, rhs: Self) -> Bool {
        lhs.radians > rhs.radians
    }
    
    public static func >=(lhs: Self, rhs: Self) -> Bool {
        lhs.radians >= rhs.radians
    }
    
    public static prefix func -(lhs: Self) -> Self {
        SwiftAstro.Angle(radians: -lhs.radians)
    }
    
    public static prefix func +(lhs: Self) -> Self {
        lhs
    }
    
    public static prefix func ..<(lhs: Self) -> PartialRangeUpTo<Self> {
        PartialRangeUpTo(lhs)
    }
    
    public static prefix func ...(lhs: Self) -> PartialRangeThrough<Self> {
        PartialRangeThrough(lhs)
    }
    
    public static postfix func ...(lhs: Self) -> PartialRangeFrom<Self> {
        PartialRangeFrom(lhs)
    }
    
}

// MARK: - Trigonometric Functions

public func sin(_ angle: SwiftAstro.Angle) -> Double {
    sin(angle.radians)
}

public func cos(_ angle: SwiftAstro.Angle) -> Double {
    cos(angle.radians)
}

public func tan(_ angle: SwiftAstro.Angle) -> Double {
    tan(angle.radians)
}
