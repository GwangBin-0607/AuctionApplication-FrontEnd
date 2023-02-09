import UIKit
import RxSwift
struct AnimtionValue{
    let price:Int
    let state:Bool
    let beforePrice:Int
}
final class ProductListCollectionViewCell: UICollectionViewCell{
    static let Identifier:String = "ProductListCollectionViewCell"
    private let titleLabel:UILabel
    private let priceLabel:UILabel
    private let productImageView:UIImageView
    private let checkUpDown:UIImageView
    private let disposeBag:DisposeBag
    private let gradationView:GradationView
    private let beforePriceLabel:UILabel
    // MARK: OUTPUT
    private let data:PublishSubject<Product>
    let bindingData:AnyObserver<Product>
    let animationObserver: AnyObserver<AnimtionValue?>
    private var viewModel:Pr_ProductListCollectionViewCellViewModel!
    override init(frame: CGRect) {
        gradationView = GradationView()
        data = PublishSubject<Product>()
        beforePriceLabel = UILabel()
        titleLabel = UILabel()
        priceLabel = UILabel()
        productImageView = UIImageView()
        checkUpDown = UIImageView()
        disposeBag = DisposeBag()
        bindingData = data.asObserver()
        let animationSubject = PublishSubject<AnimtionValue?>()
        animationObserver = animationSubject.asObserver()
        super.init(frame: frame)
        animationSubject.asObservable().observe(on: MainScheduler.asyncInstance).withUnretained(self).subscribe(onNext: {
            owner,value in
            if let value = value{
                owner.animateBorderColor(duration: 0.3)
                owner.priceLabel.text = String(value.price)+"₩"
                owner.beforePriceLabel.text = owner.decorationBeforePrice(beforePrice: value.beforePrice)
                owner.priceLabel.textColor = owner.textColorPriceLabel(state: value.state)
                owner.beforePriceLabel.textColor = owner.textColorBeforePriceLabel(state: value.state)
                if value.state{
                    owner.checkUpDown.image = UIImage(named: "upState")
                }else{
                    owner.checkUpDown.image = UIImage(named: "Nothing")
                }
            }
        }).disposed(by: disposeBag)
        
        data.withUnretained(self).do { owner,item in
            owner.tag = item.product_id
            owner.titleLabel.text = item.product_name
            owner.priceLabel.text = String(item.product_price.price)+"₩"
            owner.beforePriceLabel.text = owner.decorationBeforePrice(beforePrice: item.product_price.beforePrice)
            owner.priceLabel.textColor = owner.textColorPriceLabel(state: item.checkUpDown.state)
            owner.beforePriceLabel.textColor = owner.textColorBeforePriceLabel(state: item.checkUpDown.state)
            if item.checkUpDown.state{
                owner.checkUpDown.image = UIImage(named: "upState")
            }else{
                owner.checkUpDown.image = UIImage(named: "Nothing")
            }
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
        layoutContentView()
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    private func decorationBeforePrice(beforePrice:Int)->String{
        "전일대비 : +"+String(beforePrice)+"₩"
    }
    private func textColorPriceLabel(state:Bool)->UIColor{
        state ? .systemRed : .white
    }
    private func textColorBeforePriceLabel(state:Bool)->UIColor{
        state ? .systemRed.withAlphaComponent(0.8) : .white.withAlphaComponent(0.8)
    }
    func bindingViewModel(cellViewModel:Pr_ProductListCollectionViewCellViewModel?){
        if cellViewModel != nil && self.viewModel == nil{
            self.viewModel = cellViewModel
        }
    }
    private func animateBorderColor(duration: Double) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            [weak self] in
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.fromValue = 4.0
            animation.toValue = 0.0
            animation.duration = duration
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            self?.layer.add(animation, forKey: "changeBorderWidth")
            CATransaction.commit()
        }
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 0.0
        animation.toValue = 4.0
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "changeBorderWidth")
//        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
//            self.bounds = CGRect(x: self.bounds.minX, y: self.bounds.maxY, width: self.bounds.width, height: self.bounds.height)
//        })
        CATransaction.commit()
    }
    
    private func layoutContentView(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.systemPink.withAlphaComponent(0.5).cgColor
        self.productImageView.contentMode = .scaleAspectFill
        checkUpDown.contentMode = .scaleAspectFit
        contentView.addSubview(productImageView)
        contentView.addSubview(gradationView)
        gradationView.addSubview(priceLabel)
        gradationView.addSubview(checkUpDown)
        gradationView.addSubview(titleLabel)
        gradationView.addSubview(beforePriceLabel)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        gradationView.translatesAutoresizingMaskIntoConstraints = false
        checkUpDown.translatesAutoresizingMaskIntoConstraints = false
        beforePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        priceLabel.textColor = .white
        beforePriceLabel.font = UIFont.boldSystemFont(ofSize: 12)
        beforePriceLabel.textColor = .white
        let checkUpDownTrailing = checkUpDown.trailingAnchor.constraint(lessThanOrEqualTo: gradationView.trailingAnchor, constant: -2.0)
        checkUpDownTrailing.priority = UILayoutPriority(150)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkUpDown.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            checkUpDown.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5.0),
            checkUpDown.widthAnchor.constraint(equalTo: checkUpDown.heightAnchor),
            checkUpDownTrailing,
            checkUpDown.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
            beforePriceLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            beforePriceLabel.bottomAnchor.constraint(equalTo: gradationView.bottomAnchor,constant: -5.0),
            priceLabel.leadingAnchor.constraint(equalTo: gradationView.leadingAnchor, constant: 5.0),
            priceLabel.bottomAnchor.constraint(equalTo: beforePriceLabel.topAnchor, constant: -2.0),
            titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -2.0),
            titleLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: gradationView.trailingAnchor,constant: -5.0),
            gradationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradationView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5.0)
        ])
        priceLabel.setContentCompressionResistancePriority(UILayoutPriority(50), for: .horizontal)
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
    }
    override func prepareForReuse() {
        self.productImageView.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
