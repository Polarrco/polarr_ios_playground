import UIKit
import simd

public protocol Grid {
    
    /// Re-process a given cell represented by the grid item with the current kernel
    ///
    /// - Parameter gridItem: the item a.k.a. index path.
    func processItem(_ gridItem: GridItem)
    
    /// Refreshes every cell presently visible, processing each cell with the kernel.
    func refresh()
    
    /// The custom Kernel to be used if `gridKernel` is set to `.custom`
    var customKernel: Kernel { get set }
    /// The current kernel to be used for processing.
    /// It's an enum for build in kernel cases and one case for the custom kernel.
    var gridKernel: GridKernel { get set }
}

open class GridViewController: UIViewController, Grid {

    static let space: Float = 40.0
    
    static let positiveGridOffset: GridItem = {
        let count = GridView.halfDimension / Int(space)
        return GridItem(row: count, column: count)
    }()
    
    static let negativeGridOffset: GridItem = {
        let count = GridView.halfDimension / Int(space)
        return GridItem(row: -count, column: -count)
    }()

    /// The custom Kernel to be used if `gridKernel` is set to `.custom`
    public var customKernel: Kernel = CustomKernel {
        didSet {
            refresh()
        }
    }

    /// The current kernel to be used for processing.
    /// It's an enum for build in kernel cases and one case for the custom kernel.
    public var gridKernel: GridKernel = .blank

    required public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var _view: GridView {
        return view as! GridView
    }

    override open func loadView() {
        view = GridView(frame: .zero)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        _view.scrollView.delegate = self

        _view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutGrid()
    }

    @objc
    private func handleTap(gesture: UITapGestureRecognizer) {
        gridKernel.next()
        refresh()
    }

    /// Simulate GPU processing
    /// processes every cell on screen.
    public func refresh() {
        activeGridItems.forEach({
            let item = $0.key
            let cell = $0.value
            processKernel(for: item, cell: cell)
        })
    }
    
    public func processItem(_ gridItem: GridItem) {
        guard let cell = activeGridItems[gridItem] else { return }
        processKernel(for: gridItem, cell: cell)
    }
    
    /// Simulate GPU processing per pixel
    private func processKernel(for gridItem: GridItem, cell: GridCell) {
        
        let item = gridItem.offset(by: GridViewController.negativeGridOffset)
        
        var info = GridItemInfo(
            color: cell.backgroundColor ?? .clear,
//            text: "x: \(item.column), \ny: \(item.row)",
//            textColor: UIColor.black,
//            font: GridItemInfo.defaultFont,
            border: nil//(color: .black, width: 1.0)
        )
        
        // simulate process GPU
        switch gridKernel {
        case .blank:
            BlankKernel(item: item, output: &info)
        case .checkardboard:
            CheckardboardKernel(item: item, output: &info)
        case .circle:
            CircleKernel(item: item, output: &info)
        case .custom:
            customKernel(item, &info)
        }
        
        cell.backgroundColor = info.color
//        cell.text = info.text
//        cell.textColor = info.textColor
        if let border = info.border {
            cell.layer.borderColor = border.color.cgColor
            cell.layer.borderWidth = border.width
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0.0
        }
    }

    private var activeGridItems: [GridItem: GridCell] = [:]
    private var gridCellCache: Set<GridCell> = []
}

extension GridViewController {

    private func layoutGrid() {
        let visibleRect = _view.scrollView.convert(
            _view.scrollView.bounds,
            to: _view.contentView)

        layoutGrid(in: visibleRect)
//        layoutGrid(in: Rectangle(
//            minCorner: float2(
//                x: Float(visibleRect.minX) - GridViewController.space,
//                y: Float(visibleRect.minY) - GridViewController.space),
//            maxCorner: float2(
//                x: Float(visibleRect.maxX) + GridViewController.space,
//                y: Float(visibleRect.maxY) + GridViewController.space)))
    }

    private func layoutGrid(in rect: CGRect) {
        let items = self.activeGridItems
        let size: CGSize = .init(
            width: CGFloat(GridViewController.space),
            height: CGFloat(GridViewController.space))
        
        var currentItems: [GridItem: GridCell] = items.filter { item in
            guard
                rect.intersects(item.key.coordinates(for: size))
                else {
                    item.value.removeFromSuperview()
                    gridCellCache.insert(item.value)
                    return false
            }
            return true
        }

        //print("rect: \(rect)")
        let minX = Int(rect.minX / size.width)
        let minY = Int(rect.minY / size.height)
        let maxX = Int(rect.maxX / size.width) + 1
        let maxY = Int(rect.maxY / size.height) + 1

        for y in minY...maxY {
            for x in minX...maxX {
                let item = GridItem(
                    row: y,
                    column: x
                )

                guard currentItems[item] == nil else { continue }

                let frame = item.coordinates(for: size)
                
                if let view = gridCellCache.first {
                    gridCellCache.remove(view)
                    view.frame = frame
                    _view.contentView.addSubview(view)
                    currentItems[item] = view
                    processKernel(for: item, cell: view)
                } else {
                    let view = GridCell(frame: frame)
                    _view.contentView.addSubview(view)
                    currentItems[item] = view
                    processKernel(for: item, cell: view)
                }
            }
        }

        self.activeGridItems = currentItems
    }
}

extension GridViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutGrid()
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        layoutGrid()
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return _view.contentView
    }
}
