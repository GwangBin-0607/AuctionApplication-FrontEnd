//
//  DetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
struct DetailProduct:Decodable{
    let productImage:DetailProductImages
    let productUser:DetailProductUser
    let productComment:DetailProductComment
    let productGraph:DetailProductGraph
    init() {
        productImage = DetailProductImages(images: [Product_Images(image_id: 1)])
        productUser = DetailProductUser(userName: "Hello")
        productComment = DetailProductComment(comment: "Comment")
        productGraph = DetailProductGraph(data: [GraphData(date: "Today", price: 3000)])
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
}
struct DetailProductImages:Decodable{
    let images:[Product_Images]
    func returnImageCount()->Int{
        images.count
    }
}
struct DetailProductUser:Decodable{
    let userName:String
}
struct DetailProductComment:Decodable{
    let comment:String
}
struct DetailProductGraph:Decodable{
    let data:[GraphData]
}
struct GraphData:Decodable{
    let date:String
    let price:Int
}
