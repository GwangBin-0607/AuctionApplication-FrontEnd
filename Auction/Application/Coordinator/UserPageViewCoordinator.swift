//
//  UserPageViewCoordinator.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit
final class UserPageViewCoordinator:Coordinator{
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    weak var viewController: UIViewController?
    let sceneDIContainer:UserPageViewSceneDIContainer
    weak var navigationController:CustomNavigation?
    init(containerViewController:ContainerViewController,sceneDIContainer:UserPageViewSceneDIContainer) {
        self.containerViewController = containerViewController
        self.sceneDIContainer = sceneDIContainer
    }
    func start(){
        let viewController = sceneDIContainer.returnUserPageViewController(transitioning: self)
        let navigationController = sceneDIContainer.returnCustomNavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        containerViewController.presentNaviationViewController(ViewController: navigationController)
    }
    
    
}
extension UserPageViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}
extension UserPageViewCoordinator:TransitionUserPageViewController{
    func presentLogin() {
        guard let navigationController = self.navigationController else{
            return
        }
        let coordinator = sceneDIContainer.returnLoginPageCoordinator(containerViewController: navigationController, delegate: self)
        coordinator.start()
        childCoordinator.append(coordinator)
    }
}

