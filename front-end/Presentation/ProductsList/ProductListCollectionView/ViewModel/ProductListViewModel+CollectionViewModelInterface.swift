//
//  ProductListViewModel+CollectionViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation

extension ProductListViewModel:ProductListCollectionViewModelInterface{
    func returnPrice(index: IndexPath) -> Int {
        do{
            let product = try products.value()
           return product[index.item].product_price
            
        }catch{
           return 0
        }
    }
}
