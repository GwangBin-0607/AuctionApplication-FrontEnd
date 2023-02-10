import Foundation
import UIKit


final class SceneDIContainer{}

//MARK: Infrastructure
extension SceneDIContainer{
     func returnHTTPImageService()->GetProductImage{
        ProductImageAPI()
    }
     func returnHTTPService()->GetProductsList{
        ProductsListHTTP(ServerURL: "http://localhost:3100/products/alllist")
    }
     func returnStreamingService()->SocketNetworkInterface{
//        SocketNetwork(hostName: "ec2-13-125-247-240.ap-northeast-2.compute.amazonaws.com", portNumber: 8100)
        SocketNetwork(hostName: "localhost", portNumber: 3200)
    }
}

//MARK: Repository
extension SceneDIContainer{
     func returnProductCacheImageRepository()->ProductImageCacheRepositoryInterface{
        ProductImageCacheRepository()
    }
     func returnProductsImageRepository()->ProductImageRepositoryInterface{
        ProductImageRepository(ImageServer: returnHTTPImageService(),CacheRepository: returnProductCacheImageRepository())
    }
     func returnProductListRepositoryInterface()->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: returnHTTPService(), StreamingService:returnStreamingService(),TCPStreamDataTransfer: returnTCPStreamDataTransferInterface(),ProductListState: returnProductListState(),HTTPDataTransfer: returnHTTPDataTransfer())
    }
     func returnProductListState()->ProductListStateInterface{
        ProductListState()
    }
     func returnTCPStreamDataTransferInterface()->TCPStreamDataTransferInterface{
        TCPStreamDataTransfer(inputStreamDataTransfer: returnInputStreamDataTransfer(), outputStreamDataTransfer: returnOutputStreamDataTransfer(), outputStreamCompletionHandler: returnOutputStreamCompletionHandler())
    }
     func returnInputStreamDataTransfer()->InputStreamDataTransferInterface{
        InputStreamDataTransfer()
    }
     func returnOutputStreamDataTransfer()->OutputStreamDataTransferInterface{
        OutputStreamDataTransfer()
    }
     func returnOutputStreamCompletionHandler()->OutputStreamCompletionHandlerInterface{
        OutputStreamCompletionHandler()
    }
     func returnHTTPDataTransfer()->Pr_HTTPDataTransfer{
        HTTPDataTransfer()
    }
}

//MARK: Usecase
extension SceneDIContainer{
     func returnProductListUsecaseInterface(ImageHeightRepository:ProductImageRepositoryInterface)->Pr_ProductListWithImageHeightUsecase{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(), ImageHeightRepo: ImageHeightRepository)
    }
     func returnProductImageLoadUsecaseInterface(ImageLoadRepository:ProductImageRepositoryInterface)->Pr_ProductImageLoadUsecase{
        ProductImageLoadUseCase(productsImageRepository: ImageLoadRepository)
    }
}

//MARK: ViewModel,View
extension SceneDIContainer{
     func returnProductListCollectionViewCellViewModel(ImageUsecase:Pr_ProductImageLoadUsecase)->Pr_ProductListCollectionViewCellViewModel{
        ProductListCollectionViewCellViewModel(ImageUsecase: ImageUsecase)
    }
     func returnProductListCollectionViewModel(ImageRepository:ProductImageRepositoryInterface)->Pr_ProductListCollectionViewModel&Pr_ProductListCollectionViewLayoutViewModel{
        let listUsecase = returnProductListUsecaseInterface(ImageHeightRepository: ImageRepository)
        let imageLoadUsecase = returnProductImageLoadUsecaseInterface(ImageLoadRepository: ImageRepository)
        let cellViewModel = returnProductListCollectionViewCellViewModel(ImageUsecase: imageLoadUsecase)
        return ProductListCollectionViewModel(UseCase: listUsecase,CellViewModel: cellViewModel,FooterViewModel: returnProductListCollectionFooterViewModel())
    }
     func returnProductListCollectionView(viewModel:Pr_ProductListCollectionViewModel,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,viewModel: viewModel)
    }
     func returnProductListCollectionViewLayout(viewModel:Pr_ProductListCollectionViewLayoutViewModel)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(viewModel: viewModel)
    }
     func returnProductListViewModelInterface(collectionViewModel:Pr_ProductListCollectionViewModel,errorAlterViewModel:Pr_ErrorAlterViewModel)->Pr_ProductListViewControllerViewModel{
        ProductListViewControllerViewModel(collectionViewModel:collectionViewModel,ErrorAlterViewModel:errorAlterViewModel)
    }
     func returnProductListCollectionFooterViewModel()->Pr_ProductListCollectionFooterViewModel{
        ProductListCollectionFooterViewModel()
    }
     func returnErrorAlterView(errorAlterViewModel:Pr_ErrorAlterViewModel)->ErrorAlterView{
        ErrorAlterView(viewModel: errorAlterViewModel)
    }
     func returnErrorAlterViewModel()->Pr_ErrorAlterViewModel{
        ErrorAlterViewModel()
    }

 
}
protocol MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController)->Coordinator
    func returnMainContainerViewController(setBackgroundColor:UIColor,borderWidth:CGFloat,borderColor:UIColor)->MainContainerViewController
}

