//
//  DetailProductCollectionViewCommentCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/18.
//

import UIKit
import RxSwift
final class DetailProductCollectionViewCommentCell:UICollectionViewCell{
    let commentLabel = UILabel()
    static let identifier = "DetailProductCollectionViewCommentCell"
    let bindingData:AnyObserver<DetailProductComment?>
    override init(frame: CGRect) {
        let bindingSubject = PublishSubject<DetailProductComment?>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        layout()
    }
    private func layout(){
        self.contentView.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        commentLabel.numberOfLines = 0
        
        self.contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
