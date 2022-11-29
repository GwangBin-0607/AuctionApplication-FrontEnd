//
//  ViewControllerProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/29.
//

import Foundation
protocol SetCoordinatorViewController{
    associatedtype TransitionViewProtocol
    var delegate:TransitionViewProtocol{get}
}

