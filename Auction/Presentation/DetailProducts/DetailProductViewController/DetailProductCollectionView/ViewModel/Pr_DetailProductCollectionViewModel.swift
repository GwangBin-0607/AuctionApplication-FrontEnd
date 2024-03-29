import RxSwift
protocol Pr_DetailProductCollectionViewModel {
    var requestDetailProductObserver:AnyObserver<Int>{get}
    var dataUpdate:Observable<Void> {get}
    func returnDetailProductImagesCount()->Int?
    func returnDetailProductImages(index:Int)->Image?
    func returnDetailProductUser()->DetailProductUser?
    func returnDetailProductComment()->DetailProductComment?
    func returnDetailProductGraph()->DetailProductGraph?
    func returnDetailProductCollectionViewCellViewModel()->Pr_DetailProductCollectionViewImageCellViewModel
    func returnDetailProductCollectionViewUserCellViewModel()->Pr_DetailProductCollectionViewUserCellViewModel
    
}
