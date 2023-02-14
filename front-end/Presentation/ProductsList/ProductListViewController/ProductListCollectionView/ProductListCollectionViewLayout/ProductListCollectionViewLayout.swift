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
    init(viewModel:Pr_ProductListCollectionViewLayoutViewModel) {
        self.viewModel = viewModel
        super.init()
        print("Layout INIT")
    }
    deinit {
        print("CollectionViewLayOut DEINIT")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard
            let collectionView = collectionView
        else {
            return
        }
        if self.cache.count-1 == collectionView.numberOfItems(inSection: 0){
            return
        }else{
            print("Prepare")
            self.cache.removeAll()
            removeFooterViewAttributes()
            let columnWidth = contentWidth / CGFloat(self.viewModel.returnContentCountOfWidth())
            var xOffset: [CGFloat] = []
            for column in 0..<self.viewModel.returnContentCountOfWidth() {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            var column = 0
            var yOffset: [CGFloat] = .init(repeating: 0, count: self.viewModel.returnContentCountOfWidth())
            
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let photoHeight = viewModel.returnImageHeightFromViewModel(index: indexPath)
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
                
                column = column < (self.viewModel.returnContentCountOfWidth() - 1) ? (column + 1) : 0
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
    
}

