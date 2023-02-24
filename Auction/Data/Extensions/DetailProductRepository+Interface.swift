//
//  DetailProductRepository+Interface.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
final class DetailProductRepository{
    private let httpService:GetDetailProduct
    private let httpDetailProductTransfer:Pr_HTTPDataTransferDetailProduct
    init(httpService:GetDetailProduct,httpDetailProductTransfer:Pr_HTTPDataTransferDetailProduct) {
        self.httpService = httpService
        self.httpDetailProductTransfer = httpDetailProductTransfer
    }
}
extension DetailProductRepository:Pr_DetailProductRepository{
    func httpDetailProduct(productId: Int8) -> Observable<Result<DetailProduct, HTTPError>> {
        guard let data = try? httpDetailProductTransfer.requestDetailProduct(requestData: RequestDetailProductData(product_id: productId)) else{
            return Observable<Result<DetailProduct,HTTPError>>.create { ob in
                ob.onNext(.failure(HTTPError.DataError))
                ob.onCompleted()
                return Disposables.create()
            }
        }
        return Observable<Result<DetailProduct,HTTPError>>.create {
            [weak self] ob in
            self?.httpService.getDetailProduct(requestData: data, onComplete: {
                result in
                switch result {
                case .success(let data):
                    if let product = try? self?.httpDetailProductTransfer.responseDetailProduct(data: data){
                        ob.onNext(.success(product))
                    }else{
                        ob.onNext(.failure(.DecodeError))
                    }
                    ob.onCompleted()
                case .failure(let error):
                    ob.onNext(.failure(error))
                    ob.onCompleted()
                    
                }
            })
            return Disposables.create()
        }
    }
}
