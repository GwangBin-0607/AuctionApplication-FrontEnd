//
//  PriceLabel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/20.
//

import Foundation
import UIKit
import RxSwift
class PriceLabel:UILabel{
    private let viewModel:Pr_DetailPriceLabelViewModel
    private let disposeBag:DisposeBag
    init(viewModel:Pr_DetailPriceLabelViewModel) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.textColor = .black
        self.layer.drawsAsynchronously = true
        self.textAlignment = .right
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.2
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
        viewModel.priceObservable.withUnretained(self).subscribe(onNext: {
            owner,price in
            owner.text = price
            owner.animateBorderColor(duration: 0.3)
        }).disposed(by: disposeBag)
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
