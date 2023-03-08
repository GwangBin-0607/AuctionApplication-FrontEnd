//
//  SceneDIContainer+Infrastructure.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
//MARK: Infrastructure
extension SceneDIContainer{
     func returnHTTPServices()->GetProductsList&GetProductImage&GetDetailProduct&GetCurrentProductPrice{
         return ProductHTTP(ProductListURL: configure.getProductListURL(), ProductImageURL: configure.getProductImageURL(),ProductDetailURL: configure.getProductDetailURL(),ProductCurrentPriceURL: configure.getProductCurrentPriceURL())
    }
     func returnStreamingService()->SocketNetworkInterface{
         SocketNetwork(hostName: configure.getSocketHost(), portNumber: configure.getSocketPort())
    }
}
