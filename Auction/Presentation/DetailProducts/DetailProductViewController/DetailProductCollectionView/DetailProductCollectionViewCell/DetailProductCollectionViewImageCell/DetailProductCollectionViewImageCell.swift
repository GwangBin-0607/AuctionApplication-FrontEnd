//
//  DetailProductCollectionViewImageCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/18.
//

import UIKit
import RxSwift
final class DetailProductCollectionViewImageCell:UICollectionViewCell{
    let imageView:UIImageView
    let bindingData:AnyObserver<ProductImagesWithTag>
    static let identifier = "DetailProductCollectionViewImageCell"
    private let disposeBag:DisposeBag
    private var viewModel:Pr_DetailProductCollectionViewImageCellViewModel!
    override init(frame: CGRect) {
        disposeBag = DisposeBag()
        imageView = UIImageView()
        let bindingSubject = PublishSubject<ProductImagesWithTag>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        bindingSubject.withUnretained(self).do(onNext: {
            owner,productImageWithTag in
            owner.tag = productImageWithTag.tag
        }).flatMap{
            owner,productImageWithTag in
           return owner.viewModel.returnImage(productImageWithTag: productImageWithTag)
        }.withUnretained(self).observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
            owner,cellImageTag in
            if(cellImageTag.tag == owner.tag){
                switch cellImageTag.result {
                case .success(let image):
                    owner.imageView.image = image
                case .failure(let error):
                    if error == .NoImageData || error == .RequestError{
                        owner.imageView.image = UIImage(named: "NoImage")
                    }
                }
            }
        })
        .disposed(by: disposeBag)
        layout()
    }
    func bindingViewModel(cellViewModel:Pr_DetailProductCollectionViewImageCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
        }
    }
    private func layout(){
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
