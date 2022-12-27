//
//  ProductList.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/25.
//

import Foundation
import UIKit
import RxDataSources
struct Product:Decodable{
    static let productHeader:Int = 0
    let product_id:Int
    var product_price:Int
    let imageURL:String?
    let product_name:String?
    let checkUpDown:Bool?
    var imageHeight:CGFloat?
}
extension Product:IdentifiableType,Equatable{
    var identity: Int {
        product_id
    }
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.product_id == rhs.product_id && lhs.product_price == rhs.product_price
    }
}
struct ProductSection{
    var sectionHeader:Int = Product.productHeader
    var products:[Product]
}
extension ProductSection:AnimatableSectionModelType{
    var items: [Product] {
        products
    }
    
    init(original: ProductSection, items: [Product]) {
        self = original
        self.products = items
    }
     
    var identity: Int {
        sectionHeader
    }
}

