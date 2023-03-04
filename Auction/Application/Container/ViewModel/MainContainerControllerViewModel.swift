//
//  MainContainerViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import Foundation
import RxSwift
class MainContainerControllerViewModel:Pr_MainContainerControllerViewModel{
    private let navigationCircleViewModel:Pr_NavigationCircleViewModel
    let pangestureObservable: Observable<Pangesture>
    init(navigationCircleViewModel:Pr_NavigationCircleViewModel) {
        self.navigationCircleViewModel = navigationCircleViewModel
        pangestureObservable = self.navigationCircleViewModel.pangestureObservable
        
    }
}