//MARK: ProductList Coordinator
extension SceneDIContainer:MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController)->Coordinator{
        ProductListViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self)
    }
    func returnMainContainerViewController(setBackgroundColor:UIColor,borderWidth:CGFloat,borderColor:UIColor) -> MainContainerViewController {
        let navigationCircleViewModel = returnNavigationCircleViewModel()
        let navigationCircleView = returnNavigationCornerRadiusView(setBackgroundColor: setBackgroundColor, navigationCircleViewModel: navigationCircleViewModel,borderWidth: borderWidth,borderColor: borderColor)
        let mainContainerControllerViewModel = returnMainContainerControllerViewModel(navigationCircleViewModel: navigationCircleViewModel)
        return MainContainerViewController(navigationCircleView: navigationCircleView, viewModel: mainContainerControllerViewModel)
    }
    func returnMainContainerControllerViewModel(navigationCircleViewModel:Pr_NavigationCircleViewModel)->Pr_MainContainerControllerViewModel{
        MainContainerControllerViewModel(navigationCircleViewModel:navigationCircleViewModel)
    }
    private func returnNavigationCornerRadiusView(setBackgroundColor:UIColor,navigationCircleViewModel:Pr_NavigationCircleViewModel,borderWidth:CGFloat,borderColor:UIColor)->NavigationCornerRadiusView{
        NavigationCornerRadiusView(setBackgroundColor: setBackgroundColor, ViewModel: navigationCircleViewModel,borderWidth: borderWidth,borderColor: borderColor)
    }
    private func returnNavigationCircleViewModel()->Pr_NavigationCircleViewModel{
        NavigationCircleViewModel()
    }
}
protocol ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController?) -> UIViewController
    func returnDetailProductViewCoordinator(ContainerViewController:ContainerViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator
}

//MARK: ProductListViewController, DetailProductViewCoordinator
extension SceneDIContainer:ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController?=nil) -> UIViewController {
        let imageRepository = returnProductsImageRepository()
        let collectionViewModel = returnProductListCollectionViewModel(ImageRepository: imageRepository)
        let errorAlterViewModel = returnErrorAlterViewModel()
        let errorAlterView = returnErrorAlterView(errorAlterViewModel: errorAlterViewModel)
        let viewModel = returnProductListViewModelInterface(collectionViewModel: collectionViewModel,errorAlterViewModel: errorAlterViewModel)
        let collectionViewLayout = returnProductListCollectionViewLayout(viewModel: collectionViewModel)
        let collectionView = returnProductListCollectionView(viewModel:collectionViewModel, layout: collectionViewLayout)
        let productListViewController = ProductListViewController(viewModel: viewModel, CollectionView: collectionView,transitioning: transitioning,ErrorAlterView: errorAlterView)
        return productListViewController
    }
    func returnDetailProductViewCoordinator(ContainerViewController:ContainerViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator{
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
