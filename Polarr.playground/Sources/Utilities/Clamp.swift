import Foundation

public func clamp<F: FloatingPoint>(value: F, min minimum: F, max maximum: F) -> F {
    return min(maximum, max(minimum, value))
}

public func clamp(value: Int, min minimum: Int, max maximum: Int) -> Int {
    return min(maximum, max(minimum, value))
}
