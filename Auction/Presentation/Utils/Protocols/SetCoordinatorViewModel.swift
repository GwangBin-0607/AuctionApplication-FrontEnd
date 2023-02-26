import Foundation
protocol SetCoordinatorViewModel{
    associatedtype TransitionViewProtocol
    var delegate:TransitionViewProtocol{get}
}

