//
//  MainContainerViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import Foundation
import RxSwift
class MainContainerControllerViewModel:Pr_MainContainerControllerViewModel{
    let gestureObservable: Observable<Pangesture>
    
    let menuClickObservable: Observable<Void>
    
    private let navigationCircleViewModel:Pr_NavigationCircleViewModel
    init(navigationCircleViewModel:Pr_NavigationCircleViewModel) {
        self.navigationCircleViewModel = navigationCircleViewModel
        gestureObservable = self.navigationCircleViewModel.gestureObservable
        menuClickObservable = self.navigationCircleViewModel.menuClickObservable
    }
}
