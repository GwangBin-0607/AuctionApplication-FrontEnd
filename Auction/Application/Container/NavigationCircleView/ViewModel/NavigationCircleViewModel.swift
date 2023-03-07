import RxSwift
class NavigationCircleViewModel:Pr_NavigationCircleViewModel{
    let pangestureObserver: AnyObserver<Pangesture>
    let pangestureObservable: Observable<Pangesture>
    let tapGestureObservable: Observable<Void>
    let tapGestureObserver: AnyObserver<Void>
    let loginStateObservable: Observable<LoginState>
    let backGestureObserver: AnyObserver<Void>
    let backGestureObservable: Observable<Void>
    private let disposeBag:DisposeBag
    init() {
        disposeBag = DisposeBag()
        let backGestureSubject = PublishSubject<Void>()
        backGestureObservable = backGestureSubject.asObservable()
        backGestureObserver = backGestureSubject.asObserver()
        let loginStateSubject = PublishSubject<LoginState>()
        loginStateObservable = loginStateSubject.asObservable()
        let tapGestureSubject = PublishSubject<Void>()
        tapGestureObserver = tapGestureSubject.asObserver()
        tapGestureObservable = tapGestureSubject.asObservable()
        let pangestureSubject=PublishSubject<Pangesture>()
        pangestureObserver = pangestureSubject.asObserver()
        pangestureObservable = pangestureSubject.asObservable()
    }
}
