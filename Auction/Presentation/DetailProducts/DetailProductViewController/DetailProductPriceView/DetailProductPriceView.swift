//
//  DetailProductPriceView.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/20.
//

import Foundation
import UIKit
import RxSwift
class ShadowView:UIView{
    init() {
        super.init(frame: .zero)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
//        self.layer.shouldRasterize = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
final class DetailProductPriceView:ShadowView{
    private let priceLabel:PriceLabel
    private let beforePriceLabel:UILabel
    private let upDownImageView:UIImageView
    let buyProductButton:BuyProductButton
    private let viewModel:Pr_DetailProductPriceViewModel
    private let disposeBag:DisposeBag
    private weak var gestureDelegate:GestureDelegate?
    private let enableBuyPriceLabel:PriceLabel
    init(viewModel:Pr_DetailProductPriceViewModel,priceLabel:PriceLabel,enablePriceLabel:PriceLabel) {
        enableBuyPriceLabel = enablePriceLabel
        beforePriceLabel = UILabel()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.priceLabel = priceLabel
        upDownImageView = UIImageView()
        buyProductButton = BuyProductButton(title: "구매하기", horizontalPadding: 5)
        super.init()
        self.addGestureRecognizer(makePangesture())
        self.addGestureRecognizer(makeTapGesture())
        layout()
        bind()
        self.layer.cornerRadius = 10
    }
    private var priceLabelStartConstraint:NSLayoutConstraint?
    private var priceLabelEndConstraint:NSLayoutConstraint?
    private var updownImageStartLeadingConstraint:NSLayoutConstraint?
    private var updownImageEndLeadingConstraint:NSLayoutConstraint?
    private var updownImageStartTrailingContraint:NSLayoutConstraint?
    private var updownImageStartTopConstraint:NSLayoutConstraint?
    private var updownImageEndTopConstraint:NSLayoutConstraint?
    private var buyButtonStartTopConstraint:NSLayoutConstraint?
    private var buyButtonEndTopConstrain:NSLayoutConstraint?
    private var buyButtonStartBottomConstraint:NSLayoutConstraint?
    private var buyButtonEndBottomConstrain:NSLayoutConstraint?
    private var beforePriceStartTrailingConstraint:NSLayoutConstraint?
    private var beforePriceEndTrailingConstraint:NSLayoutConstraint?
    private var beforePriceStartTopConstraint:NSLayoutConstraint?
    private var beforePriceEndTopConstraint:NSLayoutConstraint?
    private var enablePriceLabelStartTopConstraint:NSLayoutConstraint?
    private var enablePriceLabelEndTopConstraint:NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
        viewModel.beforePriceObservable.bind(to: beforePriceLabel.rx.text).disposed(by: disposeBag)
        viewModel.updownObservable.observe(on: MainScheduler.asyncInstance).bind(to: upDownImageView.rx.image).disposed(by: disposeBag)
    }
    
    private func layout(){
        self.addSubview(buyProductButton)
        self.addSubview(priceLabel)
        self.addSubview(upDownImageView)
        self.addSubview(beforePriceLabel)
        self.addSubview(enableBuyPriceLabel)
        enableBuyPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        buyProductButton.translatesAutoresizingMaskIntoConstraints = false
        beforePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        upDownImageView.translatesAutoresizingMaskIntoConstraints = false
        enableBuyPriceLabel.font = UIFont.systemFont(ofSize: 25.0, weight: .heavy)
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5.0).isActive = true
        updownImageStartTrailingContraint = upDownImageView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -5.0)
        updownImageStartTrailingContraint?.isActive = true
        updownImageStartTopConstraint = upDownImageView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor)
        updownImageStartTopConstraint?.isActive = true
        updownImageEndTopConstraint = upDownImageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5.0)
        updownImageStartLeadingConstraint = upDownImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 3.0)
        updownImageStartLeadingConstraint?.isActive = true
        updownImageEndLeadingConstraint = upDownImageView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
        NSLayoutConstraint(item: upDownImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.04, constant: 0.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .height, relatedBy: .equal, toItem: upDownImageView, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        beforePriceStartTrailingConstraint = beforePriceLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
        beforePriceStartTopConstraint = beforePriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5.0)
        beforePriceStartTopConstraint?.isActive = true
        beforePriceEndTopConstraint = beforePriceLabel.centerYAnchor.constraint(equalTo: upDownImageView.centerYAnchor)
        beforePriceStartTrailingConstraint?.isActive = true
        beforePriceEndTrailingConstraint = beforePriceLabel.trailingAnchor.constraint(equalTo: upDownImageView.leadingAnchor,constant: -5.0)
        buyButtonStartTopConstraint = buyProductButton.topAnchor.constraint(equalTo: self.topAnchor)
        buyButtonStartTopConstraint?.isActive = true
        buyButtonEndTopConstrain = buyProductButton.topAnchor.constraint(equalTo: upDownImageView.bottomAnchor, constant: 5.0)
        buyButtonStartBottomConstraint = buyProductButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        buyButtonStartBottomConstraint?.isActive = true
        buyButtonEndBottomConstrain = NSLayoutConstraint(item: buyProductButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.2, constant: 0.0)
        NSLayoutConstraint(item: buyProductButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0.0).isActive = true
        buyProductButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        priceLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        beforePriceLabel.font = UIFont.systemFont(ofSize: 8.0, weight: .heavy)
        self.backgroundColor = .systemYellow
        beforePriceLabel.textColor = .black
        priceLabelStartConstraint = priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0)
        priceLabelEndConstraint = NSLayoutConstraint(item: priceLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.9, constant: 0.0)
        priceLabelStartConstraint?.isActive = true
        enablePriceLabelStartTopConstraint = enableBuyPriceLabel.topAnchor.constraint(equalTo: self.bottomAnchor)
        enablePriceLabelStartTopConstraint?.isActive = true
        enablePriceLabelEndTopConstraint = enableBuyPriceLabel.topAnchor.constraint(equalTo: self.buyProductButton.bottomAnchor,constant: 5.0)
        enableBuyPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0).isActive = true
        enableBuyPriceLabel.trailingAnchor.constraint(equalTo: buyProductButton.leadingAnchor,constant: -5.0).isActive = true
        borderline()
    }
    private func borderline(){
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }
}
extension DetailProductPriceView:Pr_DetailProductPriceView{
    func animateSubview(){
        buyProductButton.backgroundColor = buyProductButton.startColor
        enablePriceLabelStartTopConstraint?.isActive = false
        beforePriceStartTopConstraint?.isActive = false
        beforePriceStartTrailingConstraint?.isActive = false
        updownImageStartTrailingContraint?.isActive = false
        priceLabelStartConstraint?.isActive = false
        updownImageStartLeadingConstraint?.isActive = false
        updownImageStartTopConstraint?.isActive = false
        buyButtonStartTopConstraint?.isActive = false
        buyButtonStartBottomConstraint?.isActive = false
        priceLabelEndConstraint?.isActive = true
        updownImageEndLeadingConstraint?.isActive = true
        updownImageEndTopConstraint?.isActive = true
        buyButtonEndTopConstrain?.isActive = true
        buyButtonEndBottomConstrain?.isActive = true
        beforePriceEndTrailingConstraint?.isActive = true
        beforePriceEndTopConstraint?.isActive = true
        enablePriceLabelEndTopConstraint?.isActive = true
    }
    func animateBackSubview(){
        buyProductButton.backgroundColor = buyProductButton.endColor
        enablePriceLabelEndTopConstraint?.isActive = false
        beforePriceEndTopConstraint?.isActive = false
        beforePriceEndTrailingConstraint?.isActive = false
        buyButtonEndTopConstrain?.isActive = false
        buyButtonEndBottomConstrain?.isActive = false
        priceLabelEndConstraint?.isActive = false
        updownImageEndLeadingConstraint?.isActive = false
        updownImageEndTopConstraint?.isActive = false
        priceLabelStartConstraint?.isActive = true
        updownImageStartLeadingConstraint?.isActive = true
        updownImageStartTopConstraint?.isActive = true
        updownImageStartTrailingContraint?.isActive = true
        buyButtonStartTopConstraint?.isActive = true
        buyButtonStartBottomConstraint?.isActive = true
        beforePriceStartTrailingConstraint?.isActive = true
        beforePriceStartTopConstraint?.isActive = true
        enablePriceLabelStartTopConstraint?.isActive = true
    }
    func setGestureDelegata(delegate:GestureDelegate){
        self.gestureDelegate = delegate
    }
}
extension DetailProductPriceView{
    private func makePangesture()->UIPanGestureRecognizer{
       let pan =  UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        pan.delaysTouchesBegan = true
        return pan
    }
    @objc private func gesture(sender:UIPanGestureRecognizer){
        guard let superview = self.superview else { return }
        let translation = sender.translation(in: superview)
        let gesture = Pangesture(point: translation, state: sender.state)
        gestureDelegate?.gesture(pangesture: gesture)
    }
    private func makeTapGesture()->UITapGestureRecognizer{
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        tap.delaysTouchesBegan = true
        return tap
    }
    @objc private func tapGesture(sender:UITapGestureRecognizer){
        gestureDelegate?.tapGesture()
    }
}
