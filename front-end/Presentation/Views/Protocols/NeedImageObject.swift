import UIKit
import RxSwift
protocol NeedImageObject{
    var imageBinding:AnyObserver<UIImage>{get}
}
