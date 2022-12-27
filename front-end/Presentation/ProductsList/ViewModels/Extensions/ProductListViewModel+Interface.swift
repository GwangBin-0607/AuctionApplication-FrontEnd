//
//  ProductListViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

final class ProductListViewModel:ProductsListViewModelInterface{
    private let usecase:ProductListUsecaseInterface
    private let imageUseCase:ProductImageUsecaseInterface
    private let disposeBag:DisposeBag
    // MARK: VIEWCONTROLLER OUTPUT
    let productsList: Observable<[ProductSection]>
    let requestProductsList: AnyObserver<Void>
    let requestImage: AnyObserver<RequestImage>
    let responseImage: Observable<ResponseImage>
    let socketState: Observable<isConnecting>
    private let products = BehaviorSubject<[Product]>(value: [])
    private let imageThread = DispatchQueue(label: "imageThread",qos: .background)
    init(UseCase:ProductListUsecaseInterface,ImageUseCase:ProductImageUsecaseInterface) {
        self.usecase = UseCase
        self.imageUseCase = ImageUseCase
        disposeBag = DisposeBag()
        let loadingImage = PublishSubject<[Product]>()
        let loadingImageObservable = loadingImage.asObservable()
        let loadingImageObserver = loadingImage.asObserver()
        let requestProductImage = PublishSubject<RequestImage>()
        let responseProductImage = PublishSubject<ResponseImage>()
        let requestProductImageObservable = requestProductImage.asObservable()
        let responseProductImageObserver = responseProductImage.asObserver()
        requestImage = requestProductImage.asObserver()
        responseImage = responseProductImage.asObservable()
        requestProductsList = usecase.returnRequestObserver()
        productsList = products.asObservable().scan(ProductSection(products: [])) { (prevValue, newValue) in
            return ProductSection(original: prevValue, items: newValue)
        }.map({[$0]})
        socketState = usecase.returnObservableStreamState()
        
        requestProductImageObservable.observe(on: ConcurrentDispatchQueueScheduler.init(queue: imageThread)).withUnretained(self).subscribe(onNext: {
            owner,request in
            let image = owner.imageUseCase.returnImage(productId: request.productId, imageURL: request.imageURL)
            let responseImage = ResponseImage(cell:request.cell,image: image, productId: request.productId)
            responseProductImageObserver.onNext(responseImage)
        }).disposed(by: disposeBag)
        
        loadingImageObservable.withUnretained(self).subscribe(onNext: {
            owner,productsList in
            var addHeightProductList = productsList
            for i in 0..<addHeightProductList.count{
                addHeightProductList[i].imageHeight = owner.imageUseCase.returnImageHeight(productId: addHeightProductList[i].product_id, imageURL: addHeightProductList[i].imageURL!)
            }
            owner.products.onNext(addHeightProductList)
            
        }).disposed(by: disposeBag)
        
        usecase.returnProductList().subscribe(onNext: {
            result in
            switch result {
            case .success(let list):
                loadingImageObserver.onNext(list)
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
        
    }

}
extension ProductListViewModel{
    func returnImageHeightFromViewModel(index: IndexPath) -> CGFloat {
        do{
            let product = try products.value()
            return product[index.item].imageHeight ?? 150
        }catch{
            return 150
        }
    }
}
extension ProductListViewModel{
    func returnPrice(index: IndexPath) -> Int {
        do{
            let product = try products.value()
           return product[index.item].product_price
            
        }catch{
           return 0
        }
    }
}
