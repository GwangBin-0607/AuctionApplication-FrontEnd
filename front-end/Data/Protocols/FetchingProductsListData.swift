//
//  FetchingProductsList.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

protocol FetchingProductsListData{
    func returnData(lastNumber:Int)->Observable<Data>
}
