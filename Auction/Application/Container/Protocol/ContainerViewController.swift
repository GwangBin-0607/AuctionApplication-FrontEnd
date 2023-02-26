import Foundation
import UIKit
protocol ContainerViewController{
    func present(ViewController:Pr_ChildViewController,animate:Bool)
    func present(ViewController:UIViewController,animate:Bool)
    func dismiss(animate:Bool)
}
