import UIKit
import RxSwift

final class ProductListCollectionView: UICollectionView {
    let imageObserver: AnyObserver<RequestImageHeight>
    let indexObservable: Observable<IndexPath>
    private let disposeBag:DisposeBag
    init(collectionViewLayout layout:UICollectionViewLayoutNeedImageHeight, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {
        let indexPublish = PublishSubject<IndexPath>()
        let imagePublish = PublishSubject<RequestImageHeight>()
        indexObservable = indexPublish.asObservable()
        imageObserver = imagePublish.asObserver()
        disposeBag = DisposeBag()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
        let indexObserver = indexPublish.asObserver()
        layout.indexpathObservable.subscribe(onNext: {
            index in
            indexObserver.onNext(index)
        }).disposed(by: disposeBag)
        let imageObservable = imagePublish.asObservable()
        imageObservable.subscribe(onNext: {
            requestImageHeight in
            layout.imageHeightObserver.onNext(requestImageHeight)
        }).disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CollectionView DEINIT")
    }

}
