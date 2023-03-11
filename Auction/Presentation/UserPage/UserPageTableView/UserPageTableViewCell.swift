//
//  UserPageTableViewCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
import RxSwift
final class UserPageTableViewCell:UITableViewCell{
    static let IDENTIFIER = "UserPageTableViewCellPage"
    private let contentLabel:PaddingLabel
    let binding : AnyObserver<String>
    private let disposeBag:DisposeBag
    private let arrowImageView:UIImageView
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        contentLabel = PaddingLabel(frame: .zero,padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        arrowImageView = UIImageView()
        disposeBag = DisposeBag()
        let bindingSubject = PublishSubject<String>()
        binding = bindingSubject.asObserver()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        layout()
        bindingSubject.asObservable().subscribe(onNext: {
            [weak self] content in
            self?.contentLabel.text = content
        }).disposed(by: disposeBag)
    }
    private func layout(){
        self.contentView.addSubview(contentLabel)
        contentLabel.textColor = .black
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: contentLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 0.15, constant: 0.0).isActive = true
        contentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        contentLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        contentView.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: arrowImageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.9, constant: 0.0).isActive = true
        NSLayoutConstraint(item: arrowImageView, attribute: .height, relatedBy: .equal, toItem: contentLabel, attribute: .height, multiplier: 0.5, constant: 0.0).isActive = true
        arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -5.0).isActive = true
        arrowImageView.tintColor = .gray
        contentLabel.setContentHuggingPriority(UILayoutPriority(900), for: .vertical)
        contentLabel.setContentCompressionResistancePriority(UILayoutPriority(900), for: .horizontal)
        let arrowImage = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate)
        arrowImageView.image = arrowImage
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted{
            contentView.backgroundColor = .systemYellow
        }else{
            contentView.backgroundColor = .white
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            contentView.backgroundColor = .systemYellow
            isSelected = false
        }else{
            UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
                self.contentView.backgroundColor = .white
            })
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class PaddingLabel:UILabel{
    private let padding:UIEdgeInsets
    init(frame:CGRect,padding:UIEdgeInsets){
        self.padding = padding
        super.init(frame: frame)
    }
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
