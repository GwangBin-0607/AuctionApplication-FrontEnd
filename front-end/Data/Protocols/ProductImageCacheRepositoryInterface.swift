//
//  ProductImageCacheRepositoryInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import UIKit
protocol ProductImageCacheRepositoryInterface{
    func setImage(key:Int,value:UIImage)
    func getImage(key:Int)->UIImage?
}
