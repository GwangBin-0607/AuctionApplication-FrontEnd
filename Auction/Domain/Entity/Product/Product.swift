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
    let product_id:Int
    var original_price:Int
    let imageURL:[Image]
    var mainImage:Image?{
        get{
            if imageURL.isEmpty{
                return nil
            }else{
                return imageURL[0]
            }
        }
    }
    let product_name:String
    var checkUpDown:ProductUpDown
    var imageHeight:CGFloat!
    var product_price:ProductPrice
    enum CodingKeys:String,CodingKey{
        case product_id
        case original_price
        case product_name
        case imageURL = "Product_Images"
        case checkUpDown = "Product_UpDown"
        case product_price = "Product_Price"
    }
}
struct Image:Decodable{
    let image_id:Int
}
struct ProductPrice:Decodable{
    var auction_date:String
    var price:Int
    var beforePrice:Int
    
}
struct ProductUpDown:Decodable{
    var state:Bool
}
extension Product:IdentifiableType,Equatable{
    var identity: Int {
        product_id
    }
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.product_id == rhs.product_id && lhs.product_price.price == rhs.product_price.price && lhs.product_price.auction_date == rhs.product_price.auction_date
    }
}
struct ProductSection{
    var sectionHeader:Int = 0
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

