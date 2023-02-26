//
//  ProductListCollectionViewCellViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift
struct ResultCellImageTag {
    let result:Result<UIImage,HTTPError>
    let tag:Int
}
struct CellImageTag{
    let image:UIImage?
    let tag:Int
}

protocol Pr_ProductListCollectionViewCellViewModel{
    var titleObservable:Observable<(String,Int)>{get}
    var priceObservable:Observable<(String,Int)>{get}
    var checkObservable:Observable<(UIImage?,Int)>{get}
    var imageObservable:Observable<CellImageTag>{get}
    var beforePrice:Observable<(String,Int)>{get}
    var textColorObservable:Observable<(Bool,Int)>{get}
    var dataObserver:AnyObserver<Product>{get}
    var animationObserver:AnyObserver<AnimtionValue?>{get}
    var triggerAnimation:Observable<(Void,Int)>{get}
}
