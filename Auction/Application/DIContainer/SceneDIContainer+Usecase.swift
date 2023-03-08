//
//  SceneDIContainer+Usecase.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
//MARK: Usecase
extension SceneDIContainer{
    func returnProductListUsecaseInterface(httpService:GetProductsList,ImageHeightRepository:ProductImageRepositoryInterface,socketNetworkInterface:SocketNetworkInterface)->Pr_ProductListWithImageHeightUsecase{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(httpService: httpService,socketNetworkInterface:socketNetworkInterface), ImageHeightRepo: ImageHeightRepository)
    }
     func returnProductImageLoadUsecaseInterface(ImageLoadRepository:ProductImageRepositoryInterface)->Pr_ProductImageLoadUsecase{
        ProductImageLoadUseCase(productsImageRepository: ImageLoadRepository)
    }
    func returnDetailProductUsecase()->Pr_DetailProductUsecase{
        DetailProductUsecase(detailProductRepository: returnDetailProductRepository())
    }
}
