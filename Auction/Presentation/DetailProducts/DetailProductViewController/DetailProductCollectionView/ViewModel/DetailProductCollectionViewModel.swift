import RxSwift

final class DetailProductCollectionViewModel:Pr_DetailProductCollectionViewModel{
    func returnDetailProductImagesCount() -> Int? {
        detailProduct?.returnProductImages().returnImageCount()
    }
    
    let requestDetailProductObserver: AnyObserver<Int8>
    private var detailProduct:DetailProduct?
    private let detailProductUsecase:Pr_DetailProductUsecase
    private let disposeBag:DisposeBag
    let dataUpdate: Observable<HTTPError?>
    init(detailProductUsecase:Pr_DetailProductUsecase) {
        let dataUpdateSubject = PublishSubject<HTTPError?>()
        dataUpdate = dataUpdateSubject.asObservable()
        let dataUpdateObserver = dataUpdateSubject.asObserver()
        self.disposeBag = DisposeBag()
        self.detailProductUsecase = detailProductUsecase
        let requestDetailProduct = PublishSubject<Int8>()
        requestDetailProductObserver = requestDetailProduct.asObserver()
        requestDetailProduct.flatMap(detailProductUsecase.returnDetailProduct(productId:)).withUnretained(self).subscribe(onNext: {
            owner,result in
            switch result {
            case .success(let detailProduct):
                owner.detailProduct = detailProduct
                dataUpdateObserver.onNext(nil)
            case .failure(let err):
                dataUpdateObserver.onNext(err)
            }
        }).disposed(by: disposeBag)
    }
    func returnDetailProductUser() -> DetailProductUser? {
        detailProduct?.returnProductUser()
    }
    func returnDetailProductGraph() -> DetailProductGraph? {
        detailProduct?.returnProductGraph()
    }
    func returnDetailProductImages() -> DetailProductImages? {
        detailProduct?.returnProductImages()
    }
    func returnDetailProductComment() -> DetailProductComment? {
        detailProduct?.returnProductComment()
    }
}
