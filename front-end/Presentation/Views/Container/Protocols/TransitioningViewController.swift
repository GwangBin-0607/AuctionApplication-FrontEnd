//
//  MainContainerViewControllerProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/29.
//

import Foundation
import UIKit
protocol TransitioningViewController{
    func present(ViewController:UIViewController?,animate:Bool)
    func dismiss(animate:Bool)
}
