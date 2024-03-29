import UIKit
import RxSwift
import RxCocoa
import RxDataSources
final class ProductListViewController: UIViewController {
    private let viewModel:Pr_ProductListViewControllerViewModel
    private let disposeBag:DisposeBag
    private let collectionView:ProductListCollectionView
    private let errorView:ErrorAlterView
    init(viewModel:Pr_ProductListViewControllerViewModel,CollectionView:ProductListCollectionView,ErrorAlterView:ErrorAlterView) {
        self.viewModel = viewModel
        collectionView = CollectionView
        disposeBag = DisposeBag()
        errorView = ErrorAlterView
        super.init(nibName: nil, bundle: nil)
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.requestProductListObserver.onNext(())
    }
    private func bind(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        collectionView.stopScroll()
//    }
    
}
extension ProductListViewController{
    override func loadView() {
        super.loadView()
        self.view = setLayout()
    }
    private func setLayout()->UIView{
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            errorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            NSLayoutConstraint(item: errorView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 0.4, constant: 0.0),
            NSLayoutConstraint(item: errorView, attribute: .height, relatedBy: .equal, toItem: errorView, attribute: .width, multiplier: 0.3, constant: 0.0)
        ])
        return containerView
    }
}

