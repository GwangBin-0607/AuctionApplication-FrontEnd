import RxSwift

protocol Pr_DetailProductCollectionViewModel {
    var requestDetailProductObserver:AnyObserver<Int8>{get}
    var dataUpdate:Observable<Void> {get}
    func returnDetailProductImagesCount()->Int?
    func returnDetailProductImages(index:Int)->Product_Images?
    func returnDetailProductUser()->DetailProductUser?
    func returnDetailProductComment()->DetailProductComment?
    func returnDetailProductGraph()->DetailProductGraph?
    
}
