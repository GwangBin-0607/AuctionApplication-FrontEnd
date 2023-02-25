//
//  DetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
struct DetailProduct:Decodable{
    let productInfo:DetailProductInfo
    let productImage:DetailProductImages
    let productUser:DetailProductUser
    let productComment:DetailProductComment
    let productGraph:DetailProductGraph
    func returnProductInfo()->DetailProductInfo{
        productInfo
    }
    func returnProductImages()->DetailProductImages{
        productImage
    }
    func returnProductUser()->DetailProductUser{
        productUser
    }
    func returnProductComment()->DetailProductComment{
        productComment
    }
    func returnProductGraph()->DetailProductGraph{
        productGraph
    }
    enum CodingKeys: String,CodingKey {
        case productInfo = "DetailProductInfo"
        case productImage = "DetailProductImages"
        case productUser = "DetailProductUser"
        case productComment = "DetailProductComment"
        case productGraph = "DetailProductGraph"
    }
}
struct DetailProductInfo:Decodable{
    let product_id:Int
}
struct DetailProductImages:Decodable{
    let images:[Image]
    func returnImageCount()->Int{
        if images.isEmpty{
            return 1
        }else{
            return images.count
        }
    }
    func returnProductImage(index:Int)->Image?{
        if index >= images.count{
            return nil
        }else{
            return images[index]
        }
    }
}
struct DetailProductUser:Decodable{
    let user_id:Int
    let user_name:String
    let user_image:[Image]
    func returnMainUserImage()->Image?{
        if user_image.isEmpty{
            return nil
        }else{
            return user_image[0]
        }
    }
    enum CodingKeys: String,CodingKey {
        case user_id
        case user_name
        case user_image = "User_Images"
    }
}
struct DetailProductComment:Decodable{
    let product_name:String
    let registerTime:String
    let comment:String
    let original_price:Int
}
struct DetailProductGraph:Decodable{
    let data:[GraphData]
}
struct GraphData:Decodable{
    let auction_date:String
    let price:Int
}
