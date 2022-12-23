////
////  ProductPriceRepository+TransferDataToProductPrice.swift
////  front-end
////
////  Created by 안광빈 on 2022/11/18.
////
//
//import Foundation
//import RxSwift
//class ProductPriceRepository{
//    private enum TransferError:Error{
//        case DecodeError
//        case EncodeError
//    }
//    private let streamingProductPrice:StreamingData
//    init(StreamingService:StreamingData) {
//        self.streamingProductPrice = StreamingService
//    }
//}
//extension ProductPriceRepository:TransferProductPriceDataOutput,TransferProductPriceDataInput{
//    func transferDataToPrice() -> Observable<Result<[StreamPrice],Error>> {
//        return streamingProductPrice.inputDataObservable.map { data in
//            guard let response = try? JSONDecoder().decode([StreamPrice].self, from: data) else{
//                return .failure(ProductPriceRepository.TransferError.DecodeError)
//            }
//            return .success(response)
//        }
//    }
//    func transferPriceToData(output productPrice:StreamPrice){
//        let jsonEncoder = JSONEncoder()
//        do{
//            let data = try jsonEncoder.encode(productPrice)
//            streamingProductPrice.outputDataObserver.onNext(data)
//        }catch{
//            print(error)
//            streamingProductPrice.outputDataObserver.onNext(nil)
//        }
//    }
//}
//extension ProductPriceRepository:ObserverSocketState{
//    func streamState(state: isConnecting) {
//        streamingProductPrice.controlSocketConnect.onNext(state)
//    }
//    
//    func observableSteamState() -> Observable<isConnecting> {
//        return streamingProductPrice.isSocketConnect
//    }
//    
//    
//}
