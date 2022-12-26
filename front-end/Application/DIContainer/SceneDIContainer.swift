import Foundation
import UIKit
class SceneDIContainer{
    private func returnHTTPService()->GetProductsList{
        ProductsListHTTP(ServerURL: "11111")
    }
    private func returnStreamingService()->StreamingData{
        SocketNetwork(hostName: "localhost", portNumber: 8100)
    }
    private func returnProductListCollectionView(viewModel:ProductsListViewModelInterface,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,viewModel: viewModel, collectionViewCell: ProductListCollectionViewCell.self, cellIndentifier: ProductListCollectionViewCell.Identifier)
    }
    private func returnProductListCollectionViewLayout(returnImageHeightDelegate:ProductsListViewModelInterface)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(delegate: returnImageHeightDelegate)
    }
    private func returnShowProductImageUseCase()->ProductImageUsecaseInterface{
        ProductImageUseCase(productsImageRepository: returnProductsImageRepository())
    }
    private func returnProductsImageRepository()->ProductImageRepositoryInterface{
        ProductImageRepository()
    }
 
}
extension SceneDIContainer{
    private func returnProductListViewModelInterface()->ProductsListViewModelInterface{
        ProductListViewModel(UseCase: returnProductListUsecaseInterface(), ImageUseCase: returnShowProductImageUseCase())
    }
    private func returnProductListUsecaseInterface()->ProductListUsecaseInterface{
        ProductListUsecase(repo: returnProductListRepositoryInterface())
    }
    private func returnProductListRepositoryInterface()->ProductListRepositoryInterface{
        ProductListRepository(ApiService: returnHTTPService(), StreamingService: returnStreamingService())
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
        let collectionViewLayout = returnProductListCollectionViewLayout(returnImageHeightDelegate: viewModel)
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
