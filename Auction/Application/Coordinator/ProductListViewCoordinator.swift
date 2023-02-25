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
    private var streamNetworkInterface:SocketNetworkInterface!
    init(ContainerViewController:ContainerViewController,SceneDIContainer:ProductListViewSceneDIContainer) {
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
    }
    func start() {
        let arg1 = sceneDIContainer.returnProductsListViewController(transitioning: self)
        let (viewCon,networkInterface) = arg1
        streamNetworkInterface = networkInterface
        containerViewController.present(ViewController: viewCon, animate: true)
    }
    private func detailProductViewController(product_id:Int){
        let coor = sceneDIContainer.returnDetailProductViewCoordinator(ContainerViewController: containerViewController, HasChildCoordinator: self,product_id: product_id,streamNetworkInterface: streamNetworkInterface)
        childCoordinator.append(coor)
        coor.start()
    }
}
extension ProductListViewCoordinator:TransitionProductListViewController{

    func presentDetailViewController(product_id:Int) {
        detailProductViewController(product_id: product_id)
    }
    
}
extension ProductListViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
}
