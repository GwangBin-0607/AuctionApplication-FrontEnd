//
//  ProductPrice.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/18.
//

import Foundation

struct StreamPrice:Codable{
    let product_id:Int
    let product_price:Int
    let auction_date:String
    let state:Bool
    let beforePrice:Int
}
