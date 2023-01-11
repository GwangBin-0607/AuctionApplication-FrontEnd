import UIKit
import RxSwift
import RxCocoa
import RxDataSources
final class ProductListViewController: UIViewController,SetCoordinatorViewController {
    private let viewModel:ProductListViewControllerViewModelInterface
    private let disposeBag:DisposeBag
    private let collectionView:UICollectionView
    private let categoryView:UIView
    weak var delegate:TransitionProductListViewController?
    init(viewModel:ProductListViewControllerViewModelInterface,CollectionView:UICollectionView,transitioning:TransitionProductListViewController?=nil) {
        self.delegate = transitioning
        self.viewModel = viewModel
        collectionView = CollectionView
        disposeBag = DisposeBag()
        categoryView = UIView()
        super.init(nibName: nil, bundle: nil)
    }
    deinit {
        print("Viewcontroller DEINIT")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        self.viewModel.requestProductsList.onNext(())
    }
    //    func setCADisplay(){
    //        let display = CADisplayLink(target: self, selector: #selector(displayCheck))
    //        display.add(to: .current, forMode: .tracking)
    //    }
    //    var previoutTime = 0.0
    //    @objc func displayCheck(displaylink:CADisplayLink){
    //        print("========================")
    //        print(previoutTime)
    //        var tum = displaylink.targetTimestamp - previoutTime
    //
    //        previoutTime = displaylink.targetTimestamp
    //        print(displaylink.targetTimestamp)
    //        print(tum)
    //        print("======================")
    //    }
    private func bindingViewModel(){
        viewModel.productsList.bind(to: collectionView.rx.items(dataSource: returnDatasource())).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.withUnretained(self).subscribe(onNext: {
            owner, indexpath in
            owner.viewModel.controlSocketState(state: .disconnect)
//            owner.dismiss(animated: true)
//            owner.delegate?.presentDetailViewController()
        }).disposed(by: disposeBag)
        collectionView.rx.didScroll.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.viewModel.scrollScrollView.onNext(owner.collectionView.indexPathsForVisibleItems.map({$0.item}))
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ProductListViewController{
    override func loadView() {
        super.loadView()
        self.view = setLayout()
    }
    private func setLayout()->UIView{
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.addSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.backgroundColor = .red
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            NSLayoutConstraint(item: categoryView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 0.08, constant: 0.0),
            collectionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
        ])
        return containerView
    }
}
extension ProductListViewController{
    private func returnDatasource()->RxCollectionViewSectionedAnimatedDataSource<ProductSection>{
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .left, deleteAnimation: .fade), decideViewTransition: {
            _,_,change in
            print(change)
            return .animated
        }, configureCell: { _ , colview, indexpath, item in
            let cell = colview.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.Identifier, for: indexpath) as! ProductListCollectionViewCell
            cell.bindingData.onNext(item)
            return cell
        })
    }
}

