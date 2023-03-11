//
//  MainContainerViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import Foundation
import RxSwift
class MainContainerControllerViewModel:Pr_MainContainerControllerViewModel{
    private let backgroundViewModel:Pr_BackgroundViewModel
    init(backgroundViewModel:Pr_BackgroundViewModel) {
        self.backgroundViewModel  = backgroundViewModel
    }
}
