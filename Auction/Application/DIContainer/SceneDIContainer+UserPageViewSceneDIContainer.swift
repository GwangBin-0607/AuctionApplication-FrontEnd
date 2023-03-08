//
//  SceneDIContainer+UserPageViewSceneDIContainer.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
protocol UserPageViewSceneDIContainer{
    func returnUserPageViewController(transitioning:TransitionUserPageViewController)->UserPageViewController
    func returnLoginPageCoordinator(containerViewController:ContainerViewController,delegate:HasChildCoordinator)->LoginPageCoordinator
}

extension SceneDIContainer:UserPageViewSceneDIContainer{
    func returnUserPageViewController(transitioning:TransitionUserPageViewController)->UserPageViewController{
        UserPageViewController(viewModel: returnUserPageViewModel(transition: transitioning),settingTableView: returnUserPageTableView())
    }
    func returnUserPageTableView()->UserPageTableView{
        UserPageTableView(viewModel: returnUserPageTableViewModel())
    }
    func returnUserPageTableViewModel()->Pr_UserPageTableViewModel{
        UserPageTableViewModel()
    }
    func returnLoginPageCoordinator(containerViewController:ContainerViewController,delegate:HasChildCoordinator) -> LoginPageCoordinator {
        LoginPageCoordinator(containerViewController: containerViewController, sceneDIContainer: self, delegate: delegate)
    }
    private func returnUserPageViewModel(transition:TransitionUserPageViewController)->Pr_UserPageViewControllerViewModel{
        UserPageViewControllerViewModel(delegate: transition)
    }
    private func returnCustomNavigationViewModel()->Pr_CustomNavigationViewControllerViewModel{
        CustomNavigationViewControllerViewModel()
    }
}
