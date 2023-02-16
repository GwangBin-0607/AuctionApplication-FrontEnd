import RxSwift
class NavigationCircleViewModel:Pr_NavigationCircleViewModel{
    let gestureObservable:Observable<Pangesture>
    let gestureObserver:AnyObserver<Pangesture>
    let menuClickObserver:AnyObserver<Void>
    let menuClickObservable:Observable<Void>
    init() {
        let menuClickPublish = PublishSubject<Void>()
        menuClickObserver = menuClickPublish.asObserver()
        menuClickObservable = menuClickPublish.asObservable()
        let gesturePublish = PublishSubject<Pangesture>()
        self.gestureObservable = gesturePublish.asObservable()
        self.gestureObserver = gesturePublish.asObserver()
    }
}
