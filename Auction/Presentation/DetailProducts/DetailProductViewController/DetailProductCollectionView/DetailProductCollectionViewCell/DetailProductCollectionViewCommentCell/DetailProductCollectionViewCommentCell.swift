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
    override init(frame: CGRect) {
        disposeBag = DisposeBag()
        let bindingSubject = PublishSubject<DetailProductComment?>()
        bindingData = bindingSubject.asObserver()
        priceLabel = UILabel()
        commentLabel = UILabel()
        productNameLabel = UILabel()
        productRegisterTimeLabel = UILabel()
        super.init(frame: frame)
        bindingSubject.withUnretained(self).subscribe(onNext: {
            owner,detailProductComment in
            if let comment = detailProductComment{
                owner.commentLabel.text = comment.comment
                owner.productNameLabel.text = comment.product_name
                owner.productRegisterTimeLabel.text = owner.convertTime(timezone: comment.registerTime)
                owner.priceLabel.text = owner.decorationPrice(price: comment.original_price)
            }
        }).disposed(by:disposeBag)
        layout()
    }
    private func convertTime(timezone:String)->String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        if let date = dateFormatter.date(from:timezone){
            let twoFor = DateFormatter()
            twoFor.locale = Locale(identifier: Locale.current.identifier) // set locale to reliable US_POSIX
            twoFor.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
            twoFor.dateFormat = "yyyy-MM-dd HH:MM"
            return returnTime(registerTime: twoFor.string(from: date), currentTime: convertCurrentTime())
        }else{
            return nil
        }
    }
    private func decorationPrice(price:Int)->String{
        "시작 가격 : \(price.returnPriceComma())₩"
    }
    private func convertCurrentTime()->String{
        let date = DateFormatter()
        date.locale = Locale(identifier: Locale.current.identifier)
        date.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        date.dateFormat = "yyyy-MM-dd HH:mm"
        return date.string(from: Date())
    }
    private func returnTime(registerTime:String,currentTime:String)->String?{
        let registerArr = registerTime.components(separatedBy: ["-"," ",":"]).map{Int($0)!}
        let currentArr = currentTime.components(separatedBy: ["-"," ",":"]).map{Int($0)!}
        if registerArr[0] < currentArr[0]{
            return String(currentArr[0]-registerArr[0])+"년 전"
        }else if registerArr[1] < currentArr[1]{
            return String(currentArr[1]-registerArr[1])+"개월 전"
        }else if registerArr[2] < currentArr[2]{
            return String(currentArr[2]-registerArr[2])+"일 전"
        }else if registerArr[3] < currentArr[3]{
            return String(currentArr[3]-registerArr[3])+"시간 전"
        }else{
            return "지금"
        }
    }
    private func layout(){
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(productRegisterTimeLabel)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints  = false
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
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        priceLabel.textColor = .black
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
