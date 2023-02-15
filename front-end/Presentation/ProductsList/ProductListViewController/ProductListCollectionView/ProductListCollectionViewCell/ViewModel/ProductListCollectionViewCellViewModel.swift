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
    private let imageWidth:CGFloat
    init(ImageUsecase:Pr_ProductImageLoadUsecase,ImageWidth:CGFloat) {
        self.imageUsecase = ImageUsecase
        self.imageWidth = ImageWidth
        self.imageLoadSerialQueue = DispatchQueue(label: "ImageLoad")
    }
}
extension ProductListCollectionViewCellViewModel:Pr_ProductListCollectionViewCellViewModel{
    func returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag>{
        return imageUsecase.returnImage(productId: productId, imageURL: imageURL,imageWidth: imageWidth)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
