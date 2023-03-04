import RxSwift
import CoreGraphics
struct Pangesture{
    let point:CGPoint
    let state:UIGestureRecognizer.State
}
protocol Pr_NavigationCircleViewModel {
    var pangestureObserver:AnyObserver<Pangesture>{get}
    var pangestureObservable:Observable<Pangesture>{get}
    var tapGestureObserver:AnyObserver<Void>{get}
    var tapGestureObservable:Observable<Void>{get}
}
