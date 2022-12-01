import Foundation
import RxSwift
class ShowProductImageUseCase:RequestingProductImageLoad{
    init() {
    }
    func imageLoad(inimage:RequestImage)->Observable<ResponseImage>{
        Observable<ResponseImage>.create { observer in
            let returnImage = UIImage(named: inimage.imageURL)
            let imageProperty = ResponseImage(cell: inimage.cell ,image: returnImage)
            observer.onNext(imageProperty)
            observer.onCompleted()
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    }
}
