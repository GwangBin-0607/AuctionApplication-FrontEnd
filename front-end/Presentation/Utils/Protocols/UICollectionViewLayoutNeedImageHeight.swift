import UIKit
import RxSwift
protocol UICollectionViewLayoutNeedImageHeight:UICollectionViewLayout{
    //MARK: INPUT
    var imageHeightObserver:AnyObserver<RequestImageHeight>{get}
    //MARK: OUTPUT
    var indexpathObservable:Observable<IndexPath>{get}
}
