//
//  Coordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation

protocol Coordinator:AnyObject{
    
    var childCoordinator:[Coordinator]{get set}
    var containerViewController:ContainerViewController?{get set}
    func start()->Void
}
