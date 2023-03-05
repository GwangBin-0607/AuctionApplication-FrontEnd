//
//  ProfileImageView.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit
final class ProfileImageView:UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width/2
        clipsToBounds = true
    }
}
