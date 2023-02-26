//
//  DetailProductCollectionViewImageCellViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/19.
//

import Foundation
import RxSwift
final class DetailProductCollectionViewImageCellViewModel{
    let imageLoadSerialQueue:DispatchQueue
    let imageUsecase:Pr_ProductImageLoadUsecase
    let observer: AnyObserver<ProductImagesWithTag>
    let cellImageTag: Observable<CellImageTag>
    private let downImageSize:CGFloat
    private let disposeBag:DisposeBag
    init(ImageUsecase:Pr_ProductImageLoadUsecase,downImageSize:CGFloat) {
        disposeBag = DisposeBag()
        self.imageUsecase = ImageUsecase
        self.downImageSize = downImageSize
        self.imageLoadSerialQueue = DispatchQueue(label: "ImageLoad")
        let subject = PublishSubject<ProductImagesWithTag>()
        let cellImageTagSubject = PublishSubject<CellImageTag>()
        cellImageTag = cellImageTagSubject.asObservable()
        let cellImageTagObserver = cellImageTagSubject.asObserver()
        observer = subject.asObserver()
        subject.asObservable().withUnretained(self).flatMap({
            owner,aa in
            owner.returnImage(productImageWithTag: aa)
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
            cellImageTagObserver.onNext(cellImageTag)
        }).disposed(by: disposeBag)
        
    }
}
extension DetailProductCollectionViewImageCellViewModel:Pr_DetailProductCollectionViewImageCellViewModel{
    func returnImage(productImageWithTag:ProductImagesWithTag) -> Observable<ResultCellImageTag>{
        return imageUsecase.returnImage(product_image: productImageWithTag.product_image,imageWidth: downImageSize,tag: productImageWithTag.tag)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
