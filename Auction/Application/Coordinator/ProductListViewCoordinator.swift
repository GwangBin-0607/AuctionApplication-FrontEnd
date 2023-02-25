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
    private func detailProductViewController(product_id:Int,streamNetworkInterface:SocketNetworkInterface){
        let coor = sceneDIContainer.returnDetailProductViewCoordinator(ContainerViewController: containerViewController, HasChildCoordinator: self,product_id: product_id,streamNetworkInterface: streamNetworkInterface)
        childCoordinator.append(coor)
        coor.start()
    }
}
extension ProductListViewCoordinator:TransitionProductListViewController{

    func presentDetailViewController(product_id:Int,streamNetworkInterface:SocketNetworkInterface) {
        detailProductViewController(product_id: product_id,streamNetworkInterface:streamNetworkInterface)
    }
    
}
extension ProductListViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}
