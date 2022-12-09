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
        collectionView.delegateHeight = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        self.viewModel.requestProductsList.onNext(1)
    }
    private func bindingViewModel(){
        viewModel.responseProductImage.subscribe(onNext: {
            responseImage in
            responseImage.setImageToCell()
        }).disposed(by: disposeBag)
        viewModel.productsList.bind(to: collectionView.rx.items(cellIdentifier: ProductListCollectionViewCell.Identifier, cellType: ProductListCollectionViewCell.self)){
            [weak self] rowNum,item, cell in
            cell.tag = rowNum
            cell.bindingData.onNext(item)
            let requestImage = RequestImage(Cell:cell,ProductId: item.product_id,ImageURL: item.imageURL,RowNum: rowNum)
            self?.viewModel.requestProductImage.onNext(requestImage)
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
extension ProductListViewController:ReturnImageHeightUICollectionViewDelegate{
    func returnImageHeightFromViewModel(index: IndexPath) -> CGFloat {
        viewModel.returnHeight(index: index)
    }
}

