//
//  ProductList.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/25.
//

import Foundation

struct Product:Decodable{
    let id:Int
    let price:Int
    let imageURL:String?
    let title:String?
    let checkUpDown:Bool?
}
