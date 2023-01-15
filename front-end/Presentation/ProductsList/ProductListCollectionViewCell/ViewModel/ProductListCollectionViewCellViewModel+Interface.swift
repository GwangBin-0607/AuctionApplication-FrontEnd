//
//  ProductListCollectionViewCellViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift

class ProductListCollectionViewCellViewModel{
    let imageUsecase:Pr_ProductImageLoadUsecase
    init(ImageUsecase:Pr_ProductImageLoadUsecase) {
        self.imageUsecase = ImageUsecase
    }
}
extension ProductListCollectionViewCellViewModel:Pr_ProductListCollectionViewCellViewModel{
    func returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag>{
        return imageUsecase.returnImage(productId: productId, imageURL: imageURL)
    }
}
