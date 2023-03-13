//
//  DetailProductCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class DetailProductViewCoordinator:Coordinator,HasParentCoordinator{
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:DetailProductViewSceneDIContainer
    let delegate: HasChildCoordinator
    weak var viewController: UIViewController?
    private let presentOptions:PresentOptions
    init(ContainerViewController:ContainerViewController,SceneDIContainer:DetailProductViewSceneDIContainer,DetailProductViewCoordinatorDelegate:HasChildCoordinator,presentOptions:PresentOptions) {
        self.presentOptions = presentOptions
        self.delegate = DetailProductViewCoordinatorDelegate
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func start() {
        if let product_id = presentOptions.productId{
            let detailProductListViewController = sceneDIContainer.returnDetailViewController(transitioning: self, product_id: product_id)
            viewController = detailProductListViewController
            containerViewController.present(ViewController: detailProductListViewController, animate: true)
            print("PRESENT")
        }
    }
}
extension DetailProductViewCoordinator:TransitionDetailProductViewController{
    func dismissToProductListViewController() {
        delegate.removeChildCoordinator(Co: self)
        containerViewController.dismiss(animate: true,viewController: viewController)
    }
    func toLoginView(){
        delegate.toLogin()
    }
}
