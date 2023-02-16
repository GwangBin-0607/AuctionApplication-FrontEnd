//
//  ProductListCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

final class ProductListViewCoordinator:Coordinator{
    let containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:ProductListViewSceneDIContainer
    init(ContainerViewController:ContainerViewController,SceneDIContainer:ProductListViewSceneDIContainer) {
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
    }
    func start() {
        let productListViewController = sceneDIContainer.returnProductsListViewController(transitioning: self)
        containerViewController.present(ViewController: productListViewController, animate: true)
    }
    private func detailProductViewController(){
        let coor = sceneDIContainer.returnDetailProductViewCoordinator(ContainerViewController: containerViewController, HasChildCoordinator: self)
        childCoordinator.append(coor)
        coor.start()
    }
}
extension ProductListViewCoordinator:TransitionProductListViewController{

    func presentDetailViewController() {
        detailProductViewController()
    }
    
}
extension ProductListViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}