import UIKit
import RxSwift
protocol UIViewNeedImage{
    var imageBinding:AnyObserver<UIImage>{get}
}
