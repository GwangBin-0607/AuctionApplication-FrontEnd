//
//  ProductListCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

final class ProductListViewCoordinator:Coordinator{
    let containerViewController: TransitioningViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:ProductListViewSceneDIContainer
    init(ContainerViewController:TransitioningViewController,SceneDIContainer:ProductListViewSceneDIContainer) {
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
    }
    func start() {
        let productListViewController = sceneDIContainer.returnProductsListViewController(transitioning: self)
        containerViewController.present(ViewController: productListViewController, animate: true)
        print("start")
        
    }
    private func detailProductViewController(){
        let coor = sceneDIContainer.returnDetailProductViewCoordinator(ContainerViewController: containerViewController, HasChildCoordinator: self)
        childCoordinator.append(coor)
        print(childCoordinator)
        coor.start()
    }
}
extension ProductListViewCoordinator:TransitionPresentViewController{
    func presentViewController() {
        detailProductViewController()
    }
    
}
extension ProductListViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}
