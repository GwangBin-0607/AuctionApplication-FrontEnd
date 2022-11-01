//
//  RequestProductsUseCase+RequestingProducts.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

extension ShowProductsListUseCase:ShowProductsList{
    
    func request(lastNumber:Int) -> Observable<[Product]> {
        return fetchingRepository.returnData(lastNumber: 1).map { Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
            return response
        }
    }
}
