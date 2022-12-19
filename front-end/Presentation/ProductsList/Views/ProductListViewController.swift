import UIKit
import RxSwift
import RxCocoa
import RxDataSources
final class ProductListViewController: UIViewController,SetCoordinatorViewController {
    private let viewModel:BindingProductsListViewModel
    private let disposeBag:DisposeBag
    private let collectionView:ProductListCollectionView
    private let categoryView:UIView
    weak var delegate:TransitionProductListViewController?
    let testButton=UIButton()
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
        testButtonSet()
//        setCADisplay()
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
    func testButtonSet(){
        self.view.addSubview(testButton)
        testButton.backgroundColor = .yellow
        testButton.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        testButton.addTarget(self, action: #selector(testAction), for: .touchUpInside)
    }
    @objc func testAction(){
        print("tap")
        
        viewModel.testFunction()
        //Test Action
//        self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 2, section: 0)])
//        self.viewModel.requestProductsList.onNext(1)
        //prepare 실행됨.
        //bind실행됨. 보이는 셀이 아니면 실행안되고 보이는 셀이면 실행됨.
        
//        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ProductListCollectionViewCell
//        cell?.bindingData.onNext(Product(product_id: 1, product_price: 200, imageURL: nil, product_name: "Change", checkUpDown: nil))
        //prepare 실행안됨.
        //bind 실행안됨.
        
    }
    private func bindingViewModel(){
        viewModel.responseImage.subscribe(onNext: {
            response in
            response.setImage()
        }).disposed(by: disposeBag)
        viewModel.productsList.map({
            products in
            let productTest = [ProductSection(sectionHeader: "header", products: products)]
            print(productTest)
            return productTest
        }).bind(to: collectionView.rx.items(dataSource: returnDatasource())).disposed(by: disposeBag)
//        viewModel.productsList.bind(to: collectionView.rx.items(cellIdentifier: ProductListCollectionViewCell.Identifier, cellType: ProductListCollectionViewCell.self)){
//            [weak self] rowNum,item,cell in
//            cell.bindingData.onNext(item)
//            let requestImage = RequestImage(cell:cell,productId: item.product_id, imageURL: item.imageURL)
//            self?.viewModel.requestImage.onNext(requestImage)
//        }.disposed(by: disposeBag)
        
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
extension ProductListViewController{
    func returnDatasource()->RxCollectionViewSectionedAnimatedDataSource<ProductSection>{
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade), decideViewTransition: {
            _,_,change in
            print(change)
            return .animated
        }, configureCell: { [weak self] dataSource, colview, indexpath, item in
            print(item.product_price)
            let cell = colview.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.Identifier, for: indexpath) as! ProductListCollectionViewCell
            cell.bindingData.onNext(item)
            let requestImage = RequestImage(cell: cell, productId: item.product_id, imageURL: item.imageURL)
            self?.viewModel.requestImage.onNext(requestImage)
            return cell
        })
    }
}
struct ProductSection{
    var sectionHeader:String
    var products:[Product]
}
extension ProductSection:AnimatableSectionModelType{
    var items: [Product] {
        products
    }
    
    init(original: ProductSection, items: [Product]) {
        self.products = items
        self = original
    }
    
    var identity: String {
        sectionHeader
    }
    
    
    
}
extension Product:IdentifiableType,Equatable{
    var identity: Int {
        product_id
    }
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.product_id == rhs.product_id
    }
}

