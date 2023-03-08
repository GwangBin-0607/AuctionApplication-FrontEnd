//
//  Pr_LoginViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import RxSwift
protocol Pr_LoginViewControllerViewModel{
    var backObserver:AnyObserver<Void>{get}
}
