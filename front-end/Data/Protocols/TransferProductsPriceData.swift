////
////  TransferDataToProductPrice.swift
////  front-end
////
////  Created by 안광빈 on 2022/11/18.
////
//
//import Foundation
import RxSwift
//protocol TransferProductPriceDataOutput{
//    func transferPriceToData(output productPrice:StreamPrice)
//}
//
//protocol TransferProductPriceDataInput{
//    func transferDataToPrice()-> Observable<Result<[StreamPrice],Error>>
//}
protocol ObserverSocketState{
    func streamState(state:isConnecting)
    func observableSteamState()->Observable<isConnecting>
}
