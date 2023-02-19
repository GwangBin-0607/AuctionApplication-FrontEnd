//
//  Pr_HTTPDataTransferProductImage.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/19.
//

import Foundation
struct RequestProductImage:Encodable{
    let image_id:Int
}
protocol Pr_HTTPDataTransferProductImage{
    func requestProductImage(requestData:RequestProductImage)throws->Data
    func responseProductImage(data:Data) throws -> Product_Images
}
