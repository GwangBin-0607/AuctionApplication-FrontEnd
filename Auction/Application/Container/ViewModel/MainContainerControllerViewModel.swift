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
    let tapgestureObservable: Observable<Void>
    let backGestureObserver: AnyObserver<Void>
    let loginObserver: AnyObserver<Void>
    private let disposeBag:DisposeBag
    init(navigationCircleViewModel:Pr_NavigationCircleViewModel) {
        disposeBag = DisposeBag()
        self.navigationCircleViewModel = navigationCircleViewModel
        pangestureObservable = self.navigationCircleViewModel.pangestureObservable
        tapgestureObservable = self.navigationCircleViewModel.tapGestureObservable
        backGestureObserver = self.navigationCircleViewModel.backGestureObserver
        loginObserver = self.navigationCircleViewModel.loginObserver
        
    }
}
