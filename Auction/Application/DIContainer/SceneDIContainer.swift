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
    func returnProductListViewCoordinator(ContainerViewController:ContainerViewController)->Coordinator
    func returnMainContainerViewController()->MainContainerViewController
    func returnCustomContainerCoordinator(containerViewController: ContainerViewController)->Coordinator
}

//MARK: ProductList Coordinator
extension SceneDIContainer:MainContainerViewSceneDIContainer{
    func returnCustomContainerCoordinator(containerViewController: ContainerViewController) -> Coordinator {
        CustomContainerViewCoordinator(SceneDIContainer: self, containerViewController: containerViewController)
    }
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
