//
//  ErrorAlterViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/26.
//

import Foundation
import RxSwift
class ErrorAlterViewModel:Pr_ErrorAlterViewModel{
    let errorMessage: Observable<String>
    let errorMessageObserver: AnyObserver<String>
    init(){
        let errorMessageSubject = PublishSubject<String>()
        errorMessage = errorMessageSubject.asObservable()
        errorMessageObserver = errorMessageSubject.asObserver()
    }
}
