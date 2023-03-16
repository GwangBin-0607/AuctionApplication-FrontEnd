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
extension SceneDIContainer {
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
}
protocol MainContainerViewSceneDIContainer{
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController,delegate:HasChildCoordinator)->Coordinator
    func returnMainContainerViewController()->MainContainerViewController
    func returnCustomContainerCoordinator(containerViewController: ContainerViewController,delegate:HasChildCoordinator)->Coordinator
}

//MARK: ProductList Coordinator
extension SceneDIContainer:MainContainerViewSceneDIContainer{
    func returnCustomContainerCoordinator(containerViewController: ContainerViewController,delegate:HasChildCoordinator) -> Coordinator {
        CustomContainerViewCoordinator(SceneDIContainer: self, containerViewController: containerViewController,delegate: delegate)
    }
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController,delegate:HasChildCoordinator)->Coordinator{
        ProductListViewCoordinator(ContainerViewController: ContainerViewController, SceneDIContainer: self,delegate: delegate)
    }
    func returnMainContainerViewController() -> MainContainerViewController {
        let mainContainerControllerViewModel = returnMainContainerControllerViewModel()
        return MainContainerViewController(viewModel: mainContainerControllerViewModel)
    }
    func returnMainContainerControllerViewModel()->Pr_MainContainerControllerViewModel{
        MainContainerControllerViewModel()
    }
    private func returnNavigationCornerRadiusView(navigationCircleViewModel:Pr_NavigationCircleViewModel)->NavigationCornerRadiusView{
        NavigationCornerRadiusView(ViewModel: navigationCircleViewModel)
    }
    private func returnNavigationCircleViewModel()->Pr_NavigationCircleViewModel{
        NavigationCircleViewModel()
    }
    private func returnBackgroundView(viewModel:Pr_BackgroundViewModel,naviationView:NavigationCornerRadiusView)->BackgroundView{
        BackgroundView(navigationView: naviationView, viewModel: viewModel)
    }
    private func returnBackgroundViewModel(navigationViewModel:Pr_NavigationCircleViewModel)->Pr_BackgroundViewModel{
        BackgroundViewModel(navigationViewModel: navigationViewModel)
    }
}
