//
//  SceneDIContainer+CustomContainerViewDIContainer.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
protocol CustomContainerViewDIContainer {
    func returnCustomContainerViewController()->CustomNavigationViewController
    func returnUserPageCoordinator(containerView:ContainerViewController)->Coordinator
}
extension SceneDIContainer:CustomContainerViewDIContainer{
    func returnCustomContainerViewController()->CustomNavigationViewController{
        CustomNavigationViewController(viewModel: returnCustomContainerViewModel())
    }
    func returnCustomContainerViewModel()->Pr_CustomNavigationViewControllerViewModel{
        CustomNavigationViewControllerViewModel()
    }
    func returnUserPageCoordinator(containerView:ContainerViewController) -> Coordinator {
        UserPageViewCoordinator(containerViewController: containerView, sceneDIContainer: self)
    }
}
