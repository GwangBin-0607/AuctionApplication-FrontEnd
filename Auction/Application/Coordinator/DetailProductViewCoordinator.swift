//
//  DetailProductCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class DetailProductViewCoordinator:Coordinator,HasParentCoordinator{
    let containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:DetailProductViewSceneDIContainer
    let delegate: HasChildCoordinator
    private let product_id:Int
    private let streamNetworkInterface:SocketNetworkInterface
    init(ContainerViewController:ContainerViewController,SceneDIContainer:DetailProductViewSceneDIContainer,DetailProductViewCoordinatorDelegate:HasChildCoordinator,product_id:Int,streamNetworkInterface:SocketNetworkInterface) {
        self.product_id = product_id
        self.streamNetworkInterface = streamNetworkInterface
        self.delegate = DetailProductViewCoordinatorDelegate
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
    }
    func start() {
        let detailProductListViewController = sceneDIContainer.returnDetailViewController(transitioning: self,streamNetworkInterface: streamNetworkInterface, product_id: product_id)
        containerViewController.present(ViewController: detailProductListViewController, animate: true)
    }
    deinit {
            print("DEINIT")
    }
}
extension DetailProductViewCoordinator:TransitionDetailProductViewController{
    func dismissToProductListViewController() {
        delegate.removeChildCoordinator(Co: self)
        print("aaa")
        containerViewController.dismiss(animate: true)
    }
}
