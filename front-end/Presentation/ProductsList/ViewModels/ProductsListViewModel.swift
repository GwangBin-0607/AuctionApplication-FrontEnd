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
    let responseProductImageHeight: Observable<RequestImageHeight>
    // MARK: VIEWCONTROLLER INPUT
    let requestProductsList: AnyObserver<Int>
    let requestSteamConnect: AnyObserver<isConnecting>
    let requestProductImage: AnyObserver<RequestImage>
    let requestProductImageHeight: AnyObserver<IndexPath>
    init(UseCase:ShowProductsList,ImageUseCase:RequestingProductImageLoad) {
        self.usecase = UseCase
        self.imageUseCase = ImageUseCase
        disposeBag = DisposeBag()
        let requesting = PublishSubject<Int>()
        let products = BehaviorSubject<[Product]>(value: [])
        let connecting = PublishSubject<isConnecting>()
        let requestingImage = PublishSubject<RequestImage>()
        let requestImageHeight = PublishSubject<IndexPath>()
        let responseImageHeight = PublishSubject<RequestImageHeight>()
        responseProductImageHeight = responseImageHeight.asObservable()
        requestProductImageHeight = requestImageHeight.asObserver()
        requestProductImage = requestingImage.asObserver()
        requestSteamConnect = connecting.asObserver()
        isConnecting = self.usecase.returningSocketState()
        requestProductsList = requesting.asObserver()
        productsList = products.asObservable()
        responseProductImage = requestingImage.asObservable().flatMap({ re in
            return Observable<ResponseImage>.create { observer in
                let image = ImageUseCase.imageLoad(imageURL: re.imageURL)
                let responseImage = ResponseImage(cell: re.cell, image: image, tag: re.tag)
                observer.onNext(responseImage)
                return Disposables.create()
            }
  
        }).do(onNext: {
            reponseImage in
            do{
                print("do")
                var products = try products.value()
                products[reponseImage.tag].imageHeigh = reponseImage.image?.size.height
                print(products[reponseImage.tag].imageHeigh)
            }
        })
            
        
        let responseImageHeightObserver = responseImageHeight.asObserver()
        requestImageHeight.asObservable().subscribe(onNext: {
            indexPath in
            do{
                let products = try products.value()
                if(products.count>indexPath.item){
                    print(products[indexPath.item].imageHeigh)
                    let requestImageHeight = RequestImageHeight(height: products[indexPath.item].imageHeigh ?? 150.0 , location: indexPath)
                    responseImageHeightObserver.onNext(requestImageHeight)
                }
            }catch{
                responseImageHeightObserver.onNext(RequestImageHeight(height: 150.0, location: indexPath))
            }
        }).disposed(by: disposeBag)
        
        
        requesting.flatMap(usecase.request)
            .subscribe(onNext: {
                fetchResult in
                switch fetchResult{
                case .success(let productList):
                    if let value = try? products.value(){
                        products.onNext(value+productList)
                    }else{
                        products.onNext(productList)
                    }
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
        
        self.usecase.returningInputObservable().subscribe(onNext: {
            results in
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
