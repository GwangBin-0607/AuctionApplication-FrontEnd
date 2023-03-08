//
//  CustomContainerViewCoordinator.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
final class CustomContainerViewCoordinator:Coordinator{
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:CustomContainerViewDIContainer
    weak var viewController: UIViewController?
    init(SceneDIContainer:CustomContainerViewDIContainer,containerViewController:ContainerViewController) {
        self.containerViewController = containerViewController
        self.sceneDIContainer = SceneDIContainer
    }
    func start() {
        let viewController = sceneDIContainer.returnCustomContainerViewController()
        containerViewController.presentNaviationViewController(ViewController: viewController)
        rootViewController(container: viewController)
    }
    private func rootViewController(container:ContainerViewController){
        let coordinator = sceneDIContainer.returnUserPageCoordinator(containerView: container)
        childCoordinator.append(coordinator)
        coordinator.start()
    }
}
