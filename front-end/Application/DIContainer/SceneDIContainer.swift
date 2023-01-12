import Foundation
import UIKit
class SceneDIContainer{
    private func returnHTTPImageService()->GetProductImage{
        ProductImageAPI()
    }
    private func returnHTTPService()->GetProductsList{
        ProductsListHTTP(ServerURL: "http://localhost:3100/products/alllist")
    }
    private func returnSocketNWConnection()->SocketNetworkInterface{
        SocketNWConnection(Host: "localhost", Port: 3200)
    }
    private func returnStreamingService()->SocketNetworkInterface{
        SocketNetwork(hostName: "localhost", portNumber: 3200)
    }
    private func returnProductListCollectionView(delegate:ReturnPriceWhenReloadCellInterface,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,delegate: delegate, collectionViewCell: ProductListCollectionViewCell.self, cellIndentifier: ProductListCollectionViewCell.Identifier)
    }
    private func returnProductListCollectionViewLayout(delegate:ReturnImageHeightWhenPrepareCollectionViewLayoutInterface)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(delegate: delegate)
    }
    private func returnShowProductImageHeightUseCase()->ProductImageHeightUsecaseInterface{
        ProductImageHeightUseCase(productsImageRepository: returnProductsImageRepository())
    }
    private func returnProductsImageRepository()->ProductImageRepositoryInterface{
        ProductImageRepository(ImageServer: returnHTTPImageService())
    }
 
}
extension SceneDIContainer{
    private func returnProductListViewModelInterface()->ProductListViewModel{
        ProductListViewModel(UseCase: returnProductListUsecaseInterface())
    }
    private func returnProductListUsecaseInterface()->ProductListWithImageHeightUsecaseInterface{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(), ImageHeightRepo: returnProductsImageRepository())
    }
    private func returnProductListRepositoryInterface()->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: MockProductsListAPI(), StreamingService: returnStreamingService(),TCPStreamDataTransfer: returnTCPStreamDataTransferInterface(),ProductListState: returnProductListState())
    }
    private func returnProductListState()->ProductListStateInterface{
        ProductListState()
    }
    private func returnTCPStreamDataTransferInterface()->TCPStreamDataTransferInterface{
        TCPStreamDataTransfer()
    }
}
protocol MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:TransitioningViewController)->Coordinator
}
extension SceneDIContainer:MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:TransitioningViewController)->Coordinator{
        ProductListViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self)
    }
}
protocol ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController?) -> UIViewController
    func returnDetailProductViewCoordinator(ContainerViewController:TransitioningViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator
}
extension SceneDIContainer:ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController?=nil) -> UIViewController {
        let viewModel = returnProductListViewModelInterface()
        let collectionViewLayout = returnProductListCollectionViewLayout(delegate: viewModel)
        let collectionView = returnProductListCollectionView(delegate:viewModel, layout: collectionViewLayout)
        let productListViewController = ProductListViewController(viewModel: viewModel, CollectionView: collectionView,transitioning: transitioning)
        return productListViewController
    }
    func returnDetailProductViewCoordinator(ContainerViewController:TransitioningViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator{
        DetailProductViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self, DetailProductViewCoordinatorDelegate:HasChildCoordinator)
    }
}
protocol DetailProductViewSceneDIContainer{
    func returnDetailViewController(transitioning:TransitionDetailProductViewController?) -> UIViewController
}
extension SceneDIContainer:DetailProductViewSceneDIContainer{
    func returnDetailViewController(transitioning:TransitionDetailProductViewController?=nil) -> UIViewController {
        DetailProductViewController(transitioning: transitioning)
    }
}
