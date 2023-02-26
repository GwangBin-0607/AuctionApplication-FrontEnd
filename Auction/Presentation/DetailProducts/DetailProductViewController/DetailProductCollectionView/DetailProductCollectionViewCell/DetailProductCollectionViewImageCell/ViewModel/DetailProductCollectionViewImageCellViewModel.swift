//
//  DetailProductCollectionViewImageCellViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/19.
//

import Foundation
import RxSwift
final class DetailProductCollectionViewImageCellViewModel{
    let imageLoadSerialQueue:DispatchQueue
    let imageUsecase:Pr_ProductImageLoadUsecase
    private let downImageSize:CGFloat
    init(ImageUsecase:Pr_ProductImageLoadUsecase,downImageSize:CGFloat) {
        self.imageUsecase = ImageUsecase
        self.downImageSize = downImageSize
        self.imageLoadSerialQueue = DispatchQueue(label: "ImageLoad")
        
    }
}
extension DetailProductCollectionViewImageCellViewModel:Pr_DetailProductCollectionViewImageCellViewModel{
    func returnImage(productImageWithTag:ProductImagesWithTag) -> Observable<CellImageTag>{
        return imageUsecase.returnImage(product_image: productImageWithTag.product_image,imageWidth: downImageSize,tag: productImageWithTag.tag)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
