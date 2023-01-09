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
    let products = BehaviorSubject<[Product]>(value: [])
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
        scrollSubject.withUnretained(self).flatMap( { owner,visibleCells in
            owner.usecase.updateStreamProduct(visibleCell: visibleCells)
        }).subscribe(onNext: {
            error in
//            print("Error Result  \(error)")
        },onDisposed: {
            print("Disposed")
        }).disposed(by: disposeBag)
        
        loadingImageObservable.withUnretained(self).flatMap { owner,products in
            owner.imageUseCase.returnProductsWithImageHeight(products: products)
        }.subscribe(onNext: products.onNext(_:)).disposed(by: disposeBag)
        
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
//            print("\(state.socketConnect) ||||\(state.error)")
        }).disposed(by: disposeBag)
        
    }
    deinit {
        print("VIEWMODEL DEINIT")
    }
    func controlSocketState(state: isConnecting) {
        usecase.returnControlStreamState(state: state)
    }
}
