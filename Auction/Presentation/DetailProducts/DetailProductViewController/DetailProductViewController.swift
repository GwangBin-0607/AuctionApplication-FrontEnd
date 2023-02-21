import Foundation
import UIKit

class DetailProductViewController:UIViewController,SetCoordinatorViewController{
    weak var delegate:TransitionDetailProductViewController?
    private let productPriceView:DetailProductPriceView
    private let detailProductCollectionView:DetailProductCollectionView
    private let viewModel:Pr_DetailProductViewControllerViewModel
    init(transitioning:TransitionDetailProductViewController?=nil,productPriceView:DetailProductPriceView,detailProductCollectionView:DetailProductCollectionView,viewModel:Pr_DetailProductViewControllerViewModel) {
        self.delegate = transitioning
        self.viewModel = viewModel
        self.detailProductCollectionView = detailProductCollectionView
        self.productPriceView = productPriceView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        let returnView = UIView()
        returnView.addSubview(detailProductCollectionView)
        detailProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        detailProductCollectionView.topAnchor.constraint(equalTo: returnView.topAnchor).isActive = true
        detailProductCollectionView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor).isActive = true
        detailProductCollectionView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor).isActive = true
        returnView.addSubview(productPriceView)
        productPriceView.translatesAutoresizingMaskIntoConstraints = false
        productPriceView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor).isActive = true
        productPriceView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor).isActive = true
        productPriceView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor).isActive = true
        NSLayoutConstraint(item: productPriceView, attribute: .height, relatedBy: .equal, toItem: returnView, attribute: .height, multiplier: 0.1, constant: 0.0).isActive = true
        detailProductCollectionView.bottomAnchor.constraint(equalTo: productPriceView.topAnchor).isActive = true
        self.view = returnView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
