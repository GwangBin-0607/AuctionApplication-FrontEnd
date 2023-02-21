//
//  DetailProductCollectionViewUserCellProfileImageView.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/20.
//
import UIKit
final class DetailProductCollectionViewUserCellProfileImageView:UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width/2
        clipsToBounds = true
    }
}
