import RxSwift

final class DetailProductCollectionViewModel:Pr_DetailProductCollectionViewModel{
    func returnDetailProductImagesCount() -> Int? {
        detailProduct?.returnProductImages().returnImageCount()
    }
    
    let requestDetailProductObserver: AnyObserver<Int8>
    private var detailProduct:DetailProduct?
    private let detailProductUsecase:Pr_DetailProductUsecase
    private let disposeBag:DisposeBag
    private let imageCellViewModel:Pr_DetailProductCollectionViewImageCellViewModel
    private let userCellViewModel:Pr_DetailProductCollectionViewUserCellViewModel
    let dataUpdate: Observable<Void>
    let detailProductInfo: Observable<DetailProductInfo>
    init(detailProductUsecase:Pr_DetailProductUsecase,detailProductCollectionViewImageCellViewModel:Pr_DetailProductCollectionViewImageCellViewModel,detailProductCollectionViewUserCellViewModel:Pr_DetailProductCollectionViewUserCellViewModel) {
        let detailProductInfoSubject = PublishSubject<DetailProductInfo>()
        detailProductInfo = detailProductInfoSubject.asObservable()
        let detailProductInfoObserver = detailProductInfoSubject.asObserver()
        userCellViewModel = detailProductCollectionViewUserCellViewModel
        imageCellViewModel = detailProductCollectionViewImageCellViewModel
        let dataUpdateSubject = PublishSubject<Void>()
        dataUpdate = dataUpdateSubject.asObservable().observe(on: MainScheduler.asyncInstance).take(1)
        let dataUpdateObserver = dataUpdateSubject.asObserver()
        self.disposeBag = DisposeBag()
        self.detailProductUsecase = detailProductUsecase
        let requestDetailProduct = PublishSubject<Int8>()
        requestDetailProductObserver = requestDetailProduct.asObserver()
        requestDetailProduct.flatMap(detailProductUsecase.returnDetailProduct(productId:)).withUnretained(self).subscribe(onNext: {
            owner,result in
            print("========")
            switch result {
            case .success(let detailProduct):
                print(detailProduct)
                owner.detailProduct = detailProduct
                dataUpdateObserver.onNext(())
                detailProductInfoObserver.onNext(detailProduct.returnProductInfo())
            case .failure(let err):
                print("ERROR")
                print(err)
            }
        }).disposed(by: disposeBag)
    }
    func returnDetailProductCollectionViewCellViewModel() -> Pr_DetailProductCollectionViewImageCellViewModel {
        imageCellViewModel
    }
    func returnDetailProductCollectionViewUserCellViewModel() -> Pr_DetailProductCollectionViewUserCellViewModel {
        userCellViewModel
    }
    func returnDetailProductUser() -> DetailProductUser? {
        detailProduct?.returnProductUser()
    }
    func returnDetailProductGraph() -> DetailProductGraph? {
        detailProduct?.returnProductGraph()
    }
    func returnDetailProductImages(index: Int) -> Image? {
        detailProduct?.returnProductImages().returnProductImage(index: index)
    }
    func returnDetailProductComment() -> DetailProductComment? {
        detailProduct?.returnProductComment()
    }
}
