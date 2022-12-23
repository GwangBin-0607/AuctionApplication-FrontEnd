////
////  Test_.swift
////  front-end
////
////  Created by 안광빈 on 2022/12/20.
////
//
//import Foundation
//import RxSwift
////protocol Test_StreamProductPrice{
////    var streamObservable:Observable<Result<[Product],Error>>?{get}
////}
//class Mock_TCP:StreamingData{
//    let controlSocketConnect: AnyObserver<isConnecting>
//
//    let outputDataObserver: AnyObserver<Data?>
//
//    let inputDataObservable: Observable<Data>
//
//    let isSocketConnect: Observable<isConnecting>
//    private let inputObserver:AnyObserver<Data>
//    private let disposeBag:DisposeBag
//    init(){
//        disposeBag = DisposeBag()
//        let connectSubject = PublishSubject<isConnecting>()
//        let inputDataSubject = PublishSubject<Data>()
//        let outputDataSubject = PublishSubject<Data?>()
//        controlSocketConnect = connectSubject.asObserver()
//        isSocketConnect = connectSubject.asObservable()
//        inputDataObservable = inputDataSubject.asObservable()
//        outputDataObserver = outputDataSubject.asObserver()
//        inputObserver = inputDataSubject.asObserver()
//        let isSocketConnectObservable = connectSubject.asObservable()
//        isSocketConnectObservable.observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
//            isconnect in
//            print(Thread.isMainThread)
//            if isconnect == .connect{
//                print(isconnect)
//                                self.startSocket()
//            }
//        }).disposed(by: disposeBag)
//
//    }
//    private func startSocket(){
//        testInputData()
//    }
//    private func testInputData(){
//        print("Set")
//        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerAction), userInfo: nil, repeats: true)
//    }
//    @objc private func TimerAction(){
//        print("timer")
//        do{
//            let data = try getData()
//            inputObserver.onNext(data)
//        }catch{
//            print(error)
//        }
//    }
//    private func getData()throws->Data{
//        guard let path = Bundle.main.path(forResource: "StreamingProductPriceListTestData", ofType: "json")
//                ,let jsonString = try? String(contentsOfFile: path)
//                ,let data = jsonString.data(using: .utf8)else{
//            throw NSError(domain: "Not Data", code: -1)
//        }
//        return data
//    }
//    deinit {
//        print("TCP DEINIT")
//    }
//
//}
//protocol Test_Usecase{
//    func returnProductList()->Observable<Result<[Product],Error>>
//    func returnRequestObserver()->AnyObserver<Int>
//    func returnProductImageHeight(productId:Int,imageURL:String?)->CGFloat
//    func returnProductImage(productId:Int,imageURL:String?)->UIImage
//}
//class Test_ProductListUsecase:Test_Usecase{
//    let repo:Test_Repo
//    let imageRepo:TransferProductsImage
//    init(repo: Test_Repo,imageRepo:TransferProductsImage) {
//        self.repo = repo
//        self.imageRepo = imageRepo
//    }
//    func returnProductList() -> Observable<Result<[Product], Error>> {
//        repo.productListObservable
//    }
//    func returnRequestObserver() -> AnyObserver<Int> {
//        repo.requestObserver
//    }
//    func returnProductImageHeight(productId:Int,imageURL:String?)->CGFloat{
//        imageRepo.returnImageHeight(productId: productId, imageURL: imageURL)
//    }
//    func returnProductImage(productId:Int,imageURL:String?)->UIImage{
//        imageRepo.returnImage(productId: productId, imageURL: imageURL)
//    }
//}
//protocol Test_ViewModel{
//    var productsList:Observable<[ProductSection]>{get}
//    func productHeight(indexPath:IndexPath)->CGFloat
//    func productPrice(indexPath:IndexPath)->Int
//}
//class Test_ProductListViewModel:Test_ViewModel{
//    let productsList: Observable<[ProductSection]>
//    let usecase:Test_Usecase
//    let products:BehaviorSubject<[Product]> = BehaviorSubject(value: [])
//    let disposeBag:DisposeBag
//    init(usecase: Test_Usecase) {
//        self.usecase = usecase
//        disposeBag = DisposeBag()
//        productsList = products.asObservable().scan(ProductSection(products: [])) { (prevValue, newValue) in
//            return ProductSection(original: prevValue, items: newValue)
//        }.map({[$0]})
//        let productListObserver = products.asObserver()
//
//        usecase.returnProductList()
//            .subscribe(onNext: {
//            result in
//            switch result {
//            case .success(let list):
//                productListObserver.onNext(list)
//            case .failure(let error):
//                print(error)
//            }
//        }).disposed(by: disposeBag)
//    }
//    func productHeight(indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//    func productPrice(indexPath: IndexPath) -> Int {
//        return 123
//    }
//}
//protocol Test_Repo{
//    var productListObservable:Observable<Result<[Product],Error>>{get}
//    var requestObserver:AnyObserver<Int>{get}
//}
//final class Test_ProductListRepository:Test_Repo{
//    private enum TransferError:Error{
//        case DecodeError
//        case EncodeError
//    }
//    //MARK: OUTPUT
//    let productListObservable:Observable<Result<[Product],Error>>
//    let requestObserver:AnyObserver<Int>
//    private let apiService:GetProductsList
//    private let streamingProductPrice:StreamingData
//    private let disposeBag:DisposeBag
//    var check = true
//    init(ApiService:GetProductsList,StreamingService:StreamingData) {
//        disposeBag = DisposeBag()
//        apiService = ApiService
//        streamingProductPrice = StreamingService
//        let resultProductSubject = PublishSubject<Result<[Product],Error>>()
//        let resultProductObserver = resultProductSubject.asObserver()
//        productListObservable = resultProductSubject.asObservable()
//        let calculateProductListSubject = PublishSubject<Result<[Product],Error>>()
//        let calculateProductListObservable = calculateProductListSubject.asObservable()
//        let calculateProductListObserver = calculateProductListSubject.asObserver()
//        let requestSubject = PublishSubject<Int>()
//        let requestObservable = requestSubject.asObservable()
//        requestObserver = requestSubject.asObserver()
//
//        requestObservable
//            .flatMap(transferDataToProductList)
//            .scan(Result<[Product],Error>.success([]), accumulator: {
//                aaa,b in
//                let re = self.addResult(before: aaa, after: b)
//                return re
//            })
//            .withUnretained(self)
//            .subscribe(onNext: {
//                Owner,result in
//                print("1")
//                print(Thread.isMainThread)
//                switch result {
//                case .success(_):
//                    calculateProductListObserver.onNext(result)
//                    if self.check{
//                        Owner.streamingProductPrice.controlSocketConnect.onNext(isConnecting.connect)
//                        self.check = false
//                    }
//                case .failure(_):
//                    calculateProductListObserver.onNext(result)
//                }
//            }).disposed(by: disposeBag)
//
//        Observable
//            .combineLatest(calculateProductListObservable, streamingProductPrice.inputDataObservable)
//            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
//            .withUnretained(self)
//            .subscribe(onNext: {
//                (owner,arg1) in
//                let (before, after) = arg1
//                let streamProductPrice = owner.decodeProductPriceData(data: after)
//                let result = owner.sumResult(before: before, after: streamProductPrice)
//                resultProductObserver.onNext(result)
//            }).disposed(by: disposeBag)
//        requestObserver.onNext(1)
//        print("2")
//    }
//    private func addResult(before:Result<[Product],Error>,after:Result<[Product],Error>)->Result<[Product],Error>{
//        switch (before,after){
//        case (.success(var beforeArray),.success(let afterArray)):
//            addArray(array: &beforeArray, addArray: afterArray)
//            return .success(beforeArray)
//        case (.failure(let err), _):
//            return .failure(err)
//        case (_, .failure(let err)):
//            return .failure(err)
//        }
//    }
//
//    private func sumResult(before:Result<[Product],Error>,after:Result<[StreamPrice],Error>)->Result<[Product],Error>{
//
//        switch (before,after){
//        case (.success(var productList),.success(var streamList)):
//            test_changeProductPrice(before: &productList, after: &streamList)
//            return .success(productList)
//        case (.failure(let err), _):
//            return .failure(err)
//        case (_, .failure(let err)):
//            return .failure(err)
//        }
//    }
//    private func decodeProductPriceData(data:Data)->Result<[StreamPrice],Error>{
//        guard let response = try? JSONDecoder().decode([StreamPrice].self, from: data) else{
//            return .failure(Test_ProductListRepository.TransferError.DecodeError)
//        }
//        return .success(response)
//    }
//    func testAdd(){
//        requestObserver.onNext(2)
//    }
//    //    private func changeProductPrice(before:inout [Product],after:[StreamPrice]){
//    //
//    //        for i in 0..<after.count{
//    //            for j in 0..<before.count{
//    //
//    //                if(after[i].product_id == before[j].product_id && after[i].product_price != before[j].product_price){
//    //                    before[j].product_price = after[i].product_price
//    //                }
//    //            }
//    //
//    //        }
//    //    }
//    private func test_changeProductPrice(before:inout [Product],after:inout [StreamPrice]){
//        for num in 0..<after.count{
//            let random = Int.random(in: 0..<50000)
//            after[num].product_price = random
//        }
//        for i in 0..<after.count{
//            for j in 0..<before.count{
//
//                if(after[i].product_id == before[j].product_id && after[i].product_price != before[j].product_price){
//                    before[j].product_price = after[i].product_price
//                }
//            }
//
//        }
//    }
//}
//extension Test_ProductListRepository{
//    private func returnData(lastNumber:Int) -> Observable<Data> {
//        return Observable.create { [weak self] observer in
//            self?.apiService.getProductData(lastNumber:lastNumber) { result in
//                switch result {
//                case let .success(data):
//                    observer.onNext(data)
//                    observer.onCompleted()
//                case let .failure(error):
//                    observer.onError(error)
//                }
//            }
//            return Disposables.create()
//        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
//
//    }
//
//    private func addArray(array:inout [Product],addArray:[Product]){
//        array.append(contentsOf:addArray)
//    }
//
//    private func transferDataToProductList(lastNumber: Int) -> Observable<Result<[Product],Error>>{
//        returnData(lastNumber: lastNumber).withUnretained(self).map { Owner,Data in
//            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
//                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
//            }
//            return .success(response)
//        }.catch{.just(.failure($0))}
//    }
//
//}
////protocol Test_ReturnProductPrice{
////    func returnPriceData(indexNum:Int)->Int
////}
////extension Test_ProductListRepository:Test_ReturnProductPrice{
////    func returnPriceData(indexNum: Int) -> Int {
////        guard indexNum >= products.count else{
////            return 0
////        }
////        return products[indexNum].product_price
////    }
////}
////protocol Test_ProductListRule{
////    func showProductList(lastNumber:Int)->Observable<Result<[Product],Error>>
////    func streamingProductList()->Observable<Result<[Product],Error>>?
////}
////class Test_ProductListUsecase:Test_ProductListRule{
////    let repo:Test_TransferProductsListData
////    init(Repo:Test_TransferProductsListData) {
////        repo = Repo
////    }
////    func showProductList(lastNumber: Int) -> Observable<Result<[Product], Error>> {
////        repo.transferDataToProductList(lastNumber: lastNumber)
////    }
////    func streamingProductList() -> Observable<Result<[Product], Error>>? {
////        repo.streaming()
////    }
////}
////protocol Test_ProductListViewModelProtocol{
////    var listObservable:Observable<[Product]>{get}
////    var requestObserver:AnyObserver<Int>{get}
////}
////class Test_ProductListViewModel:Test_ProductListViewModelProtocol{
////    let usecase:Test_ProductListUsecase
////    let listObservable: Observable<[Product]>
////    let requestObserver: AnyObserver<Int>
////    init(Usecase:Test_ProductListUsecase) {
////        self.usecase = Usecase
////        let listSubject = PublishSubject<[Product]>()
////        let requestSubject = PublishSubject<Int>()
////        requestObserver = requestSubject.asObserver()
////        listObservable = listSubject.asObservable()
////        self.usecase.streamingProductList()?.subscribe(onNext: { result in
////            switch result{
////            case .success(let lists):
////                listSubject.asObserver().onNext(lists)
////            case .failure(let error):
////                print(error)
////            }
////        })
////    }
////}
////protocol Test_ReturnProductPriceRule{
////    func rule_returnProductPrice(index:IndexPath)->Int
////}
////class Test_ProductPriceUsecase:Test_ReturnProductPriceRule{
////    let repo:Test_ReturnProductPrice
////    init(Repo:Test_ReturnProductPrice) {
////        repo = Repo
////    }
////    func rule_returnProductPrice(index: IndexPath) -> Int {
////        repo.returnPriceData(indexNum: index.item)
////    }
////}
////
////protocol Test_ReturnProductPriceViewModel{
////    func viewModel_returnProductPrice(index:IndexPath)->Int
////}
////class Test_CollectionViewModel:Test_ReturnProductPriceViewModel{
////    let usecase:Test_ReturnProductPriceRule
////    init(Usecase:Test_ReturnProductPriceRule) {
////        usecase = Usecase
////    }
////    func viewModel_returnProductPrice(index: IndexPath) -> Int {
////        usecase.rule_returnProductPrice(index: index)
////    }
////
////}
