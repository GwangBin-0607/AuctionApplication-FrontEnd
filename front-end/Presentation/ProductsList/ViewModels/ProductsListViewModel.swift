//
//  ProductListViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

final class ProductsListViewModel:BindingProductsListViewModel{
    private let usecase:ShowProductsList
    private let imageUseCase:RequestingProductImageLoad
    private let disposeBag:DisposeBag
    // MARK: VIEWCONTROLLER OUTPUT
    let productsList: Observable<[Product]>
    let isConnecting: Observable<isConnecting>
    let responseProductImage: Observable<ResponseImage>
    // MARK: VIEWCONTROLLER INPUT
    let requestProductsList: AnyObserver<Int>
    let requestSteamConnect: AnyObserver<isConnecting>
    let requestProductImage: AnyObserver<RequestImage>
    private let products = BehaviorSubject<[Product]>(value: [])
    private let imageThread = DispatchQueue(label: "imageThread", qos: .background, attributes: .concurrent)
    init(UseCase:ShowProductsList,ImageUseCase:RequestingProductImageLoad) {
        self.usecase = UseCase
        self.imageUseCase = ImageUseCase
        disposeBag = DisposeBag()
        let requesting = PublishSubject<Int>()
        let connecting = PublishSubject<isConnecting>()
        let requestingImage = PublishSubject<RequestImage>()
        let loadingImage = PublishSubject<[Product]>()
        let loadingImageObservable = loadingImage.asObservable()
        let loadingImageObserver = loadingImage.asObserver()
        requestProductImage = requestingImage.asObserver()
        requestSteamConnect = connecting.asObserver()
        isConnecting = self.usecase.returningSocketState()
        requestProductsList = requesting.asObserver()
        productsList = products.asObservable()
        responseProductImage = requestingImage.asObservable().observe(on: ConcurrentDispatchQueueScheduler.init(queue: imageThread)).flatMap({ re in
            return Observable<ResponseImage>.create { observer in
                let image = ImageUseCase.returnImage(productId: re.productsId)
                let responseImage = ResponseImage(cell: re.cell, image: image, tag: re.tag)
                observer.onNext(responseImage)
                observer.onCompleted()
                return Disposables.create()
            }
        })
        loadingImageObservable.withUnretained(self).subscribe(onNext: {
            owner,productsList in
            var addHeightProductList = productsList
            for i in 0..<addHeightProductList.count{
                addHeightProductList[i].imageHeight = owner.imageUseCase.returnImageHeight(productId: addHeightProductList[i].product_id, imageURL: addHeightProductList[i].imageURL!)
            }
            owner.products.onNext(addHeightProductList)
            
        }).disposed(by: disposeBag)
        
        requesting.flatMap(usecase.request).withUnretained(self)
            .subscribe(onNext: {
                owner,fetchResult in
                switch fetchResult{
                case .success(let productList):
                    if let value = try? owner.products.value(){
                        loadingImageObserver.onNext(productList+value)
                    }
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
        
        
        self.usecase.returningInputObservable().withUnretained(self).subscribe(onNext: {
            owner, results in
            print(results)
        }).disposed(by: disposeBag)
        
        connecting.withUnretained(self).subscribe(onNext: {
            owner, isConnecting in
            owner.usecase.connectingNetwork(state: isConnecting)
        }).disposed(by: disposeBag)
        
        requestSteamConnect.onNext(.connect)
        
        
    }
    deinit {
        print("Viewmodel DEINIT")
    }
}
extension ProductsListViewModel{
    func returnHeight(index:IndexPath)->CGFloat{
        do{
            let product = try products.value()
            return product[index.item].imageHeight ?? 150
        }catch{
            return 150
        }
    }
}
