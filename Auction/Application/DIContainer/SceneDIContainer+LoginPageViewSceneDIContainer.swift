//
//  SceneDIContainer+LoginView.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
protocol LoginPageViewSceneDIContainer{
    func returnLoginViewController(transitioning:TransitionLoginViewController)->UIViewController
}
extension SceneDIContainer:LoginPageViewSceneDIContainer{
    func returnLoginViewController(transitioning:TransitionLoginViewController) -> UIViewController {
        LoginViewController(customButton: returnBuyProductButton(viewModel: returnBuyProductButtonViewModel()),viewModel: returnLoginViewControllerViewModel(transitioning: transitioning))
    }
    private func returnLoginViewControllerViewModel(transitioning:TransitionLoginViewController)->Pr_LoginViewControllerViewModel{
        LoginViewControllerViewModel(transition:transitioning)
    }
}
