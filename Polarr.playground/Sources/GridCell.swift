import UIKit

internal final class GridCell: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.15, alpha: 1.0)
//        layer.borderColor = UIColor.black.cgColor//.withAlphaComponent(0.4).cgColor
//        layer.borderWidth = 1.0// / UIScreen.main.scale
//        font = UIFont.systemFont(ofSize: 8.0)
//        numberOfLines = 0
//        textAlignment = .center
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
