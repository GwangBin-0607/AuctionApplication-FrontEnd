import UIKit
import RxSwift
final class ProductListCollectionViewCell: UICollectionViewCell{
    static let Identifier:String = "ProductListCollectionViewCell"
    private let titleLabel:UILabel
    private let priceLabel:UILabel
    private let borderView:UIView
    private let productImageView:UIImageView
    private let checkUpDown:UIImageView
    private let disposeBag:DisposeBag
    private let borderAnimator:UIViewPropertyAnimator
    private let gradationView:GradationView
    // MARK: OUTPUT
    private let data:PublishSubject<Product>
    let bindingData:AnyObserver<Product>
    let animationObserver: AnyObserver<Int>
    private var viewModel:Pr_ProductListCollectionViewCellViewModel!
    override init(frame: CGRect) {
        print("CELL INIT")
        gradationView = GradationView()
        data = PublishSubject<Product>()
        titleLabel = UILabel()
        priceLabel = UILabel()
        productImageView = UIImageView()
        checkUpDown = UIImageView()
        disposeBag = DisposeBag()
        borderView = UIView()
        bindingData = data.asObserver()
        let animationSubject = PublishSubject<Int>()
        animationObserver = animationSubject.asObserver()
        borderAnimator = UIViewPropertyAnimator()
        super.init(frame: frame)
        animationSubject.asObservable().observe(on: MainScheduler.asyncInstance).withUnretained(self).subscribe(onNext: {
            owner,price in
            owner.priceLabel.text = String(price)
        }).disposed(by: disposeBag)
        layoutContentView()
    }
    func bindingViewModel(cellViewModel:Pr_ProductListCollectionViewCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
            
            data.withUnretained(self).do { owner,item in
                owner.tag = item.product_id
                owner.titleLabel.text = item.product_name
                owner.priceLabel.text = String(item.product_price)
            }.flatMap { owner,item in
                return owner.viewModel.returnImage(productId: item.product_id, imageURL: item.mainImageURL)
            }.withUnretained(self).observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
                owner,cellImageTag in
                if(cellImageTag.tag == owner.tag){
                    switch cellImageTag.result {
                    case .success(let image):
                        owner.productImageView.image = image
                    case .failure(let error):
                        if error == .NoImageData || error == .RequestError{
                            owner.productImageView.image = UIImage(named: "NoImage")
                        }
                    }
                }
            }).disposed(by: disposeBag)
        }
    }
    
    private func layoutContentView(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.productImageView.contentMode = .scaleAspectFill
        contentView.addSubview(productImageView)
        contentView.addSubview(gradationView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(checkUpDown)
        contentView.addSubview(titleLabel)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        gradationView.translatesAutoresizingMaskIntoConstraints = false
        checkUpDown.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        priceLabel.textColor = .systemBlue
        let checkUpDownTrailing = checkUpDown.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -2.0)
        checkUpDownTrailing.priority = UILayoutPriority(150)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkUpDown.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5.0),
            checkUpDown.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5.0),
            checkUpDown.widthAnchor.constraint(equalTo: checkUpDown.heightAnchor),
            checkUpDownTrailing,
            checkUpDown.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            priceLabel.trailingAnchor.constraint(equalTo: checkUpDown.leadingAnchor, constant: -5.0),
            titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -2.0),
            titleLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5.0),
            gradationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            NSLayoutConstraint(item: gradationView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0.4, constant: 0.0)
        ])
        priceLabel.setContentCompressionResistancePriority(UILayoutPriority(50), for: .horizontal)
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        checkUpDown.backgroundColor = .systemYellow
    }
    deinit {
        print("CELL DEINIT")
    }
    override func prepareForReuse() {
        self.productImageView.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
