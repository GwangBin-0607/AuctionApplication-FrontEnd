import RxSwift

protocol BindingProductsListCollectionCellViewModel{
    var responseImage:Observable<TestResponseImage>{get}
    var requestImage:AnyObserver<TestRequestImage>{get}
}
