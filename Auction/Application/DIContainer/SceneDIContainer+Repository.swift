//
//  SceneDIContainer+Repository.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
//MARK: Repository
extension SceneDIContainer{
     func returnProductCacheImageRepository()->ProductImageCacheRepositoryInterface{
        ProductImageCacheRepository()
    }
    func returnProductsImageRepository(httpService:GetProductImage)->ProductImageRepositoryInterface{
        return ProductImageRepository(ImageServer: httpService,CacheRepository: returnProductCacheImageRepository(),httpTransfer: returnHTTPImageDataTransfer())
    }
    func returnProductListRepositoryInterface(httpService:GetProductsList,socketNetworkInterface:SocketNetworkInterface)->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: httpService, StreamingService:socketNetworkInterface,TCPStreamDataTransfer: returnTCPStreamDataTransferInterface(),ProductListState: returnProductListState(),HTTPDataTransfer: returnHTTPDataTransfer())
    }
     func returnProductListState()->ProductListStateInterface{
        ProductListState()
    }
     func returnTCPStreamDataTransferInterface()->TCPStreamDataTransferInterface{
        TCPStreamDataTransfer(inputStreamDataTransfer: returnInputStreamDataTransfer(), outputStreamDataTransfer: returnOutputStreamDataTransfer(), outputStreamCompletionHandler: returnOutputStreamCompletionHandler())
    }
     func returnInputStreamDataTransfer()->InputStreamDataTransferInterface{
        InputStreamDataTransfer()
    }
     func returnOutputStreamDataTransfer()->OutputStreamDataTransferInterface{
        OutputStreamDataTransfer()
    }
    func returnHTTPImageDataTransfer()->Pr_HTTPDataTransferProductImage{
        HTTPDataTransferProductImage()
    }
     func returnOutputStreamCompletionHandler()->OutputStreamCompletionHandlerInterface{
        OutputStreamCompletionHandler()
    }
     func returnHTTPDataTransfer()->Pr_HTTPDataTransferProductList{
        HTTPDataTransferProductList()
    }
    func returnHTTPDataTransferDetailProduct()->Pr_HTTPDataTransferDetailProduct{
        HTTPDataTransferDetailProduct()
    }
    func returnDetailProductRepository()->Pr_DetailProductRepository{
        DetailProductRepository(httpService: returnHTTPServices(), httpDetailProductTransfer: returnHTTPDataTransferDetailProduct())
    }
}
