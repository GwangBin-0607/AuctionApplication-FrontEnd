//
//  ProductListCoordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

final class ProductListViewCoordinator:Coordinator,HasParentCoordinator{
    let delegate: HasChildCoordinator
    var containerViewController: ContainerViewController
    var childCoordinator: [Coordinator] = []
    let sceneDIContainer:ProductListViewSceneDIContainer
    weak var viewController: UIViewController?
    init(ContainerViewController:ContainerViewController,SceneDIContainer:ProductListViewSceneDIContainer,delegate:HasChildCoordinator) {
        self.delegate = delegate
        self.sceneDIContainer = SceneDIContainer
        self.containerViewController = ContainerViewController
    }
    func start() {
        let viewCon = sceneDIContainer.returnProductsListViewController(transitioning: self)
        containerViewController.present(ViewController: viewCon, animate: true)
    }
    private func detailProductViewController(presentOption:PresentOptions){
        let coor = sceneDIContainer.returnDetailProductViewCoordinator(ContainerViewController: containerViewController, HasChildCoordinator: self,presentOptions: presentOption)
        childCoordinator.append(coor)
        coor.start()
    }
}
extension ProductListViewCoordinator:TransitionProductListViewController{

    func presentDetailViewController(presentOption:PresentOptions) {
        detailProductViewController(presentOption:presentOption)
    }
    
}
extension ProductListViewCoordinator:HasChildCoordinator{
    func removeChildCoordinator(Co: Coordinator) {
        self.childCoordinator = childCoordinator.filter{$0 !== Co}
    }
    func toLogin() {
        
    }
}
