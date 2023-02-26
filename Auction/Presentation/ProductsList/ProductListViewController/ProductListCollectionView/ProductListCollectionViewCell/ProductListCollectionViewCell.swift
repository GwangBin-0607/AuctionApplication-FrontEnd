import UIKit
import RxSwift
struct AnimtionValue{
    let product_id:Int
    let price:Int
    let state:Bool
    let beforePrice:Int
}
struct WithTag<T>{
    let ge:T
    let tag:Int
}
final class ProductListCollectionViewCell: UICollectionViewCell{
    static let Identifier:String = "ProductListCollectionViewCell"
    private let titleLabel:UILabel
    private let priceLabel:UILabel
    let productImageView:UIImageView
    private let checkUpDown:UIImageView
    private let disposeBag:DisposeBag
    private let gradationView:GradationView
    private let beforePriceLabel:UILabel
    // MARK: OUTPUT
    let bindingData:AnyObserver<Product>
    let animationObserver: AnyObserver<AnimtionValue?>
    private var viewModel:Pr_ProductListCollectionViewCellViewModel!
    private let bindingObservable:Observable<Product>
    private let animationObservable:Observable<AnimtionValue?>
    override init(frame: CGRect) {
        gradationView = GradationView()
        let data = PublishSubject<Product>()
        bindingObservable = data.asObservable()
        beforePriceLabel = UILabel()
        titleLabel = UILabel()
        priceLabel = UILabel()
        productImageView = UIImageView()
        checkUpDown = UIImageView()
        disposeBag = DisposeBag()
        bindingData = data.asObserver()
        let animationSubject = PublishSubject<AnimtionValue?>()
        animationObserver = animationSubject.asObserver()
        animationObservable = animationSubject.asObservable()
        super.init(frame: frame)
        layoutContentView()
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
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
            bind()
        }
    }
    private func bind(){
        viewModel.titleObservable.withUnretained(self).subscribe(onNext: {
            owner,arg1 in
            let (text,tag) = arg1
            if (tag == owner.tag){
                owner.titleLabel.text = text
            }
        }).disposed(by: disposeBag)
        viewModel.checkObservable.withUnretained(self).subscribe(onNext: {
            owner,arg1 in
            let (image,tag) = arg1
            if (tag == owner.tag){
                owner.checkUpDown.image = image
            }
        }).disposed(by: disposeBag)
        viewModel.beforePrice.withUnretained(self).subscribe(onNext: {
            owner,arg1 in
            let (text,tag) = arg1
            if (tag == owner.tag){
                owner.beforePriceLabel.text = text
            }
        }).disposed(by: disposeBag)
        viewModel.priceObservable.withUnretained(self).subscribe(onNext: {
            owner,arg1 in
            let (text,tag) = arg1
            if (tag == owner.tag){
                owner.priceLabel.text = text
            }
        }).disposed(by: disposeBag)
        viewModel.imageObservable.withUnretained(self).subscribe(onNext: {
            owner,cellImageTag in
            if(cellImageTag.tag == owner.tag){
                owner.productImageView.image = cellImageTag.image
            }
        }).disposed(by: disposeBag)
        bindingObservable.withUnretained(self).do(onNext: {
            owner,product in
            print(product.product_id)
            owner.tag = product.product_id
        }).subscribe(onNext: {
            owner,product in
            owner.viewModel.dataObserver.onNext(product)
        }).disposed(by: disposeBag)
        animationObservable.withUnretained(self).subscribe(onNext: {
            owner,animationValue in
            owner.viewModel.animationObserver.onNext(animationValue)
        }).disposed(by: disposeBag)
        viewModel.textColorObservable.withUnretained(self).subscribe(onNext: {
            owner,state in
            if state.1 == owner.tag{
                owner.priceLabel.textColor = owner.textColorPriceLabel(state: state.0)
                owner.beforePriceLabel.textColor = owner.textColorBeforePriceLabel(state: state.0)
            }
        }).disposed(by: disposeBag)
        viewModel.triggerAnimation.withUnretained(self).subscribe(onNext: {
            owner,tu in
            if tu.1 == owner.tag{
                owner.animateBorderColor(duration: 0.3)
            }
        }).disposed(by: disposeBag)
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
        CATransaction.commit()
    }
    
    private func layoutContentView(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = ManageColor.singleton.getMainColor().withAlphaComponent(0.75).cgColor
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
        priceLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
    }
    override func prepareForReuse() {
        self.productImageView.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
