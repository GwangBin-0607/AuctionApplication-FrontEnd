import Foundation
import UIKit
protocol ContainerViewController{
    func present(ViewController:UIViewController?,animate:Bool)
    func dismiss(animate:Bool)
}
