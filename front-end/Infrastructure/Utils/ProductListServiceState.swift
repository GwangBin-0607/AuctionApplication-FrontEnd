//
//  ProductListServiceState.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/05.
//

import Foundation
protocol ProductListServiceStateInterface{
    func getServiceState()->Int8
}
protocol HTTPProductListServiceInterface:ProductListServiceStateInterface{
    func updateHttpState()
}
protocol StreamProductListServiceInterface:ProductListServiceStateInterface{
    func updateStreamState()
    func isUpdated()->Bool
}
final class ProductListServiceState:HTTPProductListServiceInterface,StreamProductListServiceInterface{
    private var httpState:Int8 = 0
    private var streamState:Int8 = 0
    func updateHttpState() {
        httpState += 1
    }
    func getServiceState() -> Int8 {
        httpState
    }
    func updateStreamState() {
        streamState += 1
    }
    func isUpdated() -> Bool {
        httpState == streamState
    }
}
