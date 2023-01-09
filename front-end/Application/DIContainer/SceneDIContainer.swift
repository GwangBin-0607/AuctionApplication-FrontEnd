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
    private func returnProductListCollectionView(viewModel:ProductListCollectionViewModelInterface,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,viewModel: viewModel, collectionViewCell: ProductListCollectionViewCell.self, cellIndentifier: ProductListCollectionViewCell.Identifier)
    }
    private func returnProductListCollectionViewLayout(viewModel:ProductListCollectionViewLayoutViewModelInterface)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(viewModel: viewModel)
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
        ProductListViewModel(UseCase: returnProductListUsecaseInterface(), ImageUseCase: returnShowProductImageHeightUseCase())
    }
    private func returnProductListUsecaseInterface()->ProductListUsecaseInterface{
        ProductListUsecase(repo: returnProductListRepositoryInterface())
    }
    private func returnProductListRepositoryInterface()->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: MockProductsListAPI(), StreamingService: SocketAdd<StreamPrice>(socketNetwork: returnStreamingService(), socketInput: InputStreamDataTransfer(), socketOutput: OutputStreamDataTransfer(), socketCompletionHandler: OutputStreamCompletionHandler()))
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
        let collectionViewLayout = returnProductListCollectionViewLayout(viewModel: viewModel)
        let collectionView = returnProductListCollectionView(viewModel:viewModel, layout: collectionViewLayout)
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
