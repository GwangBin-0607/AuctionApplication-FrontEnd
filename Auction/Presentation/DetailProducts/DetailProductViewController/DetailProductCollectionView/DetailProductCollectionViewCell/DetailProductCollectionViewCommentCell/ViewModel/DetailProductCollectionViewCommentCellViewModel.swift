//
//  DetailProductCollectionViewCommentCellViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/26.
//

import Foundation
import RxSwift

class DetailProductCollectionViewCommentCellViewModel:Pr_DetailProductCollectionViewCommentCellViewModel{
    let registerObservable: Observable<String>
    let priceNameObservable: Observable<String>
    let originalPriceObservable: Observable<String>
    let commentObservable: Observable<String>
    let detailProductObserver: AnyObserver<DetailProductComment?>
    private let disposeBag:DisposeBag
    init() {
        disposeBag = DisposeBag()
        let registerSubject = PublishSubject<String>()
        let productNameSubject = PublishSubject<String>()
        let originalPriceSubject = PublishSubject<Int>()
        let commentSubject = PublishSubject<String>()
        let detailProductSubject = PublishSubject<DetailProductComment?>()
        let registerObserver = registerSubject.asObserver()
        registerObservable = registerSubject.asObservable()
        let priceNameObserver = productNameSubject.asObserver()
        priceNameObservable = productNameSubject.asObservable()
        let originalPriceObserver = originalPriceSubject.asObserver()
        originalPriceObservable = originalPriceSubject.asObservable().map({
            price in
            "시작가 : \(price)₩"
        })
        let commentObserver = commentSubject.asObserver()
        commentObservable = commentSubject.asObservable()
        detailProductObserver = detailProductSubject.asObserver()
        detailProductSubject.asObservable().withUnretained(self).subscribe(onNext: {
            owner,comment in
            if let comment = comment{
                registerObserver.onNext(comment.registerTime)
                commentObserver.onNext(comment.comment)
                originalPriceObserver.onNext(comment.original_price)
                priceNameObserver.onNext(comment.product_name)
            }
        }).disposed(by:disposeBag)
    }
}
