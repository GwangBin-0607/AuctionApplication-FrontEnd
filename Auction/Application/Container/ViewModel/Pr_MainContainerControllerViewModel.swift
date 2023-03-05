import RxSwift

protocol Pr_MainContainerControllerViewModel{
    var pangestureObservable:Observable<Pangesture>{get}
    var tapgestureObservable:Observable<Void>{get}
    var presentUserPage:AnyObserver<Void>{get}
}
