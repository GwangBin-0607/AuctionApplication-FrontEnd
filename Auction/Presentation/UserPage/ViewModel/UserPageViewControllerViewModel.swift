//
//  UserPageViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation

final class UserPageViewControllerViewModel:Pr_UserPageViewControllerViewModel{
    private let transition:TransitionUserPageViewController
    init(transition:TransitionUserPageViewController) {
        self.transition = transition
    }
}
