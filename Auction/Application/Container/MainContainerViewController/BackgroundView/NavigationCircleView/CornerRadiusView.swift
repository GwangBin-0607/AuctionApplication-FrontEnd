//
//  CircleView.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import UIKit
class CornerRadiusView:UIView{
    init(frame:CGRect,borderWidth:CGFloat,borderColor:UIColor) {
        super.init(frame:frame)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("------")
        self.layer.cornerRadius = self.frame.width/2
    }
}
