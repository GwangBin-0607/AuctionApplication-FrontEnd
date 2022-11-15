//
//  ProductListCollectionViewLayout.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/03.
//

import Foundation
import UIKit
import RxSwift

class ProductListCollectionViewLayout:UICollectionViewLayout{
    private let disposeBag=DisposeBag()
    override init() {
        super.init()
        bindingViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func bindingViewModel(){
    }
    
    
}

