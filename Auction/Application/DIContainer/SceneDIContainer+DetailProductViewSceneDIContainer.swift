//
//  SceneDIContainer+.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
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
