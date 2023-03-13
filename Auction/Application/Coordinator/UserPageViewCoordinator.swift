//
//  UserPageViewCoordinator.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit
final class UserPageViewCoordinator:Coordinator,HasParentCoordinator{
    let delegate: HasChildCoordinator
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    weak var viewController: UIViewController?
    let sceneDIContainer:UserPageViewSceneDIContainer
    init(containerViewController:ContainerViewController,sceneDIContainer:UserPageViewSceneDIContainer,delegate:HasChildCoordinator) {
        self.delegate = delegate
        self.containerViewController = containerViewController
        self.sceneDIContainer = sceneDIContainer
    }
    func start(){
        let viewController = sceneDIContainer.returnUserPageViewController(transitioning: self)
        containerViewController.present(ViewController: viewController, animate: true)
    }
    
    
}
extension UserPageViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}
extension UserPageViewCoordinator:TransitionUserPageViewController{
    func presentLogin() {
        let coordinator = sceneDIContainer.returnLoginPageCoordinator(containerViewController: containerViewController, delegate: self)
        coordinator.start()
        childCoordinator.append(coordinator)
    }
}

