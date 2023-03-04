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
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
final class DetailProductPriceView:ShadowView{
    private let priceLabel:PriceLabel
    private let beforePriceLabel:UILabel
    private let upDownImageView:UIImageView
    private let buyProductButton:BuyProductButton
    private let viewModel:Pr_DetailProductPriceViewModel
    private let disposeBag:DisposeBag
    private let enableBuyPriceLabel:PriceLabel
    init(viewModel:Pr_DetailProductPriceViewModel,priceLabel:PriceLabel,enablePriceLabel:PriceLabel,buyProductBotton:BuyProductButton) {
        enableBuyPriceLabel = enablePriceLabel
        beforePriceLabel = UILabel()
        buyProductButton = buyProductBotton
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.priceLabel = priceLabel
        upDownImageView = UIImageView()
        super.init()
        self.addGestureRecognizer(makePangesture())
        self.addGestureRecognizer(makeTapGesture())
        layout()
        bind()
    }
    override func layoutSubviews() {
        print("SUBVIEW!")
    }
    private var endNSConstraint:[NSLayoutConstraint] = []
    private var startNSConstraint:[NSLayoutConstraint] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
        viewModel.animationSubview.subscribe(onNext: {
            [weak self] _ in
            self?.animateSubview()
        }).disposed(by: disposeBag)
        viewModel.beforePriceObservable.bind(to: beforePriceLabel.rx.text).disposed(by: disposeBag)
        viewModel.updownObservable.observe(on: MainScheduler.asyncInstance).bind(to: upDownImageView.rx.image).disposed(by: disposeBag)
    }
    
    private func layout(){
        self.addSubview(buyProductButton)
        self.addSubview(priceLabel)
        self.addSubview(upDownImageView)
        self.addSubview(beforePriceLabel)
        self.addSubview(enableBuyPriceLabel)
        beforePriceLabel.textAlignment = .right
        enableBuyPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        buyProductButton.translatesAutoresizingMaskIntoConstraints = false
        beforePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        upDownImageView.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        priceLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        
        upDownImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        upDownImageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.04, constant: 0.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .height, relatedBy: .equal, toItem: upDownImageView, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        
        beforePriceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        beforePriceLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .heavy)
        beforePriceLabel.textColor = .black
        beforePriceLabel.centerYAnchor.constraint(equalTo: upDownImageView.centerYAnchor).isActive = true
        beforePriceLabel.trailingAnchor.constraint(equalTo: upDownImageView.leadingAnchor,constant: -5.0).isActive = true
        beforePriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        
        buyProductButton.topAnchor.constraint(equalTo: beforePriceLabel.bottomAnchor,constant: 5.0).isActive = true
        let buyBottom = buyProductButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        startNSConstraint.append(buyBottom)
        buyBottom.isActive = true
        endNSConstraint.append(NSLayoutConstraint(item: buyProductButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.2, constant: 0.0))
        let buyBottomWidth = NSLayoutConstraint(item: buyProductButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0.0)
        startNSConstraint.append(buyBottomWidth)
        buyBottomWidth.isActive = true
        buyProductButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        endNSConstraint.append(buyProductButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:5.0))
        
        enableBuyPriceLabel.font = UIFont.systemFont(ofSize: 25.0, weight: .heavy)
        let enablePrice = enableBuyPriceLabel.topAnchor.constraint(equalTo: self.bottomAnchor)
        startNSConstraint.append(enablePrice)
        enablePrice.isActive = true
        endNSConstraint.append(enableBuyPriceLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor))
        endNSConstraint.append(enableBuyPriceLabel.topAnchor.constraint(equalTo: self.buyProductButton.bottomAnchor,constant: 15.0))
        enableBuyPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15.0).isActive = true
        enableBuyPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15.0).isActive = true
        
        borderline()
        self.backgroundColor = .systemYellow
    }
    private func borderline(){
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }
}
extension DetailProductPriceView{
    private func animateSubview(){
        startNSConstraint.forEach{$0.isActive = false}
        endNSConstraint.forEach{$0.isActive = true}
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
        viewModel.pangestureObserver.onNext(gesture)
    }
    private func makeTapGesture()->UITapGestureRecognizer{
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        tap.delaysTouchesBegan = true
        return tap
    }
    @objc private func tapGesture(sender:UITapGestureRecognizer){
        viewModel.tapGestureObserver.onNext(())
    }
}
