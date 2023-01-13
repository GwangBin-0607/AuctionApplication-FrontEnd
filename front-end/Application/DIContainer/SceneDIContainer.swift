import Foundation
import UIKit


class SceneDIContainer{}

//MARK: Infrastructure
extension SceneDIContainer{
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
}

//MARK: Repository
extension SceneDIContainer{
    private func returnProductsImageRepository()->ProductImageRepositoryInterface{
        ProductImageRepository(ImageServer: returnHTTPImageService())
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

//MARK: Usecase
extension SceneDIContainer{
    private func returnProductListUsecaseInterface()->ProductListWithImageHeightUsecaseInterface{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(), ImageHeightRepo: returnProductsImageRepository())
    }
}

//MARK: ViewModel,View
extension SceneDIContainer{
    private func returnProductListCollectionViewModel()->ProductListCollectionViewModel{
        ProductListCollectionViewModel(UseCase: returnProductListUsecaseInterface())
    }
    private func returnProductListCollectionView(delegate:Out_ProductListCollectionViewModelInterface,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,delegate: delegate, collectionViewCell: ProductListCollectionViewCell.self, cellIndentifier: ProductListCollectionViewCell.Identifier)
    }
    private func returnProductListCollectionViewLayout(delegate:ProductListCollectionViewLayoutViewModelInterface)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(delegate: delegate)
    }
    private func returnProductListViewModelInterface(collectionViewModel:In_ProductListCollectionViewModelInterface)->ProductListViewControllerViewModelInterface{
        ProductListViewControllerViewModel(collectionViewModel:collectionViewModel)
    }

 
}
protocol MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:TransitioningViewController)->Coordinator
}

//MARK: ProductList Coordinator
extension SceneDIContainer:MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:TransitioningViewController)->Coordinator{
        ProductListViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self)
    }
}
protocol ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController?) -> UIViewController
    func returnDetailProductViewCoordinator(ContainerViewController:TransitioningViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator
}

//MARK: ProductListViewController, DetailProductViewCoordinator
extension SceneDIContainer:ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController?=nil) -> UIViewController {
        let collectionViewModel = returnProductListCollectionViewModel()
        let viewModel = returnProductListViewModelInterface(collectionViewModel: collectionViewModel)
        let collectionViewLayout = returnProductListCollectionViewLayout(delegate: collectionViewModel)
        let collectionView = returnProductListCollectionView(delegate:collectionViewModel, layout: collectionViewLayout)
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

//MARK: DetailViewController
extension SceneDIContainer:DetailProductViewSceneDIContainer{
    func returnDetailViewController(transitioning:TransitionDetailProductViewController?=nil) -> UIViewController {
        DetailProductViewController(transitioning: transitioning)
    }
}
