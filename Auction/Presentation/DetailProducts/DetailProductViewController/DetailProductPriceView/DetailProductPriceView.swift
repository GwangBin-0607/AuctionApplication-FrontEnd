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
    private weak var gestureDelegate:GestureDelegate?
    init(viewModel:Pr_DetailProductPriceViewModel,priceLabel:PriceLabel) {
        beforePriceLabel = UILabel()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.priceLabel = priceLabel
        upDownImageView = UIImageView()
        buyProductButton = BuyProductButton(title: "구매하기", horizontalPadding: 5)
        super.init(frame: .zero)
        self.addGestureRecognizer(makePangesture())
        self.addGestureRecognizer(makeTapGesture())
        layout()
        bind()
        self.backgroundColor = .systemMint
        self.layer.cornerRadius = 10
    }
    private var priceLabelStartConstraint:NSLayoutConstraint?
    private var priceLabelEndConstraint:NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
        viewModel.beforePriceObservable.bind(to: beforePriceLabel.rx.text).disposed(by: disposeBag)
        viewModel.updownObservable.observe(on: MainScheduler.asyncInstance).bind(to: upDownImageView.rx.image).disposed(by: disposeBag)
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
        priceLabelStartConstraint = priceLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        priceLabelEndConstraint = NSLayoutConstraint(item: priceLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.5, constant: 0.0)
        priceLabelStartConstraint?.isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0.0).isActive = true
        upDownImageView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        upDownImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 3.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: upDownImageView, attribute: .width, relatedBy: .equal, toItem: upDownImageView, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        beforePriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        beforePriceLabel.leadingAnchor.constraint(equalTo: upDownImageView.leadingAnchor).isActive = true
        buyProductButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buyProductButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buyProductButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        upDownImageView.backgroundColor = .yellow
        priceLabel.font = UIFont.boldSystemFont(ofSize: 55)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.1
        beforePriceLabel.font = UIFont.boldSystemFont(ofSize: 8)
        self.backgroundColor = .white
        borderline()
    }
    private func borderline(){
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }
}
extension DetailProductPriceView:Pr_DetailProductPriceView{
    func animateSubview(){
        priceLabelStartConstraint?.isActive = false
        priceLabelEndConstraint?.isActive = true
    }
    func animateBackSubview(){
        priceLabelEndConstraint?.isActive = false
        priceLabelStartConstraint?.isActive = true
    }
    func setGestureDelegata(delegate:GestureDelegate){
        self.gestureDelegate = delegate
    }
}
extension DetailProductPriceView{
    private func makePangesture()->UIPanGestureRecognizer{
       let pan =  UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
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
        return tap
    }
    @objc private func tapGesture(sender:UITapGestureRecognizer){
        gestureDelegate?.tapGesture()
    }
}
