import Foundation

public func lerp<F: FloatingPoint>(_ a: F, b: F, t: F) -> F {
    return a + (b - a) * t
}

public func ilerp<F: FloatingPoint>(_ a: F, min: F, max: F) -> F {
    return (a - min) / (max - min)
}
