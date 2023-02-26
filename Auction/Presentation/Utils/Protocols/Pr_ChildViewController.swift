//
//  Pr_ChildViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/25.
//

import UIKit

protocol Pr_ChildViewController:UIViewController{
    var completion:(()->Void)?{get set}
}
