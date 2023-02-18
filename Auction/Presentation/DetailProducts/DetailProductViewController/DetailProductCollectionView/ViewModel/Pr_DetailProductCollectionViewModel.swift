import RxSwift

protocol Pr_DetailProductCollectionViewModel {
    var requestDetailProductObserver:AnyObserver<Int8>{get}
    var dataUpdate:Observable<HTTPError?> {get}
    func returnDetailProductImagesCount()->Int?
    func returnDetailProductImages()->DetailProductImages?
    func returnDetailProductUser()->DetailProductUser?
    func returnDetailProductComment()->DetailProductComment?
    func returnDetailProductGraph()->DetailProductGraph?
    
}
