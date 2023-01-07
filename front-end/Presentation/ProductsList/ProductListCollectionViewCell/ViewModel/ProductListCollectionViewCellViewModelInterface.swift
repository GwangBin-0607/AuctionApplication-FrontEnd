//
//  ProductListCollectionViewCellViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift
struct CellImageTag {
    let result:Result<UIImage,Error>
    let tag:Int
}

protocol ProductListCollectionViewCellViewModelInterface{
    func returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>
}
