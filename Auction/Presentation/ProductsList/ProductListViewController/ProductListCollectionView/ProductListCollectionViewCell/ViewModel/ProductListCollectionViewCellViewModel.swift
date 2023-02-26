//
//  ProductListCollectionViewCellViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import RxSwift

final class ProductListCollectionViewCellViewModel{
    let imageLoadSerialQueue:DispatchQueue
    let imageUsecase:Pr_ProductImageLoadUsecase
    private let downImageSize:CGFloat
    let titleObservable: Observable<(String,Int)>
    let dataObserver: AnyObserver<Product>
    let priceObservable: Observable<(String,Int)>
    let beforePrice: Observable<(String,Int)>
    let imageObservable: Observable<CellImageTag>
    let checkObservable: Observable<(UIImage?,Int)>
    let animationObserver: AnyObserver<AnimtionValue?>
    let textColorObservable: Observable<(Bool,Int)>
    let triggerAnimation: Observable<(Void,Int)>
    private let disposeBag:DisposeBag
    init(ImageUsecase:Pr_ProductImageLoadUsecase,downImageSize:CGFloat) {
        disposeBag = DisposeBag()
        self.imageUsecase = ImageUsecase
        self.downImageSize = downImageSize
        self.imageLoadSerialQueue = DispatchQueue(label: "ImageLoad")
        let titleSubject = PublishSubject<(String,Int)>()
        let priceSubject = PublishSubject<(String,Int)>()
        let beforePriceSubject = PublishSubject<(String,Int)>()
        let imageSubject = PublishSubject<CellImageTag>()
        let checkSubject = PublishSubject<(UIImage?,Int)>()
        let dataSubject = PublishSubject<Product>()
        let animationSubject = PublishSubject<AnimtionValue?>()
        let textColorSubject = PublishSubject<(Bool,Int)>()
        let triggerSubject = PublishSubject<(Void,Int)>()
        triggerAnimation = triggerSubject.asObservable()
        textColorObservable = textColorSubject.asObservable()
        animationObserver = animationSubject.asObserver()
        titleObservable = titleSubject.asObservable()
        dataObserver = dataSubject.asObserver()
        priceObservable = priceSubject.asObservable()
        beforePrice = beforePriceSubject.asObservable()
        imageObservable = imageSubject.asObservable()
        checkObservable = checkSubject.asObservable()
        let titleObserver = titleSubject.asObserver()
        let priceObserver = priceSubject.asObserver()
        let beforePriceObserver = beforePriceSubject.asObserver()
        let imageObserver = imageSubject.asObserver()
        let checkObserver = checkSubject.asObserver()
        let textColorObserver = textColorSubject.asObserver()
        let triggerObserver = triggerSubject.asObserver()
        dataSubject.asObservable().withUnretained(self).do(onNext: {
            owner,product in
            titleObserver.onNext((product.product_name,product.product_id))
            priceObserver.onNext((owner.decorationPrice(price:product.product_price.price),product.product_id))
            if product.checkUpDown.state{
                checkObserver.onNext((UIImage(named: "upState"),product.product_id))
                textColorObserver.onNext((true,product.product_id))
            }else{
                checkObserver.onNext((UIImage(named: "nothing"),product.product_id))
                textColorObserver.onNext((false,product.product_id))
            }
            beforePriceObserver.onNext((owner.decorationBeforePrice(beforePrice: (product.product_price.beforePrice)),product.product_id))
        }).flatMap({
            owner,product in
            owner.returnImage(product_image: product.mainImage, tag: product.product_id)
        }).map({
            cellImageTag in
            var returnImage:UIImage?
            switch cellImageTag.result {
            case .success(let image):
                returnImage = image
            case .failure(let error):
                if error == .NoImageData || error == .RequestError{
                    returnImage = UIImage(named: "NoImage")
                }else{
                    returnImage = UIImage()
                }
            }
            return CellImageTag(image: returnImage, tag: cellImageTag.tag)
        }).observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
            cellImageTag in
            imageObserver.onNext(cellImageTag)
        }).disposed(by: disposeBag)
        
        animationSubject.asObservable().withUnretained(self).subscribe(onNext: {
            owner,animationValue in
            if let animationValue = animationValue{
                priceObserver.onNext((owner.decorationPrice(price:animationValue.price),animationValue.product_id))
                beforePriceObserver.onNext((owner.decorationBeforePrice(beforePrice: (animationValue.beforePrice)),animationValue.product_id))
                if animationValue.state{
                    checkObserver.onNext((UIImage(named: "upState"),animationValue.product_id))
                    textColorObserver.onNext((true,animationValue.product_id))
                }else{
                    checkObserver.onNext((UIImage(named: "nothing"),animationValue.product_id))
                    textColorObserver.onNext((false,animationValue.product_id))
                }
                triggerObserver.onNext(((),animationValue.product_id))
            }
        }).disposed(by: disposeBag)
    }
    
    
    private func decorationPrice(price:Int)->String{
        String(price)+"₩"
    }
    private func decorationBeforePrice(beforePrice:Int)->String{
        "전일대비 : +"+String(beforePrice)+"₩"
    }
}
extension ProductListCollectionViewCellViewModel:Pr_ProductListCollectionViewCellViewModel{
    
    func returnImage(product_image:Image?,tag:Int) -> Observable<ResultCellImageTag>{
        return imageUsecase.returnImage(product_image: product_image,imageWidth: downImageSize,tag: tag)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
