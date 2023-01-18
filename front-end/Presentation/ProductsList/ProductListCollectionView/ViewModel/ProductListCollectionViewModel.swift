//
//  ProductListViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

final class ProductListCollectionViewModel:Pr_ProductListCollectionViewModel{
    private let usecase:Pr_ProductListWithImageHeightUsecase
    private let disposeBag:DisposeBag
    // MARK: VIEWCONTROLLER OUTPUT
    let productsList: Observable<[ProductSection]>
    let requestProductsList: AnyObserver<Void>
    let socketState: Observable<isConnecting>
    let scrollScrollView: AnyObserver<[Int]>
    let products = BehaviorSubject<[Product]>(value: [])
    
    let cellViewModel:Pr_ProductListCollectionViewCellViewModel
    init(UseCase:Pr_ProductListWithImageHeightUsecase,CellViewModel:Pr_ProductListCollectionViewCellViewModel) {
        self.usecase = UseCase
        self.cellViewModel = CellViewModel
        disposeBag = DisposeBag()
        let scrollSubject = PublishSubject<[Int]>()
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
            print("Error Result  \(error)")
        },onDisposed: {
            print("Disposed")
        }).disposed(by: disposeBag)
        
        usecase.returnProductList().withUnretained(self).subscribe(onNext: {
            owner,result in
            switch result {
            case .success(let list):
                owner.products.onNext(list)
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
        usecase.returnObservableStreamState().subscribe(onNext: {
            state in
//            print("\(state.socketConnect) ||||\(state.error)")
        }).disposed(by: disposeBag)
        
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func controlSocketState(state: isConnecting) {
        usecase.returnControlStreamState(state: state)
    }
    func returnPrice(index: IndexPath) -> Int {
        do{
            let product = try products.value()
           return product[index.item].product_price
            
        }catch{
           return 0
        }
    }
    func returnCellViewModel() -> Pr_ProductListCollectionViewCellViewModel {
        cellViewModel
    }
}