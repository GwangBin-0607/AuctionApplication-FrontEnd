//
//  ProductList.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/25.
//

import Foundation
import UIKit
struct Product:Decodable{
    var product_id:Int
    var product_price:Int
    let imageURL:String?
    var product_name:String?
    let checkUpDown:Bool?
    var imageHeight:CGFloat?
}
