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
        let tableViewModel = returnUserPageTableViewModel()
        let tableview = returnUserPageTableView(viewModel: tableViewModel)
        return UserPageViewController(viewModel: returnUserPageViewModel(transition: transitioning,tableviewModel: tableViewModel),settingTableView: tableview)
    }
    func returnUserPageTableView(viewModel:Pr_UserPageTableViewModel)->UserPageTableView{
        UserPageTableView(viewModel: viewModel)
    }
    func returnUserPageTableViewModel()->Pr_UserPageTableViewModel{
        UserPageTableViewModel()
    }
    func returnLoginPageCoordinator(containerViewController:ContainerViewController,delegate:HasChildCoordinator) -> LoginPageCoordinator {
        LoginPageCoordinator(containerViewController: containerViewController, sceneDIContainer: self, delegate: delegate)
    }
    private func returnUserPageViewModel(transition:TransitionUserPageViewController,tableviewModel:Pr_UserPageTableViewModel)->Pr_UserPageViewControllerViewModel{
        UserPageViewControllerViewModel(delegate: transition,tableViewModel: tableviewModel)
    }
    private func returnCustomNavigationViewModel()->Pr_CustomNavigationViewControllerViewModel{
        CustomNavigationViewControllerViewModel()
    }
}
