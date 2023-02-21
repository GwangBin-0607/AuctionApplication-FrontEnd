//
//  DetailProductPriceView.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/20.
//

import Foundation
import UIKit
import RxSwift
final class DetailProductPriceView:UIView{
    private let priceLabel:PriceLabel
    private let beforePriceLabel:UILabel
    private let upDownImageView:UIImageView
    private let buyProductButton:BuyProductButton
    private let viewModel:Pr_DetailProductPriceViewModel
    private let disposeBag:DisposeBag
    init(viewModel:Pr_DetailProductPriceViewModel) {
        beforePriceLabel = UILabel()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        priceLabel = PriceLabel()
        upDownImageView = UIImageView()
        buyProductButton = BuyProductButton(title: "구매하기", horizontalPadding: 5)
        super.init(frame: .zero)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
//        buyProductButton.rx.tap.
        viewModel.priceObservable.map{String($0)}.bind(to: priceLabel.rx.text).disposed(by: disposeBag)
        viewModel.beforePriceObservable.map{String($0)}.bind(to: beforePriceLabel.rx.text).disposed(by: disposeBag)
        viewModel.updownObservable.withUnretained(self).subscribe(onNext: {
            owner,updown in
            if let updown = updown{
                owner.upDownImageView.image = updown ? UIImage(named: "upState") : UIImage(named: "nothing")
            }
        }).disposed(by: disposeBag)
    }
    private func layout(){
        self.addSubview(priceLabel)
        self.addSubview(upDownImageView)
        self.addSubview(beforePriceLabel)
        self.addSubview(buyProductButton)
        buyProductButton.translatesAutoresizingMaskIntoConstraints = false
        beforePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        upDownImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0).isActive = true
        upDownImageView.topAnchor.constraint(equalTo: priceLabel.topAnchor).isActive = true
        upDownImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 3.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .height, relatedBy: .equal, toItem: priceLabel, attribute: .height, multiplier: 0.5, constant: 0.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .width, relatedBy: .equal, toItem: upDownImageView, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        beforePriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        beforePriceLabel.leadingAnchor.constraint(equalTo: upDownImageView.leadingAnchor).isActive = true
        buyProductButton.heightAnchor.constraint(equalTo: priceLabel.heightAnchor).isActive = true
        buyProductButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        upDownImageView.backgroundColor = .yellow
        priceLabel.backgroundColor = .gray
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        beforePriceLabel.font = UIFont.boldSystemFont(ofSize: 8)
        self.backgroundColor = .white
        borderline()
    }
    private func borderline(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
    }
}
