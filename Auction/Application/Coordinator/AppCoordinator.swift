//
//  AppCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class AppCoordinator:Coordinator{
    let containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:MainContainerViewSceneDIContainer
    init(ContainerViewController:ContainerViewController,SceneDIContainer:MainContainerViewSceneDIContainer) {
        self.containerViewController = ContainerViewController
        self.sceneDIContainer = SceneDIContainer
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
