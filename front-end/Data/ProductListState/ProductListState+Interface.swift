//
//  ProductListState+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation

final class ProductListState:ProductListStateInterface{
    func updateState(transfer: TCPStreamDataTransfer, streamService: SocketNetworkInterface) {
        httpServiceState += 1 
    }
    private var httpServiceState:Int = 0
    private var streamServiceState:Int = 0
}
