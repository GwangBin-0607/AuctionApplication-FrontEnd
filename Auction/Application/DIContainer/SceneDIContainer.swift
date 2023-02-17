import Foundation
import UIKit


final class SceneDIContainer{
    let configure = ExportConfigure()
}

//MARK: Infrastructure
extension SceneDIContainer{
     func returnHTTPServices()->GetProductsList&GetProductImage&GetDetailProduct{
         return ProductHTTP(ProductListURL: configure.getProductListURL(), ProductImageURL: configure.getProductImageURL())
    }
     func returnStreamingService()->SocketNetworkInterface{
         SocketNetwork(hostName: configure.getSocketHost(), portNumber: configure.getSocketPort())
    }
}

//MARK: Repository
extension SceneDIContainer{
     func returnProductCacheImageRepository()->ProductImageCacheRepositoryInterface{
        ProductImageCacheRepository()
    }
    func returnProductsImageRepository(httpService:GetProductImage)->ProductImageRepositoryInterface{
        return ProductImageRepository(ImageServer: httpService,CacheRepository: returnProductCacheImageRepository())
    }
    func returnProductListRepositoryInterface(httpService:GetProductsList)->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: httpService, StreamingService:returnStreamingService(),TCPStreamDataTransfer: returnTCPStreamDataTransferInterface(),ProductListState: returnProductListState(),HTTPDataTransfer: returnHTTPDataTransfer())
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
     func returnHTTPDataTransfer()->Pr_HTTPDataTransferProductList{
        HTTPDataTransferProductList()
    }
    func returnHTTPDataTransferDetailProduct()->Pr_HTTPDataTransferDetailProduct{
        HTTPDataTransferDetailProduct()
    }
    func returnDetailProductRepository()->Pr_DetailProductRepository{
        DetailProductRepository(httpService: returnHTTPServices(), httpDetailProductTransfer: returnHTTPDataTransferDetailProduct())
    }
}

//MARK: Usecase
extension SceneDIContainer{
    func returnProductListUsecaseInterface(httpService:GetProductsList,ImageHeightRepository:ProductImageRepositoryInterface)->Pr_ProductListWithImageHeightUsecase{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(httpService: httpService), ImageHeightRepo: ImageHeightRepository)
    }
     func returnProductImageLoadUsecaseInterface(ImageLoadRepository:ProductImageRepositoryInterface)->Pr_ProductImageLoadUsecase{
        ProductImageLoadUseCase(productsImageRepository: ImageLoadRepository)
    }
    func returnDetailProductUsecase()->Pr_DetailProductUsecase{
        DetailProductUsecase(detailProductRepository: returnDetailProductRepository())
    }
}

