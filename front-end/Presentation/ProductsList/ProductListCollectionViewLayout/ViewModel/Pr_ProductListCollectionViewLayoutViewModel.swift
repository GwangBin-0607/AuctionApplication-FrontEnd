//
//  ProductListCollectionViewLayoutViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation

protocol Pr_Out_ProductListCollectionViewLayoutViewModel{
    func returnImageHeightFromViewModel(index:IndexPath)->CGFloat
}
extension ProductListCollectionViewModel:Pr_Out_ProductListCollectionViewLayoutViewModel{
    func returnImageHeightFromViewModel(index: IndexPath) -> CGFloat {
        do{
            let product = try products.value()
            return product[index.item].imageHeight
        }catch{
            return 150
        }
    }
}
