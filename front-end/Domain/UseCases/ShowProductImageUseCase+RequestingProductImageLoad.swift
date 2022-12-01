import Foundation
import RxSwift
class ShowProductImageUseCase:RequestingProductImageLoad{
    func imageLoad(imageURL: String) -> UIImage {
        UIImage(named: imageURL)!
    }
}
