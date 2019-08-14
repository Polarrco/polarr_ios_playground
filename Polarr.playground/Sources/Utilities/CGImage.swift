import Foundation
import CoreGraphics

extension CGImage {
    public func pixelData() -> [Pixel] {
        let size = CGSize(width: self.width, height: self.height)
        let area = width * height
        var pixelData = [Pixel](repeating: .zero, count: area)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: &pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        context?.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelData
    }
}
