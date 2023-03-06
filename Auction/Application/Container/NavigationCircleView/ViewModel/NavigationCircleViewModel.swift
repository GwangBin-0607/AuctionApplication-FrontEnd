import RxSwift
class NavigationCircleViewModel:Pr_NavigationCircleViewModel{
    let pangestureObserver: AnyObserver<Pangesture>
    let pangestureObservable: Observable<Pangesture>
    let tapGestureObservable: Observable<Void>
    let tapGestureObserver: AnyObserver<Void>
    let loginStateObservable: Observable<LoginState>
    let loginObserver: AnyObserver<Void>
    let backGestureObserver: AnyObserver<Void>
    let backGestureObservable: Observable<Void>
    private let disposeBag:DisposeBag
    private let customTextButtonViewModel:Pr_CustomTextButtonViewModel
    init(customTextButtonViewModel:Pr_CustomTextButtonViewModel) {
        self.customTextButtonViewModel = customTextButtonViewModel
        disposeBag = DisposeBag()
        let loginSubject = PublishSubject<Void>()
        loginObserver = loginSubject.asObserver()
        let backGestureSubject = PublishSubject<Void>()
        backGestureObservable = backGestureSubject.asObservable()
        backGestureObserver = backGestureSubject.asObserver()
        let loginStateSubject = PublishSubject<LoginState>()
        loginStateObservable = loginStateSubject.asObservable()
        let loginStateObserver = loginStateSubject.asObserver()
        let tapGestureSubject = PublishSubject<Void>()
        tapGestureObserver = tapGestureSubject.asObserver()
        tapGestureObservable = tapGestureSubject.asObservable()
        let pangestureSubject=PublishSubject<Pangesture>()
        pangestureObserver = pangestureSubject.asObserver()
        pangestureObservable = pangestureSubject.asObservable()
        loginSubject.asObservable().subscribe(onNext: {
            //Login
            loginStateObserver.onNext(.logout)
        }).disposed(by: disposeBag)
        customTextButtonViewModel.tapObservable.subscribe(onNext: {
            loginStateObserver.onNext(.login)
        }).disposed(by: disposeBag)
    }
}
