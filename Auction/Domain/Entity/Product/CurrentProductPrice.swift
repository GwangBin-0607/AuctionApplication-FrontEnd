//
//  BuyProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/25.
//

import Foundation
struct CurrentProductPrice:Decodable{
    let product_id:Int
    let before_price:Int
    let price:Int
    let checkUpDown:ProductUpDown
    enum CodingKeys: String,CodingKey {
        case product_id
        case before_price = "beforePrice"
        case price
        case checkUpDown
    }
}
