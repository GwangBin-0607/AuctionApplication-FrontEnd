import Foundation
import UIKit
protocol TransitioningViewController{
    func present(ViewController:UIViewController?,animate:Bool)
    func dismiss(animate:Bool)
}
