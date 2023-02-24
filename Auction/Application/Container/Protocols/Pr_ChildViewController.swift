import Foundation
import UIKit
import RxSwift

protocol Pr_ChildViewController:UIViewController{
    var presentObserver:AnyObserver<Void>?{get}
    var presentObservable:Observable<Void>?{get}
}
class ChildViewControler:UIViewController,Pr_ChildViewController{
    var presentObserver: AnyObserver<Void>?
    var presentObservable: Observable<Void>?
    private func bind(){
        
    }
}
