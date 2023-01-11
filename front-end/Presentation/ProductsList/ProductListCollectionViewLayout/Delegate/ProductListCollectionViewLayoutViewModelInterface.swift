//
//  ProductListCollectionViewLayoutViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation

protocol ReturnImageHeightWhenPrepareCollectionViewLayoutInterface{
    func returnImageHeightFromViewModel(index:IndexPath)->CGFloat
}
