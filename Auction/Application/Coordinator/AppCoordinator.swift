//
//  AppCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class AppCoordinator:Coordinator{
    var containerViewController: ContainerViewController?
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:MainContainerViewSceneDIContainer

    init(SceneDIContainer:MainContainerViewSceneDIContainer) {
        self.sceneDIContainer = SceneDIContainer
    }
    func setContainerViewController(container:ContainerViewController?){
        self.containerViewController = container
    }
    func start() {
        showProductListViewController()
    }
    private func showProductListViewController(){
        let coordinator = sceneDIContainer.returnProductListViewCoordinator(ContainerViewController: containerViewController)
        coordinator.start()
        childCoordinator.append(coordinator)
    }
}
extension AppCoordinator:TransitionContainerViewController{
    func presentUserPageViewController() {
        let coordinator = sceneDIContainer.returnUserPageViewCoordinator(ContainerViewController: containerViewController,HasChildCoordinator: self)
        coordinator.start()
        childCoordinator.append(coordinator)
    }
}
extension AppCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}
