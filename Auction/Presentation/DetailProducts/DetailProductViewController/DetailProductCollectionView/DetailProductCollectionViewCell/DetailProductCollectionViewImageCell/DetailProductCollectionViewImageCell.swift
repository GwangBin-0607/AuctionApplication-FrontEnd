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
    let bindingData:AnyObserver<Product_Images?>
    static let identifier = "DetailProductCollectionViewImageCell"
    private let disposeBag:DisposeBag
    override init(frame: CGRect) {
        disposeBag = DisposeBag()
        imageView = UIImageView()
        let bindingSubject = PublishSubject<Product_Images?>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        bindingSubject.withUnretained(self).subscribe(onNext: {
            owner,image in
            if let image = image{
                owner.imageView.image =  UIImage(named:"0"+String(image.image_id) )

            }
        }).disposed(by: disposeBag)
        layout()
    }
    private func layout(){
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        imageView.backgroundColor = .systemGray
        self.contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
