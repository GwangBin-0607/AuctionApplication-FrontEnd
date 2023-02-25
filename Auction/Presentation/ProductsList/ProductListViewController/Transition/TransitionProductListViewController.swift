import Foundation
protocol TransitionProductListViewController:AnyObject{
    func presentDetailViewController(product_id:Int,streamNetworkInterface:SocketNetworkInterface)
}
