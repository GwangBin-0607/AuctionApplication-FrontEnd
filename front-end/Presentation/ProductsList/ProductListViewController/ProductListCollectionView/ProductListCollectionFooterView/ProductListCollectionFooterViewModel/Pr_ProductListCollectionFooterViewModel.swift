//
//  ProductListCollectionFooterViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/26.
//

import Foundation
import RxSwift
protocol Pr_ProductListCollectionFooterViewModel{
    var activity:Observable<Bool>{get}
    var activityObserver:AnyObserver<Bool>{get}
}
