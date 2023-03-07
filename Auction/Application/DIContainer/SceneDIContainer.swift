import Foundation
import UIKit

final class SceneDIContainer{
    private final class SocketNetWorkContainer{
        weak var streamService:SocketNetworkInterface?
    }
    let configure:ExportConfigure
    private let streamServiceContainer:SocketNetWorkContainer
    init() {
        configure = ExportConfigure()
        streamServiceContainer = SocketNetWorkContainer()
    }
}

//MARK: Infrastructure
extension SceneDIContainer{
     func returnHTTPServices()->GetProductsList&GetProductImage&GetDetailProduct&GetCurrentProductPrice{
         return ProductHTTP(ProductListURL: configure.getProductListURL(), ProductImageURL: configure.getProductImageURL(),ProductDetailURL: configure.getProductDetailURL(),ProductCurrentPriceURL: configure.getProductCurrentPriceURL())
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
        return ProductImageRepository(ImageServer: httpService,CacheRepository: returnProductCacheImageRepository(),httpTransfer: returnHTTPImageDataTransfer())
    }
    func returnProductListRepositoryInterface(httpService:GetProductsList,socketNetworkInterface:SocketNetworkInterface)->ProductListRepositoryInterface{
        return ProductListRepository(ApiService: httpService, StreamingService:socketNetworkInterface,TCPStreamDataTransfer: returnTCPStreamDataTransferInterface(),ProductListState: returnProductListState(),HTTPDataTransfer: returnHTTPDataTransfer())
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
    func returnHTTPImageDataTransfer()->Pr_HTTPDataTransferProductImage{
        HTTPDataTransferProductImage()
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
    func returnProductListUsecaseInterface(httpService:GetProductsList,ImageHeightRepository:ProductImageRepositoryInterface,socketNetworkInterface:SocketNetworkInterface)->Pr_ProductListWithImageHeightUsecase{
        ProductListWithImageHeightUsecase(ListRepo: returnProductListRepositoryInterface(httpService: httpService,socketNetworkInterface:socketNetworkInterface), ImageHeightRepo: ImageHeightRepository)
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
    func returnProductListCollectionViewModel(listUsecase:Pr_ProductListWithImageHeightUsecase,imageLoadUsecase:Pr_ProductImageLoadUsecase,cellViewModel:Pr_ProductListCollectionViewCellViewModel,imageWidth:CGFloat)->Pr_ProductListCollectionViewModel&Pr_ProductListCollectionViewLayoutViewModel{
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
    func returnUserPageCoordinator(containerView:ContainerViewController)->UserPageViewCoordinator
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
    func returnUserPageCoordinator(containerView:ContainerViewController)->UserPageViewCoordinator{
        UserPageViewCoordinator(containerViewController: containerView, sceneDIContainer: self)
    }

}
protocol ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController) -> UIViewController
    func returnDetailProductViewCoordinator(ContainerViewController:ContainerViewController,HasChildCoordinator:HasChildCoordinator,presentOptions:PresentOptions)->Coordinator
}
protocol UserPageViewSceneDIContainer{
    func returnUserPageViewController(transitioning:TransitionUserPageViewController)->UserPageViewController
    func returnLoginPageCoordinator(containerViewController:ContainerViewController,delegate:HasChildCoordinator)->LoginPageCoordinator
    func returnCustomNavigationController(rootViewController:UIViewController)->CustomNavigationViewController
}
protocol LoginPageViewSceneDIContainer{
    func returnLoginViewController()->UIViewController
}
extension SceneDIContainer:LoginPageViewSceneDIContainer{
    func returnLoginViewController() -> UIViewController {
        LoginViewController()
    }
}
extension SceneDIContainer:UserPageViewSceneDIContainer{
    func returnCustomNavigationController(rootViewController: UIViewController) -> CustomNavigationViewController {
        CustomNavigationViewController(viewModel: returnCustomNavigationViewModel(), rootViewController: rootViewController)
    }
    func returnUserPageViewController(transitioning:TransitionUserPageViewController)->UserPageViewController{
        UserPageViewController(viewModel: returnUserPageViewModel(),transtioning: transitioning)
    }
    func returnLoginPageCoordinator(containerViewController:ContainerViewController,delegate:HasChildCoordinator) -> LoginPageCoordinator {
        LoginPageCoordinator(containerViewController: containerViewController, sceneDIContainer: self, delegate: delegate)
    }
    private func returnUserPageViewModel()->Pr_UserPageViewControllerViewModel{
        UserPageViewControllerViewModel()
    }
    private func returnCustomNavigationViewModel()->Pr_CustomNavigationViewControllerViewModel{
        CustomNavigationViewControllerViewModel()
    }
}
//MARK: ProductListViewController, DetailProductViewCoordinator
extension SceneDIContainer:ProductListViewSceneDIContainer{
    func returnSocketNetworkInterfaceInContainer()->SocketNetworkInterface{
        let streamNetwork:SocketNetworkInterface
        if let net = streamServiceContainer.streamService{
            streamNetwork = net
        }else{
            streamNetwork = returnStreamingService()
            streamServiceContainer.streamService = streamNetwork
        }
        return streamNetwork
    }
    func returnProductsListViewController(transitioning:TransitionProductListViewController) -> UIViewController {
        let cellCount = returnCellCount()
        let httpService = returnHTTPServices()
        let imageRepository = returnProductsImageRepository(httpService: httpService)
        let streamNetwork = returnSocketNetworkInterfaceInContainer()
        let listUsecase = returnProductListUsecaseInterface(httpService: httpService,ImageHeightRepository: imageRepository,socketNetworkInterface: streamNetwork)
        let imageLoadUsecase = returnProductImageLoadUsecaseInterface(ImageLoadRepository: imageRepository)
        let imageWidth = returnImageWidth(scale: 2.0)
        let cellViewModel = returnProductListCollectionViewCellViewModel(ImageUsecase: imageLoadUsecase,imageWidth: imageWidth)
        let collectionViewModel = returnProductListCollectionViewModel(listUsecase: listUsecase, imageLoadUsecase: imageLoadUsecase, cellViewModel: cellViewModel, imageWidth: imageWidth)
        let errorAlterViewModel = returnErrorAlterViewModel()
        let errorAlterView = returnErrorAlterView(errorAlterViewModel: errorAlterViewModel)
        let viewModel = returnProductListViewModelInterface(collectionViewModel: collectionViewModel,errorAlterViewModel: errorAlterViewModel,transitioning: transitioning)
        let collectionViewLayout = returnProductListCollectionViewLayout(viewModel: collectionViewModel,cellCount: cellCount)
        let collectionView = returnProductListCollectionView(viewModel:collectionViewModel, layout: collectionViewLayout)
        let productListViewController = ProductListViewController(viewModel: viewModel, CollectionView: collectionView,ErrorAlterView: errorAlterView)
        return productListViewController
    }
    func returnDetailProductViewCoordinator(ContainerViewController:ContainerViewController,HasChildCoordinator:HasChildCoordinator,presentOptions:PresentOptions)->Coordinator{
        DetailProductViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self, DetailProductViewCoordinatorDelegate:HasChildCoordinator,presentOptions:presentOptions)
    }
}
protocol DetailProductViewSceneDIContainer{
    func returnDetailViewController(transitioning:TransitionDetailProductViewController,product_id:Int) -> Pr_ChildViewController
}

//MARK: DetailViewController
extension SceneDIContainer:DetailProductViewSceneDIContainer{
    func returnDetailViewController(transitioning:TransitionDetailProductViewController,product_id:Int) -> Pr_ChildViewController {
        let streamNetwork = returnSocketNetworkInterfaceInContainer()
        let productPriceRepository = returnCurrentProductPriceRepository(streamNetworkService: streamNetwork, product_id: product_id)
        let productPriceUsecase = returnCurrentProductPriceUsecase(currentProductPriceRepository: productPriceRepository)
        let priceLabelViewModel = returnPriceLabelViewModel()
        let enablePriceLabelViewModel = ruturnEnablePriceLabelViewModel()
        let buyProductButtonViewModel = returnBuyProductButtonViewModel()
        let productPriceViewModel = returnDetailProductPriceViewModel(usecase: productPriceUsecase,priceLabelViewModel: priceLabelViewModel,enablePriceLabelViewModel: enablePriceLabelViewModel,buyProductButtonViewModel: buyProductButtonViewModel)
        let productPriceView = returnDetailProductPriceView(viewModel: productPriceViewModel,priceViewModel: priceLabelViewModel,enablePriceViewModel: enablePriceLabelViewModel,buyProductButtonViewModel: buyProductButtonViewModel)
        let collectionViewModel = returnDetailProductCollectionViewModel()
        let collectionView = returnDetailProductCollectionView(viewModel: collectionViewModel)
        let detailProductViewControllerViewModel = returnDetailViewControllerViewModel(transitioning: transitioning,detailProductPriceViewModel: productPriceViewModel,detailCollectionViewModel: collectionViewModel,product_id: product_id)
        return DetailProductViewController(productPriceView: productPriceView,detailProductCollectionView: collectionView,viewModel: detailProductViewControllerViewModel)
    }
}
extension SceneDIContainer{
    func returnDetailProductPriceView(viewModel:Pr_DetailProductPriceViewModel,priceViewModel:Pr_DetailPriceLabelViewModel,enablePriceViewModel:Pr_DetailPriceLabelViewModel,buyProductButtonViewModel:Pr_CustomTextButtonViewModel)->DetailProductPriceView{
        DetailProductPriceView(viewModel:viewModel,priceLabel: returnPriceLabel(viewModel: priceViewModel),enablePriceLabel: returnEnablePriceLabel(viewModel: enablePriceViewModel),buyProductBotton: returnBuyProductButton(viewModel: buyProductButtonViewModel))
    }
    func returnBuyProductButton(viewModel:Pr_CustomTextButtonViewModel)->CustomTextButton{
        CustomTextButton(viewModel: viewModel)
    }
    func returnBuyProductButtonViewModel()->Pr_CustomTextButtonViewModel{
        CustomTextButtonViewModel()
    }
    func returnPriceLabelViewModel()->Pr_DetailPriceLabelViewModel{
        DetailProductLabelViewModel()
    }
    func ruturnEnablePriceLabelViewModel()->Pr_DetailPriceLabelViewModel{
        DetailEnableProductLabelViewModel()
    }
    func returnPriceLabel(viewModel:Pr_DetailPriceLabelViewModel)->PriceLabel{
        PriceLabel(viewModel: viewModel)
    }
    func returnEnablePriceLabel(viewModel:Pr_DetailPriceLabelViewModel)->EnablePriceLabel{
        EnablePriceLabel(viewModel: viewModel)
    }
    func returnDetailProductCollectionView(viewModel:Pr_DetailProductCollectionViewModel)->DetailProductCollectionView{
        DetailProductCollectionView(viewModel: viewModel, backgroundColor: ManageColor.singleton.getMainColor())
    }
    func returnDetailProductCollectionViewModel()->Pr_DetailProductCollectionViewModel{
        let imageRepo = returnProductsImageRepository(httpService: returnHTTPServices())
        let imageUsecase = returnProductImageLoadUsecaseInterface(ImageLoadRepository: imageRepo)
        return DetailProductCollectionViewModel(detailProductUsecase:returnDetailProductUsecase(),detailProductCollectionViewImageCellViewModel: returnDetailProductCollectionViewImageCellViewModel(usecase: imageUsecase),detailProductCollectionViewUserCellViewModel:returnDetailProductCollectionViewUserCellViewModel(usecase: imageUsecase) )
    }
    func returnDetailProductCollectionViewUserCellViewModel(usecase:Pr_ProductImageLoadUsecase)->Pr_DetailProductCollectionViewUserCellViewModel{
        DetailProductCollectionViewUserCellViewModel(ImageUsecase: usecase, downImageSize: returnImageWidth(scale: 5.0))
    }
    func returnDetailProductCollectionViewImageCellViewModel(usecase:Pr_ProductImageLoadUsecase)->Pr_DetailProductCollectionViewImageCellViewModel{
        DetailProductCollectionViewImageCellViewModel(ImageUsecase: usecase, downImageSize: returnImageWidth(scale: 1.0))
    }
    func returnDetailViewControllerViewModel(transitioning:TransitionDetailProductViewController,detailProductPriceViewModel:Pr_DetailProductPriceViewModel,detailCollectionViewModel:Pr_DetailProductCollectionViewModel,product_id:Int)->Pr_DetailProductViewControllerViewModel{
        DetailProductViewControllerViewModel(transitioning:transitioning,detailProductPriceViewModel: detailProductPriceViewModel,detailProductCollectionViewModel: detailCollectionViewModel,product_id: product_id)
    }
}
extension SceneDIContainer{
    func returnDetailProductPriceViewModel(usecase:Pr_CurrentProductPriceUsecase,priceLabelViewModel:Pr_DetailPriceLabelViewModel,enablePriceLabelViewModel:Pr_DetailPriceLabelViewModel,buyProductButtonViewModel:Pr_CustomTextButtonViewModel)->Pr_DetailProductPriceViewModel{
        return DetailProductPriceViewModel(usecase: usecase,priceLabelViewModel: priceLabelViewModel,enableLabelViewModel: enablePriceLabelViewModel,buyProductButtonViewModel: buyProductButtonViewModel)
    }
    func returnCurrentProductPriceUsecase(currentProductPriceRepository:Pr_CurrentProductPriceRepository)->Pr_CurrentProductPriceUsecase{
        CurrentProductPriceUsecase(currentProductPriceRepository: currentProductPriceRepository)
    }
    func returnCurrentProductPriceRepository(streamNetworkService:SocketNetworkInterface,product_id:Int)->Pr_CurrentProductPriceRepository{
        CurrentProductPriceRepository(httpService: returnHTTPServices(), httpCurrentProductPriceTransfer: returnHTTPDataTransferCurrentProductPrice(), streamTransferData: returnTCPStreamDataTransferInterface(), streamService: streamNetworkService, product_id: product_id)
    }
    func returnHTTPDataTransferCurrentProductPrice()->Pr_HTTPDataTransferCurrentProductPrice{
        HTTPDataTransferCurrentProductPrice()
    }
}
