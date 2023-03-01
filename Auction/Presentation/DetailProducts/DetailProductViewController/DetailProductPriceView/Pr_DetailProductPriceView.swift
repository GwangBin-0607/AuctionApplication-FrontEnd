//
//  Pr_DetailProductPriceView.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/27.
//

import Foundation
import UIKit
protocol Pr_DetailProductPriceView:UIView{
    func setGestureDelegata(delegate:GestureDelegate)
    func animateSubview()
    var buyProductButton:BuyProductButton{get}
}
