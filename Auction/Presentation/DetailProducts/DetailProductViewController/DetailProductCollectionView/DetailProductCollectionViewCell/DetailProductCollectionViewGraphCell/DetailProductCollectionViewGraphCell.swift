//
//  DetailProductCollectionViewGraphCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/18.
//

import UIKit
import RxSwift
class DetailProductCollectionViewGraphCell: UICollectionViewCell {
    static let identifier = "DetailProductCollectionViewCommentCell"
    let bindingData:AnyObserver<DetailProductGraph?>
    
    override init(frame: CGRect) {
        let bindingSubject = PublishSubject<DetailProductGraph?>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
