import UIKit
import RxSwift
final class ProductListCollectionViewCell: UICollectionViewCell,RequestImageCell,AnimationCell{
    static let Identifier:String = "ProductListCollectionViewCell"
    private let titleLabel:UILabel
    private let priceLabel:UILabel
    private let borderView:UIView
    private let productImageView:UIImageView
    private let checkUpDown:UIImageView
    private let disposeBag:DisposeBag
    private let borderAnimator:UIViewPropertyAnimator
    // MARK: OUTPUT
    let bindingData:AnyObserver<Product>
    let setImageObserver: AnyObserver<ResponseImage>
    let animationObserver: AnyObserver<Int>
    override init(frame: CGRect) {
        print("CELL INIT")
        titleLabel = UILabel()
        priceLabel = UILabel()
        productImageView = UIImageView()
        checkUpDown = UIImageView()
        disposeBag = DisposeBag()
        borderView = UIView()
        let data = PublishSubject<Product>()
        bindingData = data.asObserver()
        let setImageSubject = PublishSubject<ResponseImage>()
        setImageObserver = setImageSubject.asObserver()
        let setImageObservable = setImageSubject.asObservable()
        let animationSubject = PublishSubject<Int>()
        animationObserver = animationSubject.asObserver()
        borderAnimator = UIViewPropertyAnimator()
        super.init(frame: frame)
        animationSubject.asObservable().observe(on: MainScheduler.asyncInstance).withUnretained(self).subscribe(onNext: {
            owner,price in
            owner.priceLabel.text = String(price)
        }).disposed(by: disposeBag)
        setImageObservable.observe(on: MainScheduler.asyncInstance).withUnretained(self).subscribe(onNext: {
            owner,responseImage in
            if(responseImage.productId == owner.tag){
                owner.productImageView.image = responseImage.image
            }
        }).disposed(by: disposeBag)
        data.withUnretained(self).subscribe(onNext: {
            owner, product in
            owner.tag = product.product_id
            owner.titleLabel.text = product.product_name
            owner.priceLabel.text = String(product.product_price)
            })
            .disposed(by: disposeBag)
        layoutContentView()
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
protocol AnimationCell{
    var animationObserver:AnyObserver<Int>{get}
}
