//
//  BackgroundViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/11.
//

import Foundation

final class BackgroundViewModel:Pr_BackgroundViewModel{
    let navigationViewModel:Pr_NavigationCircleViewModel
    init(navigationViewModel:Pr_NavigationCircleViewModel) {
        self.navigationViewModel = navigationViewModel
    }
}
