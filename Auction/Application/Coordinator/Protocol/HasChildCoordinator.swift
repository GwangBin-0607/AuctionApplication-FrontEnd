//
//  DetailProductViewCoordinatorDelegate.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/29.
//

import Foundation

protocol HasChildCoordinator:AnyObject{
    func removeChildCoordinator(Co:Coordinator)
    func toLogin()
}
extension HasChildCoordinator{
    func toLogin(){
        
    }
}
