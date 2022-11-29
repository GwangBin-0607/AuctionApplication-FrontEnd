import Foundation
import UIKit
class SceneDIContainer{
    private func returnShowProductListUseCase()->ShowProductsList{
        ShowProductsListUseCase(ProductsListRepository: returnProductsListRepository(), ProductPriceRepository: returnProductPriceRepository())
    }
    private func returnProductsListRepository()->FetchingProductsListData{
        ProductsListRepository(ApiService: returnHTTPService())
    }
    private func returnHTTPService()->GetProductsList{
        ProductsListHTTP(ServerURL: "11111")
    }
    private func returnProductPriceRepository()->TransferProductPriceDataInput&ObserverSocketState{
        ProductPriceRepository(StreamingService: returnStreamingService())
    }
    private func returnStreamingService()->StreamingData{
        SocketNetwork(hostName: "localhost", portNumber: 8100)
    }
    private func returnBindingProductsListViewModel()->BindingProductsListViewModel{
        ProductsListViewModel(UseCase: returnShowProductListUseCase())
    }
    func returnProductsListViewController(transitioning:TransitionProductListViewController?=nil) -> UIViewController {
        ProductListViewController(viewModel: returnBindingProductsListViewModel(), CollectionView: ProductListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()),transitioning: transitioning)
    }
    func returnDetailViewController(transitioning:TransitionDetailProductViewController?=nil) -> UIViewController {
        DetailProductViewController(transitioning: transitioning)
    }
    func returnProductListViewCoordinator(ContainerViewController:TransitioningViewController)->Coordinator{
        ProductListViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self)
    }
    func returnDetailProductViewCoordinator(ContainerViewController:TransitioningViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator{
        DetailProductViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self, DetailProductViewCoordinatorDelegate:HasChildCoordinator)
    }
}
