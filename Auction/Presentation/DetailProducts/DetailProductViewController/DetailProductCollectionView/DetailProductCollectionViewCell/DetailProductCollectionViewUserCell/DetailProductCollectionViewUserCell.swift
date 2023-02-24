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
    override init(frame: CGRect) {
        userProfile = DetailProductCollectionViewUserCellProfileImageView()
        userLabel = UILabel()
        disposeBag = DisposeBag()
        let bindingSubject = PublishSubject<UserWithTag>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        bindingSubject.withUnretained(self).do(onNext: {
            owner, detailProductUser in
            owner.tag = detailProductUser.tag
            if let user = detailProductUser.user{
                self.userLabel.text = user.user_name
            }
        }).flatMap({
            owner, detailProductUser in
            owner.viewModel.returnImage(productImageWithTag: ProductImagesWithTag(product_image: detailProductUser.user?.returnMainUserImage(), tag: detailProductUser.tag))
        }).withUnretained(self).observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
            owner,cellImageTag in
            if(cellImageTag.tag == owner.tag){
                switch cellImageTag.result {
                case .success(let image):
                    owner.userProfile.image = image
                case .failure(let error):
                    if error == .NoImageData || error == .RequestError{
                        owner.userProfile.image = UIImage(named: "NoImage")
                    }
                }
            }
        }).disposed(by: disposeBag)
        layout()
    }
    func bindingViewModel(cellViewModel:Pr_DetailProductCollectionViewUserCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
        }
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
