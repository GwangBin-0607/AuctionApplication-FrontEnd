//
//  Pr_UserPageViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import RxSwift
protocol Pr_NavigationContentViewModel:AnyObject{
    var tapGestureObserver:AnyObserver<Void>{get}
    var tapGestureObservable:Observable<Void>{get}
    var backGestureObserver:AnyObserver<Void>{get}
    var backGestureObservable:Observable<Void>{get}
}
protocol Pr_UserPageViewControllerViewModel{
    var mock:AnyObserver<Void>{get}
    func setTransitioning(delegate:TransitionUserPageViewController)
}
