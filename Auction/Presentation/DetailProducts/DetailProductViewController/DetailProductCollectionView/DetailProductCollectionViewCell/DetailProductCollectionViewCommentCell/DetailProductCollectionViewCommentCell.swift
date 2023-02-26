//
//  DetailProductCollectionViewCommentCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/18.
//

import UIKit
import RxSwift
final class DetailProductCollectionViewCommentCell:UICollectionViewCell{
    private let productNameLabel:UILabel
    private let productRegisterTimeLabel:UILabel
    private let commentLabel:UILabel
    private let priceLabel:UILabel
    static let identifier = "DetailProductCollectionViewCommentCell"
    let bindingData:AnyObserver<DetailProductComment?>
    private let minimumLabelHeight:CGFloat = 20
    private let disposeBag:DisposeBag
    private var viewModel:Pr_DetailProductCollectionViewCommentCellViewModel!
    private let bindObservable:Observable<DetailProductComment?>
    override init(frame: CGRect) {
        disposeBag = DisposeBag()
        let bindingSubject = PublishSubject<DetailProductComment?>()
        bindObservable = bindingSubject.asObservable()
        bindingData = bindingSubject.asObserver()
        commentLabel = UILabel()
        productNameLabel = UILabel()
        productRegisterTimeLabel = UILabel()
        priceLabel = UILabel()
        super.init(frame: frame)
        layout()
    }
    func bindingViewModel(cellViewModel:Pr_DetailProductCollectionViewCommentCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
            bind()
        }
    }
    private func bind(){
        viewModel.originalPriceObservable.bind(to: priceLabel.rx.text).disposed(by: disposeBag)
        viewModel.commentObservable.bind(to: commentLabel.rx.text).disposed(by: disposeBag)
        viewModel.registerObservable.bind(to: productRegisterTimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.priceNameObservable.bind(to: productNameLabel.rx.text).disposed(by: disposeBag)
        bindObservable.withUnretained(self).subscribe(onNext:{
            owner,comment in
            owner.viewModel.detailProductObserver.onNext(comment)
        }).disposed(by:disposeBag)
    }
    private func layout(){
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(productRegisterTimeLabel)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productRegisterTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        productNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5.0).isActive = true
        productNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -5.0).isActive = true
        productNameLabel.textColor = .darkGray
        productNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0).isActive = true
        priceLabel.topAnchor.constraint(equalTo: productRegisterTimeLabel.bottomAnchor).isActive = true
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        productRegisterTimeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 3.0).isActive = true
        productRegisterTimeLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor).isActive = true
        productRegisterTimeLabel.textColor = .gray
        productRegisterTimeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        commentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 5.0).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 5.0).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -5.0).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3.0).isActive = true
        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        commentLabel.textColor = .black
        self.contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
