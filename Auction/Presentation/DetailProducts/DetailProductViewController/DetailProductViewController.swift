import Foundation
import UIKit

class DetailProductViewController:UIViewController,SetCoordinatorViewController{
    weak var delegate:TransitionDetailProductViewController?
    init(transitioning:TransitionDetailProductViewController?=nil) {
        self.delegate = transitioning
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        let returnView = UIView()
        let r = DetailProductRepository(httpService: ProductHTTP(ProductListURL: URL(string: "111")!, ProductImageURL: URL(string: "111")!), httpDetailProductTransfer: HTTPDataTransferDetailProduct())
        let u = DetailProductUsecase(detailProductRepository: r)
        let vm = DetailProductCollectionViewModel(detailProductUsecase: u)
        let a = DetailProductCollectionView(viewModel: vm)
        returnView.addSubview(a)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.topAnchor.constraint(equalTo: returnView.topAnchor).isActive = true
        a.leadingAnchor.constraint(equalTo: returnView.leadingAnchor).isActive = true
        a.trailingAnchor.constraint(equalTo: returnView.trailingAnchor).isActive = true
        a.bottomAnchor.constraint(equalTo: returnView.bottomAnchor).isActive = true
        self.view = returnView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1111")
    }
}
