//
//  Pr_ErrorAlterViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/26.
//

import Foundation
import RxSwift
protocol Pr_ErrorAlterViewModel {
    var errorMessage:Observable<String>{get}
    var errorMessageObserver:AnyObserver<String>{get}
}
