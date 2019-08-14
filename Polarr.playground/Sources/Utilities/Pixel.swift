import Foundation
import simd

public struct Pixel {
    public var red: UInt8
    public var green: UInt8
    public var blue: UInt8
    public var alpha: UInt8
    
    public init(
        red: UInt8,
        green: UInt8,
        blue: UInt8,
        alpha: UInt8
        ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public static var zero: Pixel {
        return .init(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    public init(_ floatValue: float4) {
        let inflated = clamp(floatValue, min: 0.0, max: 1.0) * Float(UInt8.max)
        self.red = UInt8(inflated.x)
        self.green = UInt8(inflated.y)
        self.blue = UInt8(inflated.z)
        self.alpha = UInt8(inflated.w)
    }
    
    public var floatValue: float4 {
        return float4(
            x: Float(red) / Float(UInt8.max),
            y: Float(green) / Float(UInt8.max),
            z: Float(blue) / Float(UInt8.max),
            w: Float(alpha) / Float(UInt8.max))
    }
    
}
