//
//  ProductListCollectionViewCellViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift
struct ResultCellImageTag {
    let result:Result<UIImage,HTTPError>
    let tag:Int
}
struct CellImageTag{
    let image:UIImage?
    let tag:Int
}

protocol Pr_ProductListCollectionViewCellViewModel{
    func returnImage(product_image:Image?,tag:Int)->Observable<ResultCellImageTag>
}
