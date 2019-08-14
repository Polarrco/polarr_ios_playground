import Foundation

public typealias Kernel = (_ item: GridItem, _ output: inout GridItemInfo) -> ()

public enum GridKernel: CaseIterable {
    case blank
    case checkardboard
    case circle
    case custom
    
    public mutating func next() {
        switch self {
        case .blank: self = .checkardboard
        case .checkardboard: self = .circle
        case .circle: self = .custom
        case .custom: self = .blank
        }
    }
}

public func CheckardboardKernel(item: GridItem, output: inout GridItemInfo) {
    switch item.row % 2 {
    case 0:
        switch item.column % 2 {
        case 0:
            output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default:
            output.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    default:
        switch item.column % 2 {
        case 0:
            output.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default:
            output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}

public func CircleKernel(item: GridItem, output: inout GridItemInfo) {
    let radius = 10
    let border = 2
    switch item.column {
    case let x where x < -radius: output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    case let x where x > radius: output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    default:
        switch item.row {
        case let y where y < -radius: output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case let y where y > radius: output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default:
            let x = item.column
            let y = item.row
            let c2 = x * x + y * y
            let r2 = radius * radius
            if c2 < r2 {
                if sqrt(Double(c2)).magnitude >= Double(radius - border) {
                    output.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                } else {
                    output.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            } else {
                output.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
        }
    }
}

public func CustomKernel(item: GridItem, output: inout GridItemInfo) {
    output.color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
}

public func BlankKernel(item: GridItem, output: inout GridItemInfo) {
    output.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}
