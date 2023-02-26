import UIKit
import RxSwift
struct UserWithTag{
    let user:DetailProductUser?
    let tag:Int
}
final class DetailProductCollectionViewUserCell:UICollectionViewCell{
    private let userLabel:UILabel
    private let userProfile:DetailProductCollectionViewUserCellProfileImageView
    let bindingData:AnyObserver<UserWithTag>
    static let identifier = "DetailProductCollectionViewCell"
    private let disposeBag:DisposeBag
    private var viewModel:Pr_DetailProductCollectionViewUserCellViewModel!
    private let bindingObservable:Observable<UserWithTag>
    override init(frame: CGRect) {
        userProfile = DetailProductCollectionViewUserCellProfileImageView()
        userLabel = UILabel()
        disposeBag = DisposeBag()
        let bindingSubject = PublishSubject<UserWithTag>()
        bindingObservable = bindingSubject.asObservable()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        layout()
    }
    func bindingViewModel(cellViewModel:Pr_DetailProductCollectionViewUserCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
            bind()
        }
    }
    private func bind(){
        viewModel.userNameObservable.bind(to: userLabel.rx.text).disposed(by: disposeBag)
        viewModel.userImageObservable.withUnretained(self).subscribe(onNext: {
            owner,cellImageTag in
            if(cellImageTag.tag == owner.tag){
                owner.userProfile.image = cellImageTag.image
            }
        }).disposed(by: disposeBag)
        bindingObservable.withUnretained(self).do(onNext: {
            owner,userImageTag in
            owner.tag = userImageTag.tag
        }).subscribe(onNext: {
            owner,userImageTag in
            owner.viewModel.detailUserObserver.onNext(userImageTag)
        }).disposed(by: disposeBag)
    }
    private func layout(){
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(userProfile)
        userProfile.contentMode = .scaleAspectFill
        userProfile.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        userProfile.layer.borderWidth = 0.5
        userProfile.translatesAutoresizingMaskIntoConstraints = false
        userProfile.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: userProfile, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 0.1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: userProfile, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.65, constant: 0.0).isActive = true
        NSLayoutConstraint(item: userProfile, attribute: .width, relatedBy: .equal, toItem: userProfile, attribute: .height, multiplier: 1.0, constant: 0.0).isActive  = true
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.leadingAnchor.constraint(equalTo: userProfile.trailingAnchor, constant: 10.0).isActive = true
        userLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: userLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.9, constant: 0.0).isActive = true
        userProfile.backgroundColor = .systemGroupedBackground
        userLabel.textColor = .black
        userLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        self.backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
