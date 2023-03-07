//
//  asd.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/07.
//

import Foundation
import RxSwift
final class CustomNavigationViewModel:Pr_CustomNavigationViewModel{
    let tapGestureObserver: AnyObserver<Void>
    let tapGestureObservable: Observable<Void>
    let backGestureObserver: AnyObserver<Void>
    let backGestureObservable: Observable<Void>
    init() {
        let backGestureSubject = PublishSubject<Void>()
        backGestureObservable = backGestureSubject.asObservable()
        backGestureObserver = backGestureSubject.asObserver()
        let tapGestureSubject = PublishSubject<Void>()
        tapGestureObserver = tapGestureSubject.asObserver()
        tapGestureObservable = tapGestureSubject.asObservable()
    }
}
