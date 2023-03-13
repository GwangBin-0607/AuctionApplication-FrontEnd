//
//  CustomContainerViewCoordinator.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
final class CustomContainerViewCoordinator:Coordinator,HasParentCoordinator{
    let delegate: HasChildCoordinator
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:CustomContainerViewDIContainer
    weak var viewController: UIViewController?
    init(SceneDIContainer:CustomContainerViewDIContainer,containerViewController:ContainerViewController,delegate:HasChildCoordinator) {
        self.delegate = delegate
        self.containerViewController = containerViewController
        self.sceneDIContainer = SceneDIContainer
    }
    func start() {
        let viewController = sceneDIContainer.returnCustomContainerViewController()
        containerViewController.presentNaviationViewController(ViewController: viewController)
        rootViewController(container: viewController)
    }
    private func rootViewController(container:ContainerViewController){
        let coordinator = sceneDIContainer.returnUserPageCoordinator(containerView: container,delegate: self)
        childCoordinator.append(coordinator)
        coordinator.start()
    }
}
extension CustomContainerViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        
    }
    func toLogin() {
        
    }
}
