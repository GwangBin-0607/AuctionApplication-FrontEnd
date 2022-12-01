import UIKit
import RxSwift
import RxCocoa
final class ProductListViewController: UIViewController,SetCoordinatorViewController {
    private let viewModel:BindingProductsListViewModel
    private let disposeBag:DisposeBag
    private let collectionView:ProductListCollectionView
    private let categoryView:UIView
    let delegate:TransitionProductListViewController?
    init(viewModel:BindingProductsListViewModel,CollectionView:ProductListCollectionView,transitioning:TransitionProductListViewController?=nil) {
        self.delegate = transitioning
        self.viewModel = viewModel
        collectionView = CollectionView
        disposeBag = DisposeBag()
        categoryView = UIView()
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        self.viewModel.requestProductsList.onNext(1)
    }
    private func bindingViewModel(){
        collectionView.indexObservable.withUnretained(self).subscribe(onNext: {
            owner,indexpath in
                owner.viewModel.requestProductImageHeight.onNext(indexpath)
            
        }).disposed(by: disposeBag)
        viewModel.responseProductImageHeight.withUnretained(self).subscribe(onNext: {
            owner,requestImageHeight in
            owner.collectionView.imageObserver.onNext(requestImageHeight)
        }).disposed(by: disposeBag)
        viewModel.responseProductImage.subscribe(onNext: {
            responseImage in
            responseImage.cell.imageBinding.onNext(responseImage)
        }).disposed(by: disposeBag)
        viewModel.productsList.bind(to: collectionView.rx.items(cellIdentifier: ProductListCollectionViewCell.Identifier, cellType: ProductListCollectionViewCell.self)){
            [weak self] indexpath,item, cell in
            cell.tag = indexpath
            let imageProperty = RequestImage(cell:cell, imageURL: item.imageURL!,tag: indexpath)
            cell.bindingData.onNext(item)
            self?.viewModel.requestProductImage.onNext(imageProperty)
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.withUnretained(self).subscribe(onNext: {
            owner, indexpath in
            owner.delegate?.presentDetailViewController()
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

