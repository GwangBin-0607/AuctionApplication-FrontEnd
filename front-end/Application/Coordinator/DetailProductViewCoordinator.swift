//
//  DetailProductCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class DetailProductViewCoordinator:Coordinator,HasParentCoordinator{
    let containerViewController: TransitioningViewController
    var childCoordinator: [Coordinator] = []
    private let sceneDIContainer:SceneDIContainer
    let delegate: HasChildCoordinator
    init(ContainerViewController:TransitioningViewController,SceneDIContainer:SceneDIContainer,DetailProductViewCoordinatorDelegate:HasChildCoordinator) {
        self.delegate = DetailProductViewCoordinatorDelegate
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
    }
    func start() {
        let detailProductListViewController = sceneDIContainer.returnDetailViewController(transitioning: self)
        containerViewController.present(ViewController: detailProductListViewController, animate: true)
    }
    deinit {
            print("DEINIT")
    }
}
extension DetailProductViewCoordinator:TransitionDetailProductViewController{
    func dismissToProductListView() {
        delegate.removeChildCoordinator(Co: self)
        print("aaa")
        containerViewController.dismiss(animate: true)
    }
}
