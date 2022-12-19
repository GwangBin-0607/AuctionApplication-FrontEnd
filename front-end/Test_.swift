//
//  Test_.swift
//  front-end
//
//  Created by 안광빈 on 2022/12/20.
//

import Foundation
import RxSwift
protocol Test_StreamProductPrice{
    var streamObservable:Observable<Result<[Product],Error>>?{get}
}
final class Test_ProductListRepository:Test_StreamProductPrice{
    private enum TransferError:Error{
        case DecodeError
        case EncodeError
    }
    private var products:[Product]=[]
    private let apiService:GetProductsList
    private let streamingProductPrice:StreamingData
    var streamObservable: Observable<Result<[Product],Error>>?
    init(ApiService:GetProductsList,StreamingService:StreamingData) {
        apiService = MockProductsListAPI()
        streamingProductPrice = StreamingService
        streamObservable = streamingProductPrice.inputDataObservable.map(decodeProductPriceData)
    }
    private func decodeProductPriceData(data:Data)->Result<[Product],Error>{
        guard let response = try? JSONDecoder().decode([Product].self, from: data) else{
            return .failure(Test_ProductListRepository.TransferError.DecodeError)
        }
        changeProductPrice(before: &self.products, after: response)
        return .success(self.products)
    }
    private func changeProductPrice(before:inout [Product],after:[Product]){
        for i in 0..<after.count{
            if(after[i].product_id == before[i].product_id && after[i].product_price != before[i].product_price){
                before[i].product_price = after[i].product_price
            }
        }
    }
}

protocol Test_ReturnProductPrice{
    func returnPriceData(indexNum:Int)->Int
}
extension Test_ProductListRepository:Test_ReturnProductPrice{
    func returnPriceData(indexNum: Int) -> Int {
        guard indexNum >= products.count else{
            return 0
        }
        return products[indexNum].product_price
    }
}
protocol Test_TransferProductsListData:TransferProductsListData{
    func streaming() -> Observable<Result<[Product],Error>>?
}
extension Test_ProductListRepository:Test_TransferProductsListData{
    private func returnData(lastNumber:Int) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            self?.apiService.getProductData(lastNumber:lastNumber) { result in
                switch result {
                case let .success(data):
                    observer.onNext(data)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    
    func transferDataToProductList(lastNumber: Int) -> Observable<Result<[Product],Error>>{
        returnData(lastNumber: lastNumber).withUnretained(self).map { Owner,Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
            Owner.addArray(array: &Owner.products, addArray: response)
            return .success(Owner.products)
        }.catch{.just(.failure($0))}
    }
    func streaming() -> Observable<Result<[Product], Error>>? {
        return self.streamObservable
    }
    
    private func addArray(array:inout [Product],addArray:[Product]){
        array.append(contentsOf:addArray)
    }
}
protocol Test_ProductListRule{
    func showProductList(lastNumber:Int)->Observable<Result<[Product],Error>>
    func streamingProductList()->Observable<Result<[Product],Error>>?
}
class Test_ProductListUsecase:Test_ProductListRule{
    let repo:Test_TransferProductsListData
    init(Repo:Test_TransferProductsListData) {
        repo = Repo
    }
    func showProductList(lastNumber: Int) -> Observable<Result<[Product], Error>> {
        repo.transferDataToProductList(lastNumber: lastNumber)
    }
    func streamingProductList() -> Observable<Result<[Product], Error>>? {
        repo.streaming()
    }
}
protocol Test_ProductListViewModelProtocol{
    var listObservable:Observable<[Product]>{get}
    var requestObserver:AnyObserver<Int>{get}
}
class Test_ProductListViewModel:Test_ProductListViewModelProtocol{
    let usecase:Test_ProductListUsecase
    let listObservable: Observable<[Product]>
    let requestObserver: AnyObserver<Int>
    init(Usecase:Test_ProductListUsecase) {
        self.usecase = Usecase
        let listSubject = PublishSubject<[Product]>()
        let requestSubject = PublishSubject<Int>()
        requestObserver = requestSubject.asObserver()
        listObservable = listSubject.asObservable()
        self.usecase.streamingProductList()?.subscribe(onNext: { result in
            switch result{
            case .success(let lists):
                listSubject.asObserver().onNext(lists)
            case .failure(let error):
                print(error)
            }
        })
    }
}
protocol Test_ReturnProductPriceRule{
    func rule_returnProductPrice(index:IndexPath)->Int
}
class Test_ProductPriceUsecase:Test_ReturnProductPriceRule{
    let repo:Test_ReturnProductPrice
    init(Repo:Test_ReturnProductPrice) {
        repo = Repo
    }
    func rule_returnProductPrice(index: IndexPath) -> Int {
        repo.returnPriceData(indexNum: index.item)
    }
}

protocol Test_ReturnProductPriceViewModel{
    func viewModel_returnProductPrice(index:IndexPath)->Int
}
class Test_CollectionViewModel:Test_ReturnProductPriceViewModel{
    let usecase:Test_ReturnProductPriceRule
    init(Usecase:Test_ReturnProductPriceRule) {
        usecase = Usecase
    }
    func viewModel_returnProductPrice(index: IndexPath) -> Int {
        usecase.rule_returnProductPrice(index: index)
    }
    
}
