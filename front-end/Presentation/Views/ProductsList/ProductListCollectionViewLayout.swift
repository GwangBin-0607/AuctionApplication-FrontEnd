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
    private let disposeBag:DisposeBag
    override init() {
        disposeBag = DisposeBag()
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

