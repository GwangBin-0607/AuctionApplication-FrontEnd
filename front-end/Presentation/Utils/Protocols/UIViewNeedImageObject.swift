import UIKit
import RxSwift
struct RequestImage{
    let cell:UIViewNeedImage
    let imageURL:String
    let tag:Int
}
struct ResponseImage{
    let cell:UIViewNeedImage
    let image:UIImage?
    let tag:Int
}

protocol UIViewNeedImage{
    var imageBinding:AnyObserver<ResponseImage>{get}
}
