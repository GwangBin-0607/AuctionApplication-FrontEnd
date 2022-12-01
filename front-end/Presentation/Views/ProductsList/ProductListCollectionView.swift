import UIKit
import RxSwift

class ProductListCollectionView: UICollectionView {
    private let disposeBag:DisposeBag
    init(collectionViewLayout layout:UICollectionViewLayoutNeedImageHeight, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {
        disposeBag = DisposeBag()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
        
        layout.indexpathObservable.subscribe(onNext: {
            index in
            layout.imageHeightObserver.onNext((150.0,index))
        }).disposed(by: disposeBag)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        disposeBag = DisposeBag()
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CollectionView DEINIT")
    }

}
