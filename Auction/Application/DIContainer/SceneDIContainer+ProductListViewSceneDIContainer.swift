//
//  SceneDIContainer+ProductList.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
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
protocol ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController) -> UIViewController
    func returnDetailProductViewCoordinator(ContainerViewController:ContainerViewController,HasChildCoordinator:HasChildCoordinator,presentOptions:PresentOptions)->Coordinator
}

//MARK: ProductListViewController, DetailProductViewCoordinator
extension SceneDIContainer:ProductListViewSceneDIContainer{
    func returnProductsListViewController(transitioning:TransitionProductListViewController) -> UIViewController {
        let cellCount = returnCellCount()
        let httpService = returnHTTPServices()
        let imageRepository = returnProductsImageRepository(httpService: httpService)
        let streamNetwork = returnSocketNetworkInterfaceInContainer()
        let listUsecase = returnProductListUsecaseInterface(httpService: httpService,ImageHeightRepository: imageRepository,socketNetworkInterface: streamNetwork)
        let imageLoadUsecase = returnProductImageLoadUsecaseInterface(ImageLoadRepository: imageRepository)
        let imageWidth = returnImageWidth(scale: cellCount)
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
