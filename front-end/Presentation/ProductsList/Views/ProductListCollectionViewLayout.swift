import Foundation
import UIKit
import RxSwift
class ProductListCollectionViewLayout:UICollectionViewLayout,UICollectionViewLayoutNeedImageHeight{
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
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    let indexpathObservable: Observable<IndexPath>
    let imageHeightObserver: AnyObserver<(CGFloat,IndexPath)>
    private let indexPathObserver:AnyObserver<IndexPath>
    private let imageHeightObservable:Observable<(CGFloat,IndexPath)>
    private let disposeBag:DisposeBag
    override init() {
        disposeBag = DisposeBag()
        let indexPathPublishSubject = PublishSubject<IndexPath>()
        let imageHeightPublishSubject = PublishSubject<(CGFloat,IndexPath)>()
        indexpathObservable = indexPathPublishSubject.asObservable()
        imageHeightObserver = imageHeightPublishSubject.asObserver()
        indexPathObserver = indexPathPublishSubject.asObserver()
        imageHeightObservable = imageHeightPublishSubject.asObservable()
        super.init()
        imageHeightObservable.withUnretained(self).subscribe(onNext: {
            owner,tuple in
            let photoHeight = tuple.0
            let height = owner.cellPadding * 2 + photoHeight
            let frame = CGRect(x: owner.xOffset[owner.column],
                               y: owner.yOffset[owner.column],
                               width: owner.columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: owner.cellPadding, dy: owner.cellPadding)
            
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: tuple.1)
            attributes.frame = insetFrame
            owner.cache.append(attributes)
            
            owner.contentHeight = max(owner.contentHeight, frame.maxY)
            owner.yOffset[owner.column] = owner.yOffset[owner.column] + height
            
            owner.column = owner.column < (owner.numberOfColumns - 1) ? (owner.column + 1) : 0
        }).disposed(by: disposeBag)
    }
    deinit {
        print("CollectionViewLayOut DEINIT")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var columnWidth:CGFloat!
    private var xOffset:[CGFloat]!
    private var column:Int!
    private var yOffset:[CGFloat]!
    
    override func prepare() {
        guard
            cache.isEmpty == true,
            let collectionView = collectionView
        else {
            return
        }
        columnWidth = contentWidth / CGFloat(numberOfColumns)
        xOffset = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        column = 0
         yOffset = .init(repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            indexPathObserver.onNext(indexPath)
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
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

