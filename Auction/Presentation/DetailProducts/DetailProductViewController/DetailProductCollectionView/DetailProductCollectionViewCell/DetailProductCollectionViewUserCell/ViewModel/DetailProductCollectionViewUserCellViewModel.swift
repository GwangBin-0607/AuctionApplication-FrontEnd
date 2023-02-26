//
//  DetailProductCollectionViewUserCellViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/24.
//

import Foundation
import RxSwift

final class DetailProductCollectionViewUserCellViewModel{
    let imageLoadSerialQueue:DispatchQueue
    let imageUsecase:Pr_ProductImageLoadUsecase
    let userNameObservable: Observable<String?>
    let userImageObservable: Observable<CellImageTag>
    let detailUserObserver: AnyObserver<UserWithTag>
    private let downImageSize:CGFloat
    private let disposeBag:DisposeBag
    init(ImageUsecase:Pr_ProductImageLoadUsecase,downImageSize:CGFloat) {
        disposeBag = DisposeBag()
        self.imageUsecase = ImageUsecase
        self.downImageSize = downImageSize
        self.imageLoadSerialQueue = DispatchQueue(label: "ImageLoad")
        let detailUserSubject = PublishSubject<UserWithTag>()
        let userNameSubject = PublishSubject<String?>()
        let userImageSubject = PublishSubject<CellImageTag>()
        userNameObservable = userNameSubject.asObservable()
        userImageObservable = userImageSubject.asObservable()
        detailUserObserver = detailUserSubject.asObserver()
        let userNameObserver = userNameSubject.asObserver()
        let userImageObserver = userImageSubject.asObserver()
        detailUserSubject.do(onNext: {
            user in
            userNameObserver.onNext(user.user?.user_name)
        }).withUnretained(self).flatMap({
            owner,userImageTag in
            owner.returnImage(productImageWithTag: ProductImagesWithTag(product_image: userImageTag.user?.returnMainUserImage(), tag: userImageTag.tag))
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
            userImageObserver.onNext(cellImageTag)
        }).disposed(by: disposeBag)
        
    }
}
extension DetailProductCollectionViewUserCellViewModel:Pr_DetailProductCollectionViewUserCellViewModel{
    func returnImage(productImageWithTag:ProductImagesWithTag) -> Observable<ResultCellImageTag>{
        return imageUsecase.returnImage(product_image: productImageWithTag.product_image,imageWidth: downImageSize,tag: productImageWithTag.tag)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
