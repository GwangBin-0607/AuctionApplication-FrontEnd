//
//  FetchProductList.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/25.
//

import Foundation
import RxSwift

protocol ShowProductsList{
    func request(lastNumber:Int)->Observable<Result<[Product],Error>>
}
