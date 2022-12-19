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
    private let imageUseCase:RequestingProductImage
    private let disposeBag:DisposeBag
    // MARK: VIEWCONTROLLER OUTPUT
    let productsList: Observable<[ProductSection]>
    let isConnecting: Observable<isConnecting>
    let responseImage: Observable<ResponseImage>
    // MARK: VIEWCONTROLLER INPUT
    let requestProductsList: AnyObserver<Int>
    let requestSteamConnect: AnyObserver<isConnecting>
    let requestImage: AnyObserver<RequestImage>
    private let products = BehaviorSubject<[Product]>(value: [])
    private let imageThread = DispatchQueue(label: "imageThread",qos: .background)
    init(UseCase:ShowProductsList,ImageUseCase:RequestingProductImage) {
        print("INIT")
        self.usecase = UseCase
        self.imageUseCase = ImageUseCase
        disposeBag = DisposeBag()
        let requesting = PublishSubject<Int>()
        let connecting = PublishSubject<isConnecting>()
        let loadingImage = PublishSubject<[Product]>()
        let loadingImageObservable = loadingImage.asObservable()
        let loadingImageObserver = loadingImage.asObserver()
        let requestProductImage = PublishSubject<RequestImage>()
        let responseProductImage = PublishSubject<ResponseImage>()
        let requestProductImageObservable = requestProductImage.asObservable()
        let responseProductImageObserver = responseProductImage.asObserver()
        requestImage = requestProductImage.asObserver()
        responseImage = responseProductImage.asObservable()
        requestSteamConnect = connecting.asObserver()
        isConnecting = self.usecase.returningSocketState()
        requestProductsList = requesting.asObserver()
        productsList = products.asObservable().scan(ProductSection(products: [])) { (prevValue, newValue) in
            return ProductSection(original: prevValue, items: newValue)
        }.map({[$0]})
        
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
        
//        self.usecase.returningSocketState().subscribe(onNext: {
//            isConnecting in
//            print(isConnecting)
//        }).disposed(by: disposeBag)
        
        requestSteamConnect.onNext(.connect)
        
        
    }
    deinit {
        print("Viewmodel DEINIT")
    }
    var number = 100
}
extension ProductsListViewModel{
    func returnImageHeightFromViewModel(index: IndexPath) -> CGFloat {
        do{
            let product = try products.value()
            return product[index.item].imageHeight ?? 150
        }catch{
            return 150
        }
    }
}
extension ProductsListViewModel{
    func testFunction() {
        do{
            number += 1
            var product = try products.value()
            product[0].product_price = number
            product[10].product_price = number
            product[16].product_price = number
            self.products.onNext(product)
            
        }catch{
            print(error)
        }
    }
    func returnPrice(index: IndexPath) -> Int {
        do{
            let product = try products.value()
           return product[index.item].product_price
            
        }catch{
           return 0
        }
    }
}
