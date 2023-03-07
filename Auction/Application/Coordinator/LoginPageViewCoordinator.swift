//
//  UserPageViewCoordinator.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit
final class LoginPageCoordinator:Coordinator,HasParentCoordinator{
    var delegate: HasChildCoordinator
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    weak var viewController: UIViewController?
    let sceneDIContainer:LoginPageViewSceneDIContainer
    init(containerViewController:ContainerViewController,sceneDIContainer:LoginPageViewSceneDIContainer,delegate:HasChildCoordinator) {
        self.delegate = delegate
        self.containerViewController = containerViewController
        self.sceneDIContainer = sceneDIContainer
    }
    func start(){
        let viewController = sceneDIContainer.returnLoginViewController()
        self.viewController = viewController
        containerViewController.present(ViewController: viewController, animate: true)
    }
}
