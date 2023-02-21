import RxSwift

final class DetailProductCollectionViewModel:Pr_DetailProductCollectionViewModel{
    func returnDetailProductImagesCount() -> Int? {
        detailProduct?.returnProductImages().returnImageCount()
    }
    
    let requestDetailProductObserver: AnyObserver<Int8>
    private var detailProduct:DetailProduct?
    private let detailProductUsecase:Pr_DetailProductUsecase
    private let disposeBag:DisposeBag
    let dataUpdate: Observable<Void>
    init(detailProductUsecase:Pr_DetailProductUsecase) {
        let dataUpdateSubject = PublishSubject<Void>()
        dataUpdate = dataUpdateSubject.asObservable().observe(on: MainScheduler.asyncInstance).take(1)
        let dataUpdateObserver = dataUpdateSubject.asObserver()
        self.disposeBag = DisposeBag()
        self.detailProductUsecase = detailProductUsecase
        let requestDetailProduct = PublishSubject<Int8>()
        requestDetailProductObserver = requestDetailProduct.asObserver()
        requestDetailProduct.flatMap(detailProductUsecase.returnDetailProduct(productId:)).withUnretained(self).subscribe(onNext: {
            owner,result in
            let test = DetailProduct(productImage: DetailProductImages(images: [Product_Images(image_id: 01),Product_Images(image_id: 02),Product_Images(image_id: 03),Product_Images(image_id: 04),Product_Images(image_id: 05),Product_Images(image_id: 06),Product_Images(image_id: 07),Product_Images(image_id: 08),Product_Images(image_id:09)]), productUser: DetailProductUser(userName: "Hello"), productComment: DetailProductComment(comment: "Commentawdhuaowdaiowdiaowdhoawdhoawdhioawdhioawdhioawdihawiodawi"), productGraph: DetailProductGraph(data: [GraphData(date: "2023-05-12", price: 5000)]))
            owner.detailProduct = test
            dataUpdateObserver.onNext(())
//            switch result {
//            case .success(let detailProduct):
//                let test = DetailProduct(productImage: DetailProductImages(images: [Product_Images(image_id: 1),Product_Images(image_id: 2),Product_Images(image_id: 3),Product_Images(image_id: 4),Product_Images(image_id: 5),Product_Images(image_id: 6),Product_Images(image_id: 7),Product_Images(image_id: 8),Product_Images(image_id: 9)]), productUser: DetailProductUser(userName: "Hello"), productComment: DetailProductComment(comment: "Comment"), productGraph: DetailProductGraph(data: [GraphData(date: "2023-05-12", price: 5000)]))
//                owner.detailProduct = test
//                dataUpdateObserver.onNext(())
//            case .failure(let err):
//                break;
//            }
        }).disposed(by: disposeBag)
    }
    func returnDetailProductUser() -> DetailProductUser? {
        detailProduct?.returnProductUser()
    }
    func returnDetailProductGraph() -> DetailProductGraph? {
        detailProduct?.returnProductGraph()
    }
    func returnDetailProductImages(index: Int) -> Product_Images? {
        detailProduct?.returnProductImages().returnProductImage(index: index)
    }
    func returnDetailProductComment() -> DetailProductComment? {
        detailProduct?.returnProductComment()
    }
}
