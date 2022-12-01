import UIKit
import RxSwift
protocol UICollectionViewLayoutNeedImageHeight:UICollectionViewLayout{
    //MARK: INPUT
    var imageHeightObserver:AnyObserver<(CGFloat,IndexPath)>{get}
    //MARK: OUTPUT
    var indexpathObservable:Observable<IndexPath>{get}
}