//MARK: ViewModel,View
extension SceneDIContainer{
    func returnProductListCollectionViewCellViewModel(ImageUsecase:Pr_ProductImageLoadUsecase,imageWidth:CGFloat)->Pr_ProductListCollectionViewCellViewModel{
         ProductListCollectionViewCellViewModel(ImageUsecase: ImageUsecase,downImageSize: imageWidth)
    }
    func returnProductListCollectionViewModel(httpService:GetProductsList,ImageRepository:ProductImageRepositoryInterface,imageWidth:CGFloat)->Pr_ProductListCollectionViewModel&Pr_ProductListCollectionViewLayoutViewModel{
        let listUsecase = returnProductListUsecaseInterface(httpService: httpService,ImageHeightRepository: ImageRepository)
        let imageLoadUsecase = returnProductImageLoadUsecaseInterface(ImageLoadRepository: ImageRepository)
        let cellViewModel = returnProductListCollectionViewCellViewModel(ImageUsecase: imageLoadUsecase,imageWidth: imageWidth)
        return ProductListCollectionViewModel(UseCase: listUsecase,CellViewModel: cellViewModel,FooterViewModel: returnProductListCollectionFooterViewModel(),downImageSize: imageWidth)
    }
     func returnProductListCollectionView(viewModel:Pr_ProductListCollectionViewModel,layout:ProductListCollectionViewLayout)->ProductListCollectionView{
        ProductListCollectionView(collectionViewLayout: layout,viewModel: viewModel)
    }
    func returnProductListCollectionViewLayout(viewModel:Pr_ProductListCollectionViewLayoutViewModel,cellCount:Double)->ProductListCollectionViewLayout{
        ProductListCollectionViewLayout(viewModel: viewModel,cellCount: cellCount)
    }
    func returnProductListViewModelInterface(collectionViewModel:Pr_ProductListCollectionViewModel,errorAlterViewModel:Pr_ErrorAlterViewModel,transitioning:TransitionProductListViewController)->Pr_ProductListViewControllerViewModel{
        ProductListViewControllerViewModel(detailProductUsecase: returnDetailProductUsecase(),collectionViewModel:collectionViewModel,ErrorAlterViewModel:errorAlterViewModel,transitioning: transitioning)
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
    func returnImageWidth(scale:CGFloat)->CGFloat{
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return screenWidth/scale
    }
    func returnCellCount()->Double{
        2
    }
 
}
protocol MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController)->Coordinator
    func returnMainContainerViewController()->MainContainerViewController
}

//MARK: ProductList Coordinator
extension SceneDIContainer:MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController)->Coordinator{
        ProductListViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self)
    }
    func returnMainContainerViewController() -> MainContainerViewController {
        let navigationCircleViewModel = returnNavigationCircleViewModel()
        let navigationCircleView = returnNavigationCornerRadiusView(navigationCircleViewModel: navigationCircleViewModel)
        let mainContainerControllerViewModel = returnMainContainerControllerViewModel(navigationCircleViewModel: navigationCircleViewModel)
        return MainContainerViewController(navigationCircleView: navigationCircleView, viewModel: mainContainerControllerViewModel)
    }
    func returnMainContainerControllerViewModel(navigationCircleViewModel:Pr_NavigationCircleViewModel)->Pr_MainContainerControllerViewModel{
        MainContainerControllerViewModel(navigationCircleViewModel:navigationCircleViewModel)
    }
    private func returnNavigationCornerRadiusView(navigationCircleViewModel:Pr_NavigationCircleViewModel)->NavigationCornerRadiusView{
        NavigationCornerRadiusView(ViewModel: navigationCircleViewModel)
    }
    private func returnNavigationCircleViewModel()->Pr_NavigationCircleViewModel{
        NavigationCircleViewModel()
    }
}
protocol ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController) -> UIViewController
    func returnDetailProductViewCoordinator(ContainerViewController:ContainerViewController,HasChildCoordinator:HasChildCoordinator)->Coordinator
}

//MARK: ProductListViewController, DetailProductViewCoordinator
extension SceneDIContainer:ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController) -> UIViewController {
        let cellCount = returnCellCount()
        let httpService = returnHTTPServices()
        let imageRepository = returnProductsImageRepository(httpService: httpService)
        let collectionViewModel = returnProductListCollectionViewModel(httpService: httpService,ImageRepository: imageRepository,imageWidth: returnImageWidth(scale: cellCount))
        let errorAlterViewModel = returnErrorAlterViewModel()
        let errorAlterView = returnErrorAlterView(errorAlterViewModel: errorAlterViewModel)
        let viewModel = returnProductListViewModelInterface(collectionViewModel: collectionViewModel,errorAlterViewModel: errorAlterViewModel,transitioning: transitioning)
        let collectionViewLayout = returnProductListCollectionViewLayout(viewModel: collectionViewModel,cellCount: cellCount)
        let collectionView = returnProductListCollectionView(viewModel:collectionViewModel, layout: collectionViewLayout)
        let productListViewController = ProductListViewController(viewModel: viewModel, CollectionView: collectionView,ErrorAlterView: errorAlterView)
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
