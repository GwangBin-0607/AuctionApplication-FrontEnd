//
//  Coordinator.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation

protocol Coordinator{
    var childCoordinator:[Coordinator]{get set}
    func start()->Void
}
