import UIKit
import RxSwift
class ProductListCollectionViewCell: UICollectionViewCell,UIViewNeedImage {
    static let Identifier:String = "ProductListCollectionViewCell"
    private let titleLabel:UILabel
    private let priceLabel:UILabel
    private let productImageView:UIImageView
    private let checkUpDown:UIImageView
    // MARK: OUTPUT
    let bindingData:AnyObserver<Product>
    private var disposeBag:DisposeBag
    let imageBinding:AnyObserver<ResponseImage>
    override init(frame: CGRect) {
        print("INIT")
        titleLabel = UILabel()
        priceLabel = UILabel()
        productImageView = UIImageView()
        checkUpDown = UIImageView()
        disposeBag = DisposeBag()
        let data = PublishSubject<Product>()
        bindingData = data.asObserver()
        let requestingImage = PublishSubject<ResponseImage>()
        imageBinding = requestingImage.asObserver()
        super.init(frame: frame)
        data.withUnretained(self).subscribe(onNext: {
            owner, product in
            owner.titleLabel.text = product.title
            owner.priceLabel.text = String(product.price)
            })
            .disposed(by: disposeBag)
        requestingImage.asObservable().withUnretained(self).observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
            owner,responseImage in
            if owner.tag == responseImage.tag{
                owner.productImageView.image = responseImage.image
            }
        }).disposed(by: disposeBag)
        layoutContentView()
        
        self.contentView.layer.masksToBounds = true
        self.productImageView.contentMode = .scaleAspectFill
    }
    private func layoutContentView(){
        contentView.backgroundColor = .red
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}