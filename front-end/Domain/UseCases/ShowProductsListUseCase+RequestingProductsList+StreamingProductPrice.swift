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
    private let fetchingRepository:TransferProductsListData
    private let productPriceRepository:TransferProductPriceDataInput&ObserverSocketState
    init(ProductsListRepository:TransferProductsListData,ProductPriceRepository:TransferProductPriceDataInput&ObserverSocketState) {
        self.fetchingRepository = ProductsListRepository
        self.productPriceRepository = ProductPriceRepository
    }
}
extension ShowProductsListUseCase:RequestingProductsList{
    
    func request(lastNumber:Int) -> Observable<Result<[Product],Error>> {
        return fetchingRepository.transferDataToProductList(lastNumber: lastNumber)
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
