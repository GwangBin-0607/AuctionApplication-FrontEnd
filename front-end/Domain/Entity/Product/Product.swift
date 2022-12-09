//
//  ProductList.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/25.
//

import Foundation
import UIKit
struct Product:Decodable{
    let product_id:Int
    let product_price:Int
    let imageURL:String?
    let product_name:String?
    let checkUpDown:Bool?
    var imageHeight:CGFloat?
}
