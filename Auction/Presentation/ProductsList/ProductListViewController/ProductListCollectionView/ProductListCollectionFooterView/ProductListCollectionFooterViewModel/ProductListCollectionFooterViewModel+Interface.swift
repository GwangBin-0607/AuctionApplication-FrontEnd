//
//  ProductListCollectionFooterViewModel+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/26.
//

import Foundation
import RxSwift
class ProductListCollectionFooterViewModel:Pr_ProductListCollectionFooterViewModel{
    let activity: Observable<Bool>
    let activityObserver: AnyObserver<Bool>
    init() {
        let activitySubject = PublishSubject<Bool>()
        activity = activitySubject.asObservable()
        activityObserver = activitySubject.asObserver()
    }
}
