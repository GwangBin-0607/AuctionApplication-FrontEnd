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
    private let navigationContentViewModel:Pr_NavigationContentViewModel
    let pangestureObservable: Observable<Pangesture>
    let tapgestureObservable: Observable<Void>
    let backGestureObserver: AnyObserver<Void>
    private let disposeBag:DisposeBag
    init(navigationCircleViewModel:Pr_NavigationCircleViewModel,navigationContentViewModel:Pr_NavigationContentViewModel) {
        disposeBag = DisposeBag()
        self.navigationContentViewModel = navigationContentViewModel
        self.navigationCircleViewModel = navigationCircleViewModel
        pangestureObservable = self.navigationCircleViewModel.pangestureObservable
        let tapSubject = PublishSubject<Void>()
        tapgestureObservable = tapSubject.asObservable()
        let tapObserver = tapSubject.asObserver()
        let backSubject = PublishSubject<Void>()
        backGestureObserver = backSubject.asObserver()
        backSubject.asObservable().withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.navigationContentViewModel.backGestureObserver.onNext(())
            owner.navigationCircleViewModel.backGestureObserver.onNext(())
        }).disposed(by: disposeBag)
        self.navigationCircleViewModel.tapGestureObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.navigationContentViewModel.tapGestureObserver.onNext(())
            tapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        
    }
}
