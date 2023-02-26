//
//  Pr_DetailProductCollectionViewImageCellViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/19.
//

import Foundation
import RxSwift
struct ProductImagesWithTag{
    let product_image:Image?
    let tag:Int
}
protocol Pr_DetailProductCollectionViewImageCellViewModel {
    func returnImage(productImageWithTag:ProductImagesWithTag) -> Observable<CellImageTag>
}
