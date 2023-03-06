import Foundation
import UIKit
import RxSwift
import RxCocoa

final class DetailProductViewController:UIViewController,Pr_ChildViewController{
    let productPriceView:DetailProductPriceView
    private let backButton:UIButton
    private let detailProductCollectionView:DetailProductCollectionView
    let viewModel:Pr_DetailProductViewControllerViewModel
    private let disposeBag:DisposeBag
    var completion: (() -> Void)?
    var animator:UIViewPropertyAnimator!
    var animatorState:AnimatorState = .bottom
    var heightConstraint:NSLayoutConstraint!
    var heightEndConstraint:NSLayoutConstraint!
    init(productPriceView:DetailProductPriceView,detailProductCollectionView:DetailProductCollectionView,viewModel:Pr_DetailProductViewControllerViewModel) {
        disposeBag = DisposeBag()
        backButton = UIButton()
        self.viewModel = viewModel
        self.detailProductCollectionView = detailProductCollectionView
        self.productPriceView = productPriceView
        super.init(nibName: nil, bundle: nil)
        bind()
        self.detailProductCollectionView.addGestureRecognizer(makeTapgesture())
        animator = returnAnimator()
    }
    private func bind(){
        backButton.rx.tap.bind(to: viewModel.backAction).disposed(by: disposeBag)
        viewModel.completionReloadData.subscribe(onNext:{
            [weak self] rect in
            self?.completion?()
        }).disposed(by: disposeBag)
        viewModel.buyProductBottonTapObservable.withUnretained(self).subscribe(onNext: {
            owner, _ in
            if owner.animatorState == .bottom{
                owner.animator.startAnimation()
            }else{
                owner.viewModel.buyProduct.onNext(())
            }
        }).disposed(by: disposeBag)
        viewModel.pangesture.withUnretained(self).subscribe(onNext: {
            owner,pan in
            switch pan.state{
            case .began:
                owner.animator.pauseAnimation()
            case .changed:
                let ratio = owner.animatorState == .bottom ? -(pan.point.y/(owner.view.frame.height*0.4)) : (pan.point.y/(owner.view.frame.height*0.4))
                let max = max(ratio, 0.0)
                owner.animator.fractionComplete = min(max,1.0)
            case .ended:
                owner.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
            default:
                break;

            }
        }).disposed(by: disposeBag)
        viewModel.tapGesture.withUnretained(self).subscribe(onNext: {
            owner,_ in
            if owner.animator.isRunning{
                print("RUNNING!")
                owner.animator.isReversed = owner.animatorState == .bottom ? true : false
                owner.animatorState = owner.animatorState == .top ? .bottom : .top
            }
            if !owner.animator.isRunning{
                owner.animator.startAnimation()
            }
        }).disposed(by: disposeBag)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    deinit {
        animator.stopAnimation(true)
        animator.removeObserver(self, forKeyPath: #keyPath(UIViewPropertyAnimator.isRunning))
        print("DEINIT!")
    }
    private func request(){
        viewModel.requestDetailProduct.onNext(())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layout()->UIView{
        let returnView = UIView()
        heightConstraint = NSLayoutConstraint(item: productPriceView, attribute: .height, relatedBy: .equal, toItem: returnView, attribute: .height, multiplier: 0.15, constant: 0.0)
        heightEndConstraint = NSLayoutConstraint(item: self.productPriceView, attribute: .height, relatedBy: .equal, toItem: returnView, attribute: .height, multiplier: 0.4, constant: 0.0)
        returnView.backgroundColor = .white
        returnView.addSubview(detailProductCollectionView)
        returnView.addSubview(backButton)
        returnView.addSubview(productPriceView)
        detailProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        detailProductCollectionView.topAnchor.constraint(equalTo: returnView.topAnchor).isActive = true
        detailProductCollectionView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor).isActive = true
        detailProductCollectionView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor).isActive = true
        productPriceView.translatesAutoresizingMaskIntoConstraints = false
        productPriceView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor).isActive = true
        productPriceView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor).isActive = true
        productPriceView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor).isActive = true
        heightConstraint.isActive = true
        detailProductCollectionView.bottomAnchor.constraint(equalTo: returnView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: returnView.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: 10.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.clipsToBounds = true
        backButton.tintColor = .systemYellow
        let buttonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(buttonImage, for: .normal)
        return returnView
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
}
