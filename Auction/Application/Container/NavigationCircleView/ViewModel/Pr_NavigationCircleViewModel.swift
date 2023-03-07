import RxSwift
import CoreGraphics
struct Pangesture{
    let point:CGPoint
    let state:UIGestureRecognizer.State
}
enum LoginState{
    case login
    case logout
}
protocol Pr_NavigationCircleViewModel {
    var pangestureObserver:AnyObserver<Pangesture>{get}
    var pangestureObservable:Observable<Pangesture>{get}
    var tapGestureObserver:AnyObserver<Void>{get}
    var tapGestureObservable:Observable<Void>{get}
    var loginStateObservable:Observable<LoginState>{get}
    var backGestureObserver:AnyObserver<Void>{get}
    var backGestureObservable:Observable<Void>{get}
}
