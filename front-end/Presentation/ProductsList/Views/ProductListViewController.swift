import UIKit
import RxSwift
import RxCocoa
final class ProductListViewController: UIViewController,SetCoordinatorViewController {
    private let viewModel:BindingProductsListViewModel
    private let disposeBag:DisposeBag
    private let collectionView:ProductListCollectionView
    private let categoryView:UIView
    let delegate:TransitionProductListViewController?
    let testButton=UIButton()
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
        testButtonSet()
    }
    func testButtonSet(){
        self.view.addSubview(testButton)
        testButton.backgroundColor = .yellow
        testButton.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        testButton.addTarget(self, action: #selector(testAction), for: .touchUpInside)
    }
    @objc func testAction(){
        //Test Action
//        self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//        self.viewModel.requestProductsList.onNext(1)
        //prepare 실행됨.
        //bind실행됨. 보이는 셀이 아니면 실행안되고 보이는 셀이면 실행됨.
        
        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ProductListCollectionViewCell
        cell?.bindingData.onNext(Product(product_id: 1, product_price: 200, imageURL: nil, product_name: "Change", checkUpDown: nil))
        //prepare 실행안됨.
        //bind 실행안됨.
    }
    private func bindingViewModel(){
        viewModel.responseImage.subscribe(onNext: {
            response in
            response.setImage()
        }).disposed(by: disposeBag)
        viewModel.productsList.bind(to: collectionView.rx.items(cellIdentifier: ProductListCollectionViewCell.Identifier, cellType: ProductListCollectionViewCell.self)){
            [weak self] rowNum,item,cell in
            print("Bind!")
            cell.bindingData.onNext(item)
            let requestImage = RequestImage(cell:cell,productId: item.product_id, imageURL: item.imageURL)
            self?.viewModel.requestImage.onNext(requestImage)
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

