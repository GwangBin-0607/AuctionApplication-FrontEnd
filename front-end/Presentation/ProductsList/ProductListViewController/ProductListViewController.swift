import UIKit
import RxSwift
import RxCocoa
import RxDataSources
final class ProductListViewController: UIViewController,SetCoordinatorViewController {
    private let viewModel:Pr_In_ProductListViewControllerViewModel
    private let disposeBag:DisposeBag
    private let collectionView:ProductListCollectionView
    private let categoryView:UIView
    weak var delegate:TransitionProductListViewController?
    init(viewModel:Pr_In_ProductListViewControllerViewModel,CollectionView:ProductListCollectionView,transitioning:TransitionProductListViewController?=nil) {
        self.delegate = transitioning
        self.viewModel = viewModel
        collectionView = CollectionView
        disposeBag = DisposeBag()
        categoryView = UIView()
        super.init(nibName: nil, bundle: nil)
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
//        setCADisplay()
    }
//        func setCADisplay(){
//            let display = CADisplayLink(target: self, selector: #selector(displayCheck))
//            display.add(to: .current, forMode: .tracking)
//        }
//        var previoutTime = 0.0
//        @objc func displayCheck(displaylink:CADisplayLink){
//            print("========================")
//            print(previoutTime)
//            var tum = displaylink.targetTimestamp - previoutTime
//
//            previoutTime = displaylink.targetTimestamp
//            print(displaylink.targetTimestamp)
//            print(tum)
//            print("======================")
//        }
    private func bindingViewModel(){
        self.viewModel.requestProductList.onNext(())

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

