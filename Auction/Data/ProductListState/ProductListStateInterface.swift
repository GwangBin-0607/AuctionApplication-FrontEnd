//
//  ProductListStateInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation
import RxSwift
protocol ProductListStateInterface {
    func updateTCPState()
    func updateHTTPState()
    func returnHttpState()->Int8
    func returnTCPState()->Int8
}
