import Foundation
import CoreGraphics

public struct GridItem: Hashable {
    public let row: Int
    public let column: Int
    
    public init(
        row: Int,
        column: Int
        ) {
        self.row = row
        self.column = column
    }
        
    public func coordinates(for size: CGSize) -> CGRect {
        return CGRect(
            origin: CGPoint(
                x: CGFloat(column) * size.width,
                y: CGFloat(row) * size.width),
            size: size)
    }
    
    public func offset(by item: GridItem) -> GridItem {
        return GridItem(row: row + item.row, column: column + item.column)
    }
}
