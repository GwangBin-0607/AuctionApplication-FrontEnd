import UIKit
import RxSwift
struct ResponseImage{
    let cell:RequestImageCell
    let image:UIImage
    let productId:Int
    func setImage(){
        cell.setImageObserver.onNext(self)

    }
}

struct RequestImage{
    let cell:RequestImageCell
    let productId:Int
    let imageURL:String?
}
protocol RequestImageCell{
    var setImageObserver:AnyObserver<ResponseImage>{get}
}
