//
//  FetchProductListUseCase.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

typealias ShowProductsList = RequestingProductsList&StreamingProductPriceInput
final class ShowProductsListUseCase{
    private let fetchingRepository:FetchingProductsListData
    private let productPriceRepository:TransferProductPriceDataInput&ObserverSocketState
    init(ProductsListRepository:FetchingProductsListData,ProductPriceRepository:TransferProductPriceDataInput&ObserverSocketState) {
        self.fetchingRepository = ProductsListRepository
        self.productPriceRepository = ProductPriceRepository
    }
}
extension ShowProductsListUseCase:RequestingProductsList{
    
    func request(lastNumber:Int) -> Observable<Result<[Product],Error>> {
        return fetchingRepository.returnData(lastNumber: lastNumber)
            .map { Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
                return .success(response)
            }.catch{.just(.failure($0))}
    }
}
extension ShowProductsListUseCase:StreamingProductPriceInput{
    
    func connectingNetwork(state:isConnecting) {
        productPriceRepository.streamState(state: state)
    }
    func returningInputObservable() -> Observable<Result<[StreamPrice], Error>> {
        productPriceRepository.transferDataToPrice()
    }
    func returningSocketState() -> Observable<isConnecting> {
        productPriceRepository.observableSteamState()
    }
}
