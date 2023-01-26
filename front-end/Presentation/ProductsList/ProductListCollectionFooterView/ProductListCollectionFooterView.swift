//
//  ProductListCollectionFooterView.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ProductListCollectionFooterView:UICollectionReusableView{
    static let Identifier:String = "FooterView"
    private let activityView:UIActivityIndicatorView
    private var viewModel:Pr_ProductListCollectionFooterViewModel!
    private let disposeBag:DisposeBag
    override init(frame: CGRect) {
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .medium)
        activityView.color = .systemYellow
        super.init(frame: frame)
        layoutContent()
    }
    private func layoutContent(){
        self.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        NSLayoutConstraint(item: activityView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.75, constant: 0.0).isActive = true
        activityView.widthAnchor.constraint(equalTo: activityView.heightAnchor).isActive = true
    }
    func bindingViewModel(FooterViewModel:Pr_ProductListCollectionFooterViewModel?){
        if FooterViewModel != nil && self.viewModel == nil{
            self.viewModel = FooterViewModel
            self.viewModel.activity.bind(to: self.activityView.rx.isAnimating).disposed(by: disposeBag)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
