//
//  UserPageViewCoordinator.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation

final class UserPageViewCoordinator:Coordinator,HasParentCoordinator{
    let delegate: HasChildCoordinator
    
    var childCoordinator: [Coordinator] = []
    
    var containerViewController: ContainerViewController?
    let sceneDIContainer:UserPageViewSceneDIContainer
    init(containerViewController:ContainerViewController?,sceneDIContainer:UserPageViewSceneDIContainer,userPageViewCoordinatorDelegate:HasChildCoordinator) {
        self.containerViewController = containerViewController
        self.sceneDIContainer = sceneDIContainer
        self.delegate = userPageViewCoordinatorDelegate
    }
    func start(){
        let viewController = sceneDIContainer.returnUserPageViewController(transition: self)
        containerViewController?.presentUserPage(ViewController: viewController)
    }
    
    
}
extension UserPageViewCoordinator:TransitionUserPageViewController{
    func dismissToUserPageViewController() {
        delegate.removeChildCoordinator(Co: self)
        containerViewController?.dismiss(animate: true)
    }
}
