//
//  ProductListState+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation
import RxSwift
final class ProductListState:ProductListStateInterface{
    func updateTCPState(){
        streamServiceState += 1
    }
   
    func updateHTTPState() {
        httpServiceState += 1
        
    }
    func returnTCPState() -> Int8 {
        streamServiceState
    }
    func returnHttpState() -> Int8 {
        httpServiceState
    }
    private var httpServiceState:Int8 = 0
    private var streamServiceState:Int8 = 0
}
