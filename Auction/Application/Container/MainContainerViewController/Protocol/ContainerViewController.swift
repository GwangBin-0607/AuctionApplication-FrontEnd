import Foundation
import UIKit
protocol ContainerViewController:UIViewController{
    func present(ViewController:Pr_ChildViewController,animate:Bool)
    func present(ViewController:UIViewController,animate:Bool)
    func presentNaviationViewController(ViewController:ContainerViewController)
    func dismiss(animate:Bool,viewController:UIViewController?)
}
extension ContainerViewController{
    func present(ViewController:Pr_ChildViewController,animate:Bool){
        
    }
    func presentNaviationViewController(ViewController:ContainerViewController){
        
    }
}
