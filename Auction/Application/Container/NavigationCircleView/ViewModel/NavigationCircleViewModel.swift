import RxSwift
class NavigationCircleViewModel:Pr_NavigationCircleViewModel{
    let pangestureObserver: AnyObserver<Pangesture>
    let pangestureObservable: Observable<Pangesture>
    let tapGestureObservable: Observable<Void>
    let tapGestureObserver: AnyObserver<Void>
    init() {
        let tapGestureSubject = PublishSubject<Void>()
        tapGestureObserver = tapGestureSubject.asObserver()
        tapGestureObservable = tapGestureSubject.asObservable()
        let pangestureSubject=PublishSubject<Pangesture>()
        pangestureObserver = pangestureSubject.asObserver()
        pangestureObservable = pangestureSubject.asObservable()
    }
}
