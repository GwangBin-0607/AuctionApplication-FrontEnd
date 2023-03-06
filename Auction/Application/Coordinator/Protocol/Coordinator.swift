//
//  Coordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit
protocol Coordinator:AnyObject{
    var viewController:UIViewController?{get set}
    var childCoordinator:[Coordinator]{get set}
    var containerViewController:ContainerViewController{get}
    func start()->Void
}
