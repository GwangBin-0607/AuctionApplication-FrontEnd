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
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
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
    private var endNSConstraint:[NSLayoutConstraint] = []
    private var startNSConstraint:[NSLayoutConstraint] = []
    
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
        let updownTrailing = upDownImageView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -5.0)
        startNSConstraint.append(updownTrailing)
        updownTrailing.isActive = true
        let updownTop = upDownImageView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor)
        startNSConstraint.append(updownTop)
        updownTop.isActive = true
        endNSConstraint.append(upDownImageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5.0))
        let updownLeading = upDownImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 3.0)
        startNSConstraint.append(updownLeading)
        updownLeading.isActive = true
        endNSConstraint.append(upDownImageView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor))
        NSLayoutConstraint(item: upDownImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.04, constant: 0.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .height, relatedBy: .equal, toItem: upDownImageView, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        let beforeTrailing = beforePriceLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
        startNSConstraint.append(beforeTrailing)
        beforeTrailing.isActive = true
        let beforeTop = beforePriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5.0)
        startNSConstraint.append(beforeTop)
        beforeTop.isActive = true
        endNSConstraint.append(beforePriceLabel.centerYAnchor.constraint(equalTo: upDownImageView.centerYAnchor))
        endNSConstraint.append(beforePriceLabel.trailingAnchor.constraint(equalTo: upDownImageView.leadingAnchor,constant: -5.0))
        let buyTop = buyProductButton.topAnchor.constraint(equalTo: self.topAnchor)
        startNSConstraint.append(buyTop)
        buyTop.isActive = true
        endNSConstraint.append(buyProductButton.topAnchor.constraint(equalTo: upDownImageView.bottomAnchor, constant: 5.0))
        let buyBottom = buyProductButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        startNSConstraint.append(buyBottom)
        buyBottom.isActive = true
        endNSConstraint.append(NSLayoutConstraint(item: buyProductButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.2, constant: 0.0))
        let buyBottomWidth = NSLayoutConstraint(item: buyProductButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0.0)
        startNSConstraint.append(buyBottomWidth)
        buyBottomWidth.isActive = true
        endNSConstraint.append(buyProductButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:5.0))
        buyProductButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        priceLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        beforePriceLabel.font = UIFont.systemFont(ofSize: 8.0, weight: .heavy)
        self.backgroundColor = .systemYellow
        beforePriceLabel.textColor = .black
        let priceLeading = priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0)
        startNSConstraint.append(priceLeading)
        priceLeading.isActive = true
        endNSConstraint.append(NSLayoutConstraint(item: priceLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.9, constant: 0.0))
        let enablePrice = enableBuyPriceLabel.topAnchor.constraint(equalTo: self.bottomAnchor)
        startNSConstraint.append(enablePrice)
        enablePrice.isActive = true
        endNSConstraint.append(enableBuyPriceLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor))
        endNSConstraint.append(enableBuyPriceLabel.topAnchor.constraint(equalTo: self.buyProductButton.bottomAnchor,constant: 15.0))
        enableBuyPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15.0).isActive = true
        enableBuyPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15.0).isActive = true
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        beforePriceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
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
        startNSConstraint.forEach{$0.isActive = false}
        endNSConstraint.forEach{$0.isActive = true}
    }
    func animateBackSubview(){
        buyProductButton.backgroundColor = buyProductButton.endColor
        endNSConstraint.forEach{$0.isActive = false}
        startNSConstraint.forEach{$0.isActive = true}
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
