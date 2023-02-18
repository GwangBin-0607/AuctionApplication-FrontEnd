//
//  DetailProductCollectionViewImageCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/18.
//

import UIKit
import RxSwift
final class DetailProductCollectionViewImageCell:UICollectionViewCell{
    let imageView = UIImageView()
    let bindingData:AnyObserver<DetailProductImages?>
    static let identifier = "DetailProductCollectionViewImageCell"
    override init(frame: CGRect) {
        let bindingSubject = PublishSubject<DetailProductImages?>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
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
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        print("FITTING")
        return layoutAttributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
