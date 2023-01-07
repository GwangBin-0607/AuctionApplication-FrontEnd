//
//  ProductListViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

final class ProductListViewModel:ProductListViewControllerViewModelInterface{
    private let usecase:ProductListUsecaseInterface
    private let imageUseCase:ProductImageHeightUsecaseInterface
    private let disposeBag:DisposeBag
    // MARK: VIEWCONTROLLER OUTPUT
    let productsList: Observable<[ProductSection]>
    let requestProductsList: AnyObserver<Void>
    let socketState: Observable<SocketConnectState>
    let scrollScrollView: AnyObserver<[Int]>
    private let products = BehaviorSubject<[Product]>(value: [])
    init(UseCase:ProductListUsecaseInterface,ImageUseCase:ProductImageHeightUsecaseInterface) {
        self.usecase = UseCase
        self.imageUseCase = ImageUseCase
        disposeBag = DisposeBag()
        let scrollSubject = PublishSubject<[Int]>()
        let loadingImage = PublishSubject<[Product]>()
        let loadingImageObservable = loadingImage.asObservable()
        let loadingImageObserver = loadingImage.asObserver()
        scrollScrollView = scrollSubject.asObserver()
        requestProductsList = usecase.returnRequestObserver()
        productsList = products.asObservable().scan(ProductSection(products: [])) { (prevValue, newValue) in
            return ProductSection(original: prevValue, items: newValue)
        }.map({[$0]})
        socketState = usecase.returnObservableStreamState()
        scrollSubject.withUnretained(self).flatMap { owner,visibleCells in
            if let observale = owner.usecase.updateStreamProduct(visibleCell: visibleCells){
                return observale
            }else{
                return Observable<Error?>.create { observer in
                    observer.onNext(nil)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
        }.subscribe(onNext: {
            error in
//            print("Error Result  \(error)")
        },onDisposed: {
            print("Disposed")
        }).disposed(by: disposeBag)
        
        loadingImageObservable.withUnretained(self).subscribe(onNext: {
            owner,productsList in
            var addHeightProductList = productsList
            for i in 0..<addHeightProductList.count{
                addHeightProductList[i].imageHeight = owner.imageUseCase.returnImageHeight(productId: addHeightProductList[i].product_id, imageURL: addHeightProductList[i].mainImageURL)
            }
            owner.products.onNext(addHeightProductList)
            
        }).disposed(by: disposeBag)
        
        
//        let a = loadingImageObservable.withUnretained(self).flatMap {
//            owner,list in
//            var addedArray:[Observable<CGFloat>] = []
//            for i in 0 ..< list.count{
//                addedArray.append(owner.imageUseCase.T_returnImageHeight(productId: list[i].product_id, imageURL: list[i].mainImageURL))
//            }
//            return Observable.from(addedArray)
//        }
//        a.subscribe(onNext: {
//            observable in
//            observable.subscribe(onNext: {
//                height in
//                print(height)
//            })
//        })
        usecase.returnProductList().subscribe(onNext: {
            result in
            switch result {
            case .success(let list):
                loadingImageObserver.onNext(list)
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
        usecase.returnObservableStreamState().subscribe(onNext: {
            state in
            print("\(state.socketConnect) ||||\(state.error)")
        }).disposed(by: disposeBag)
        
    }
    deinit {
        print("VIEWMODEL DEINIT")
    }
    func controlSocketState(state: isConnecting) {
        usecase.returnControlStreamState(state: state)
    }
}
extension ProductListViewModel:ProductListCollectionViewLayoutViewModelInterface{
    func returnImageHeightFromViewModel(index: IndexPath) -> CGFloat {
        do{
            let product = try products.value()
            return product[index.item].imageHeight ?? 150
        }catch{
            return 150
        }
    }
}
extension ProductListViewModel:ProductListCollectionViewModelInterface{
    func returnPrice(index: IndexPath) -> Int {
        do{
            let product = try products.value()
           return product[index.item].product_price
            
        }catch{
           return 0
        }
    }
}
