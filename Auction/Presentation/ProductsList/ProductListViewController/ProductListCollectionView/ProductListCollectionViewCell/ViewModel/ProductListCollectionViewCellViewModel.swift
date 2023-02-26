//
//  ProductListCollectionViewCellViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift

class ProductListCollectionViewCellViewModel{
    let imageLoadSerialQueue:DispatchQueue
    let imageUsecase:Pr_ProductImageLoadUsecase
    private let downImageSize:CGFloat
    init(ImageUsecase:Pr_ProductImageLoadUsecase,downImageSize:CGFloat) {
        self.imageUsecase = ImageUsecase
        self.downImageSize = downImageSize
        self.imageLoadSerialQueue = DispatchQueue(label: "ImageLoad")
    }
}
extension ProductListCollectionViewCellViewModel:Pr_ProductListCollectionViewCellViewModel{
    func returnImage(product_image:Image?,tag:Int) -> Observable<ResultCellImageTag>{
        return imageUsecase.returnImage(product_image: product_image,imageWidth: downImageSize,tag: tag)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
