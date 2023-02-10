import RxSwift

protocol Pr_MainContainerControllerViewModel{
    var gestureObservable:Observable<Pangesture>{get}
    var menuClickObservable:Observable<Void>{get}
}
