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
        ProductsListViewModel(UseCase: returnShowProductListUseCase(),ImageUseCase: returnShowProductImageUseCase())
    }
    private func returnProductListCollectionView(layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout, collectionViewCell: ProductListCollectionViewCell.self, cellIndentifier: ProductListCollectionViewCell.Identifier)
    }
    private func returnProductListCollectionViewLayout(returnImageHeightDelegate:ReturnImageHeightDelegate)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(delegate: returnImageHeightDelegate)
    }
    private func returnShowProductImageUseCase()->RequestingProductImage{
        ShowProductImageUseCase(productsImageRepository: returnProductsImageRepository())
    }
    private func returnProductsImageRepository()->TransferProductsImage{
        ProductsImageDataRepository()
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
        let viewModel = returnBindingProductsListViewModel()
        let collectionViewLayout = returnProductListCollectionViewLayout(returnImageHeightDelegate: viewModel)
        let collectionView = returnProductListCollectionView(layout: collectionViewLayout)
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
