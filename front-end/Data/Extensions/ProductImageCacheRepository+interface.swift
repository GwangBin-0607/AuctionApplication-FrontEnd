//
//  ProductImageCacheRepository.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/07.
//

import Foundation
import UIKit
final class ProductImageCacheRepository{
    let lock:NSLock
    let imageCache:NSCache<NSNumber,UIImage>
    init(){
        lock = NSLock()
        imageCache = NSCache()
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
}
extension ProductImageCacheRepository:ProductImageCacheRepositoryInterface{
    func setImage(key:Int,value:UIImage) {
        lock.lock()
        defer{
            lock.unlock()
        }
        imageCache.setObject(value, forKey: NSNumber(integerLiteral: key))
    }
    func getImage(key:Int) -> UIImage? {
        lock.lock()
        defer{
            lock.unlock()
        }
        return imageCache.object(forKey: NSNumber(integerLiteral: key))
    }
}
