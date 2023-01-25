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
    private func returnStreamingService()->SocketNetworkInterface{
//        SocketNetwork(hostName: "ec2-13-125-247-240.ap-northeast-2.compute.amazonaws.com", portNumber: 8100)
        SocketNetwork(hostName: "localhost", portNumber: 3200)
    }
}

//MARK: Repository
extension SceneDIContainer{
    private func returnProductCacheImageRepository()->ProductImageCacheRepositoryInterface{
        ProductImageCacheRepository()
    }
    private func returnProductsImageRepository()->ProductImageRepositoryInterface{
        ProductImageRepository(ImageServer: returnHTTPImageService(),CacheRepository: returnProductCacheImageRepository())
    }
    private func returnProductListRepositoryInterface()->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: MockProductsListAPI(), StreamingService:returnStreamingService(),TCPStreamDataTransfer: returnTCPStreamDataTransferInterface(),ProductListState: returnProductListState())
    }
    private func returnProductListState()->ProductListStateInterface{
        ProductListState()
    }
    private func returnTCPStreamDataTransferInterface()->TCPStreamDataTransferInterface{
        TCPStreamDataTransfer(inputStreamDataTransfer: returnInputStreamDataTransfer(), outputStreamDataTransfer: returnOutputStreamDataTransfer(), outputStreamCompletionHandler: returnOutputStreamCompletionHandler())
    }
    private func returnInputStreamDataTransfer()->InputStreamDataTransferInterface{
        InputStreamDataTransfer()
    }
    private func returnOutputStreamDataTransfer()->OutputStreamDataTransferInterface{
        OutputStreamDataTransfer()
    }
    private func returnOutputStreamCompletionHandler()->OutputStreamCompletionHandlerInterface{
        OutputStreamCompletionHandler()
    }
}

//MARK: Usecase
extension SceneDIContainer{
    private func returnProductListUsecaseInterface(ImageHeightRepository:ProductImageRepositoryInterface)->Pr_ProductListWithImageHeightUsecase{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(), ImageHeightRepo: ImageHeightRepository)
    }
    private func returnProductImageLoadUsecase(ImageLoadRepository:ProductImageRepositoryInterface)->Pr_ProductImageLoadUsecase{
        ProductImageLoadUseCase(productsImageRepository: ImageLoadRepository)
    }
}

//MARK: ViewModel,View
extension SceneDIContainer{
    private func returnProductListCollectionViewCellViewModel(ImageUsecase:Pr_ProductImageLoadUsecase)->Pr_ProductListCollectionViewCellViewModel{
        ProductListCollectionViewCellViewModel(ImageUsecase: ImageUsecase)
    }
    private func returnProductListCollectionViewModel(ImageRepository:ProductImageRepositoryInterface)->Pr_ProductListCollectionViewModel&Pr_Out_ProductListCollectionViewLayoutViewModel{
        let listUsecase = returnProductListUsecaseInterface(ImageHeightRepository: ImageRepository)
        let imageLoadUsecase = returnProductImageLoadUsecase(ImageLoadRepository: ImageRepository)
        let cellViewModel = returnProductListCollectionViewCellViewModel(ImageUsecase: imageLoadUsecase)
        return ProductListCollectionViewModel(UseCase: listUsecase,CellViewModel: cellViewModel)
    }
    private func returnProductListCollectionView(viewModel:Pr_Out_ProductListCollectionViewModel,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,viewModel: viewModel, collectionViewCell: ProductListCollectionViewCell.self, cellIndentifier: ProductListCollectionViewCell.Identifier)
    }
    private func returnProductListCollectionViewLayout(viewModel:Pr_Out_ProductListCollectionViewLayoutViewModel)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(viewModel: viewModel)
    }
    private func returnProductListViewModelInterface(collectionViewModel:Pr_In_ProductListCollectionViewModel)->Pr_ProductListViewControllerViewModel{
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
        let imageRepository = returnProductsImageRepository()
        let collectionViewModel = returnProductListCollectionViewModel(ImageRepository: imageRepository)
        let viewModel = returnProductListViewModelInterface(collectionViewModel: collectionViewModel)
        let collectionViewLayout = returnProductListCollectionViewLayout(viewModel: collectionViewModel)
        let collectionView = returnProductListCollectionView(viewModel:collectionViewModel, layout: collectionViewLayout)
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
