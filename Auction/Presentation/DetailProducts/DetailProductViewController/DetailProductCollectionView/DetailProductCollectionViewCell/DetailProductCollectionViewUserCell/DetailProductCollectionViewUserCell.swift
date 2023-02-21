import UIKit
import RxSwift
final class DetailProductCollectionViewUserCell:UICollectionViewCell{
    private let userLabel:UILabel
    private let userProfile:DetailProductCollectionViewUserCellProfileImageView
    let bindingData:AnyObserver<DetailProductUser?>
    static let identifier = "DetailProductCollectionViewCell"
    private let disposeBag:DisposeBag
    override init(frame: CGRect) {
        userProfile = DetailProductCollectionViewUserCellProfileImageView()
        userLabel = UILabel()
        disposeBag = DisposeBag()
        let bindingSubject = PublishSubject<DetailProductUser?>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        bindingSubject.withUnretained(self).subscribe(onNext: {
            owner, detailProductUser in
            if let user = detailProductUser{
                self.userLabel.text = "awdhoawdhiaodhioadhio"
            }
        }).disposed(by: disposeBag)
        layout()
    }
    private func layout(){
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(userProfile)
        userProfile.translatesAutoresizingMaskIntoConstraints = false
        userProfile.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: userProfile, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 0.1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: userProfile, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.65, constant: 0.0).isActive = true
        NSLayoutConstraint(item: userProfile, attribute: .width, relatedBy: .equal, toItem: userProfile, attribute: .height, multiplier: 1.0, constant: 0.0).isActive  = true
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.leadingAnchor.constraint(equalTo: userProfile.trailingAnchor, constant: 10.0).isActive = true
        userLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: userLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.9, constant: 0.0).isActive = true
        userProfile.backgroundColor = .red
        userLabel.backgroundColor = .red
        userLabel.textColor = .black
        userLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .heavy)
        self.backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
