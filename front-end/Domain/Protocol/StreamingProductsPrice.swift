//
//  StreamingProductPrice.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/19.
//

import Foundation
import RxSwift

protocol StreamingProductPrice{
    func connectingNetwork(state:isConnecting)
    func returningInputObservable()->Observable<Result<[StreamPrice],Error>>
    func returningSocketState()->Observable<isConnecting>
}
