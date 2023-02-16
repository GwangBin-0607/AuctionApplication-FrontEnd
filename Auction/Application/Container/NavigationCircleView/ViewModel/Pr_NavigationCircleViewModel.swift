import RxSwift
import CoreGraphics
struct Pangesture{
    let point:CGPoint
    let state:UIGestureRecognizer.State
}
protocol Pr_NavigationCircleViewModel {
    var gestureObservable:Observable<Pangesture>{get}
    var gestureObserver:AnyObserver<Pangesture>{get}
    var menuClickObserver:AnyObserver<Void>{get}
    var menuClickObservable:Observable<Void>{get}
}
