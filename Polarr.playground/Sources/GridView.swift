
import UIKit

final class GridView: UIView {
    
    static let dimension: Int = 1000000000
    static let dimensionFloat: CGFloat = CGFloat(dimension)
    static let halfDimension: Int = dimension / 2
    
    internal static let startOffset: CGPoint = .init(
        x: CGFloat(GridView.halfDimension),
        y: CGFloat(GridView.halfDimension))
    
    internal static let contentSize: CGSize = .init(
        width: dimensionFloat,
        height: dimensionFloat)
    
    internal static let halfContentSize: CGSize = .init(
        width: dimensionFloat * 0.5,
        height: dimensionFloat * 0.5)
    
    internal static let contentInsets: UIEdgeInsets = .init(
        top: dimensionFloat * -0.5,
        left: dimensionFloat * -0.5,
        bottom: 0.0,
        right: 0.0)
    
    let contentView: UIView = {
        let view = UIView(
            frame: .init(
                origin: .zero,
                size: GridView.contentSize))
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.alwaysBounceHorizontal = true
        view.alwaysBounceVertical = true
        view.backgroundColor = UIColor.darkGray
        view.scrollsToTop = false
        view.minimumZoomScale = 0.5
        view.maximumZoomScale = 10.0
        view.bouncesZoom = false
        view.contentInsetAdjustmentBehavior = .never
        view.contentSize = GridView.contentSize
        view.contentOffset = GridView.startOffset
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
    }
}

extension UIScrollView {
    func zoom(toPoint zoomPoint : CGPoint, scale : CGFloat, animated : Bool) {
        var scale = CGFloat.minimum(scale, maximumZoomScale)
        scale = CGFloat.maximum(scale, self.minimumZoomScale)
        
        var translatedZoomPoint : CGPoint = .zero
        translatedZoomPoint.x = zoomPoint.x + contentOffset.x
        translatedZoomPoint.y = zoomPoint.y + contentOffset.y
        
        let zoomFactor = 1.0 / zoomScale
        
        translatedZoomPoint.x *= zoomFactor
        translatedZoomPoint.y *= zoomFactor
        
        var destinationRect : CGRect = .zero
        destinationRect.size.width = frame.width / scale
        destinationRect.size.height = frame.height / scale
        destinationRect.origin.x = translatedZoomPoint.x - destinationRect.width * 0.5
        destinationRect.origin.y = translatedZoomPoint.y - destinationRect.height * 0.5
        
        if animated {
            UIView.animate(withDuration: 0.55, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: [.allowUserInteraction], animations: {
                self.zoom(to: destinationRect, animated: false)
            }, completion: {
                completed in
                if let delegate = self.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self) {
                    delegate.scrollViewDidEndZooming!(self, with: view, atScale: scale)
                }
            })
        } else {
            zoom(to: destinationRect, animated: false)
        }
    }
}
