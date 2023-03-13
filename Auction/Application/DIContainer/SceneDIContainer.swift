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
        let navigationViewModel = returnNavigationCircleViewModel()
        let navigationView = returnNavigationCornerRadiusView(navigationCircleViewModel: navigationViewModel)
        let backgroundViewModel = returnBackgroundViewModel(navigationViewModel: navigationViewModel)
        let backgroundView = returnBackgroundView(viewModel: backgroundViewModel,naviationView: navigationView)
        let mainContainerControllerViewModel = returnMainContainerControllerViewModel(backgroundViewModel: backgroundViewModel)
        return MainContainerViewController(viewModel: mainContainerControllerViewModel, backgroundView: backgroundView)
    }
    func returnMainContainerControllerViewModel(backgroundViewModel:Pr_BackgroundViewModel)->Pr_MainContainerControllerViewModel{
        MainContainerControllerViewModel(backgroundViewModel: backgroundViewModel)
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
