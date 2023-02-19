//
//  ProductListCollectionViewCellViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift
struct CellImageTag {
    let result:Result<UIImage,HTTPError>
    let tag:Int
}

protocol Pr_ProductListCollectionViewCellViewModel{
    func returnImage(product_image:Product_Images?,tag:Int)->Observable<CellImageTag>
}
