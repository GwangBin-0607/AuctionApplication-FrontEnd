//
//  AppCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class AppCoordinator:Coordinator{
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:MainContainerViewSceneDIContainer
    weak var viewController: UIViewController?
    init(SceneDIContainer:MainContainerViewSceneDIContainer,containerViewController:ContainerViewController) {
        self.containerViewController = containerViewController
        self.sceneDIContainer = SceneDIContainer
    }
    func start() {
        showProductListViewController()
        showUserPageViewController()
    }
    private func showProductListViewController(){
        let coordinator = sceneDIContainer.returnProductListViewCoordinator(ContainerViewController: containerViewController,delegate: self)
        coordinator.start()
        childCoordinator.append(coordinator)
    }
    private func showUserPageViewController(){
        let coordinator = sceneDIContainer.returnCustomContainerCoordinator(containerViewController: containerViewController,delegate: self)
        coordinator.start()
        childCoordinator.append(coordinator)
    }
}
extension AppCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        
    }
    func toLogin() {
        
    }
}
