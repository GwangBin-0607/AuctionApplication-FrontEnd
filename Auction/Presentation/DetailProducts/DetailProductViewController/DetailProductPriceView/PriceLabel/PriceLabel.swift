//
//  PriceLabel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/20.
//

import Foundation
import UIKit

final class PriceLabel:UILabel{
    init() {
        super.init(frame: .zero)
        self.layer.borderColor = ManageColor.singleton.getMainColor().cgColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animateBorderColor(duration: Double) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            [weak self] in
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.fromValue = 4.0
            animation.toValue = 0.0
            animation.duration = duration
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            self?.layer.add(animation, forKey: "changeBorderWidth")
            CATransaction.commit()
        }
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 0.0
        animation.toValue = 4.0
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "changeBorderWidth")
//        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
//            self.bounds = CGRect(x: self.bounds.minX, y: self.bounds.maxY, width: self.bounds.width, height: self.bounds.height)
//        })
        CATransaction.commit()
    }
}
