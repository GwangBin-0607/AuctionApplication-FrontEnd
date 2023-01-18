import UIKit
import RxSwift
final class ProductListCollectionViewCell: UICollectionViewCell,AnimationCell{
    static let Identifier:String = "ProductListCollectionViewCell"
    private let titleLabel:UILabel
    private let priceLabel:UILabel
    private let borderView:UIView
    private let productImageView:UIImageView
    private let checkUpDown:UIImageView
    private let disposeBag:DisposeBag
    private let borderAnimator:UIViewPropertyAnimator
    // MARK: OUTPUT
    let data:PublishSubject<Product>
    let bindingData:AnyObserver<Product>
    let animationObserver: AnyObserver<Int>
    private var viewModel:Pr_ProductListCollectionViewCellViewModel!
    override init(frame: CGRect) {
        print("CELL INIT")
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
        data.withUnretained(self).do { owner,item in
            owner.tag = item.product_id
            owner.titleLabel.text = item.product_name
            owner.priceLabel.text = String(item.product_price)
        }.flatMap { owner,item in
            return owner.viewModel.returnImage(productId: item.product_id, imageURL: item.mainImageURL).subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        }.withUnretained(self).observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
            owner,cellImageTag in
            if(cellImageTag.tag == owner.tag){
                switch cellImageTag.result {
                case .success(let image):
                    owner.productImageView.image = image
                case .failure(_):
                    owner.productImageView.image = UIImage()
                }
            }
        }).disposed(by: disposeBag)
        
        layoutContentView()
    }
    func bindingViewModel(cellViewModel:Pr_ProductListCollectionViewCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
        }
    }
    
    private func layoutContentView(){
        contentView.backgroundColor = .red
        self.contentView.layer.masksToBounds = true
        self.productImageView.contentMode = .scaleAspectFill
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(checkUpDown)
        contentView.addSubview(titleLabel)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        checkUpDown.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
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
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5.0)
        ])
        priceLabel.setContentCompressionResistancePriority(UILayoutPriority(50), for: .horizontal)
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        productImageView.backgroundColor = .green
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
protocol AnimationCell:UICollectionViewCell{
    var animationObserver:AnyObserver<Int>{get}
}
