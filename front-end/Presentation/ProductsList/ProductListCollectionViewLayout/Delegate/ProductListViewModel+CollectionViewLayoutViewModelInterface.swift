//
//  ProductListViewModel+CollectionViewLayoutViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation

extension ProductListViewModel:ReturnImageHeightWhenPrepareCollectionViewLayoutInterface{
    func returnImageHeightFromViewModel(index: IndexPath) -> CGFloat {
        do{
            let product = try products.value()
            return product[index.item].imageHeight ?? 150
        }catch{
            return 150
        }
    }
}
