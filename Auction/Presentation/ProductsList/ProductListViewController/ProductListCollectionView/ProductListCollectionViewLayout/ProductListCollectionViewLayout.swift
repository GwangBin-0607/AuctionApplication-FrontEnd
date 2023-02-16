import Foundation
import UIKit
final class ProductListCollectionViewLayout:UICollectionViewLayout{
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
    private let viewModel:Pr_ProductListCollectionViewLayoutViewModel
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    private let minimunCellHeight:CGFloat = 150
    init(viewModel:Pr_ProductListCollectionViewLayoutViewModel,cellCount:Double) {
        self.viewModel = viewModel
        self.cellCount = Int(cellCount)
        super.init()
        print("Layout INIT")
    }
    deinit {
        print("CollectionViewLayOut DEINIT")
    }
    private let cellCount:Int
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var column = 0
    lazy var yOffset: [CGFloat] = .init(repeating: 0, count: cellCount)
    override func prepare() {
        guard
            let collectionView = collectionView
        else {
            return
        }
        if self.cache.count-1 == collectionView.numberOfItems(inSection: 0){
            return
        }else{
            removeFooterViewAttributes()
            let columnWidth = contentWidth / CGFloat(cellCount)
            var xOffset: [CGFloat] = []
            for column in 0..<cellCount {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            for item in cache.count..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let photoHeight = max(viewModel.returnImageHeightFromViewModel(index: indexPath),minimunCellHeight)
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
                
                column = column < (cellCount - 1) ? (column + 1) : 0
            }
            setFooterViewAttribute(maxY: contentHeight)
        }
    }
    private func removeFooterViewAttributes(){
        if cache.last?.representedElementKind != nil{
            cache.remove(at: cache.count-1)
        }
    }
    private func setFooterViewAttribute(maxY:CGFloat){
        if maxY != 0{
            let f = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: 0))
            f.frame = CGRect(x: 0.0, y: maxY, width: contentWidth, height: 50)
            cache.append(f)
            contentHeight = max(contentHeight,f.frame.maxY)
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
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.last
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

}

