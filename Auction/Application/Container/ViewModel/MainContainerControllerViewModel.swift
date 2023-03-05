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
    let presentUserPage: AnyObserver<Void>
    weak var transition:TransitionContainerViewController?
    private let disposeBag:DisposeBag
    init(navigationCircleViewModel:Pr_NavigationCircleViewModel,transition:TransitionContainerViewController) {
        disposeBag = DisposeBag()
        let presentSubject = PublishSubject<Void>()
        presentUserPage = presentSubject.asObserver()
        self.transition = transition
        self.navigationCircleViewModel = navigationCircleViewModel
        pangestureObservable = self.navigationCircleViewModel.pangestureObservable
        tapgestureObservable = self.navigationCircleViewModel.tapGestureObservable
        presentSubject.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.transition?.presentUserPageViewController()
        }).disposed(by: disposeBag)
        
    }
}
