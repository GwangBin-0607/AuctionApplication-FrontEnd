import Foundation
import UIKit
final class ProductListCollectionViewLayout:UICollectionViewLayout{
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    weak var delegate:ReturnHeightUICollectionViewLayoutDelegate?
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override init() {
        super.init()
    }
    deinit {
        print("CollectionViewLayOut DEINIT")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func prepare() {
        print("Prepare")
        guard
          cache.isEmpty == true,
          let collectionView = collectionView
          else {
              print("return")
              return
        }
        print("Not Return")
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
          xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
          
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
          let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.returnImageHeightFromUICollectionView(index: indexPath) ?? 180
          let height = cellPadding * 2 + photoHeight
          let frame = CGRect(x: xOffset[column],
                             y: yOffset[column],
                             width: columnWidth,
                             height: height)
          let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
          
            
          let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          attributes.frame = insetFrame
          cache.append(attributes)
            
          contentHeight = max(contentHeight, frame.maxY)
          yOffset[column] = yOffset[column] + height
            
          column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
 
}

