//
//  DetailProductViewCoordinatorProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/29.
//

import Foundation
protocol HasParentCoordinator:AnyObject{
    associatedtype CoordinatorDelegateType
    var delegate:CoordinatorDelegateType{get}
}
