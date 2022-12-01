import RxSwift
protocol RequestingProductImageLoad{
    func imageLoad(inimage:RequestImage)->Observable<ResponseImage>
}
