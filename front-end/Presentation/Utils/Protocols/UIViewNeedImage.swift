import UIKit
import RxSwift
struct RequestImage{
    let cell:UIViewNeedImage
    let productsId:Int
    let imageURL:String?
    let imageTag:Int
}
struct ResponseImage{
    let cell:UIViewNeedImage
    let image:UIImage
    let imageTag:Int
    func setImage(){
        cell.imageBinding.onNext(self)
    }
}
protocol UIViewNeedImage:AnyObject{
    var imageBinding:AnyObserver<ResponseImage>{get}
}
