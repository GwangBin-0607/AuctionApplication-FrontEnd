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
    
    private let cellViewModel:Pr_ProductListCollectionViewCellViewModel
    init(UseCase:Pr_ProductListWithImageHeightUsecase,CellViewModel:Pr_ProductListCollectionViewCellViewModel) {
        self.usecase = UseCase
        self.cellViewModel = CellViewModel
        disposeBag = DisposeBag()
        let scrollSubject = PublishSubject<[Int]>()
        scrollScrollView = scrollSubject.asObserver()
        let requestSubject = PublishSubject<Void>()
        requestProductsList = requestSubject.asObserver()
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
        
        requestSubject.asObservable().withUnretained(self).flatMap({
            owner,_ in
            return owner.usecase.returnProductList()
        }).withUnretained(self).withLatestFrom(products,resultSelector: {
            arg1,before in
            let (owner,after) = arg1
            return owner.addResult(before: before, after: after)
        }).withUnretained(self).subscribe(onNext: {
            owner,result in
            switch result {
            case .success(let list):
                owner.products.onNext(list)
            case .failure(let err):
                print(err)
            }
        }).disposed(by: disposeBag)
        
        usecase.returnStreamProduct().withUnretained(self).withLatestFrom(products,resultSelector: {
            arg1,before in
            let (owner,after) = arg1
            return owner.sumResult(before: before, after: after)
        }).withUnretained(self).subscribe(onNext: {
            owner,result in
            switch result {
            case .success(let list):
                owner.products.onNext(list)
            case .failure(let err):
                print(err)
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
extension ProductListCollectionViewModel{
    private func addArray(array: [Product],addArray:[Product])->[Product]{
        var resultProducts = array
        resultProducts.append(contentsOf:addArray)
        return resultProducts
    }
    private func addResult(before:[Product],after:Result<[Product],Error>)->Result<[Product],Error>{
        switch after {
        case .success(let list):
            return .success(addArray(array: before, addArray: list))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func sumResult(before:[Product],after:Result<[StreamPrice],Error>)->Result<[Product],Error>{
        switch after {
        case .success(let list):
            return .success(changeProductPrice(before: before, after: list))
        case .failure(let error):
            return .failure(error)
        }
    }
    private func changeProductPrice(before: [Product],after:[StreamPrice])->[Product]{
        var resultArray = before
        for i in 0..<after.count{
            for j in 0..<before.count{
                
                if(after[i].product_id == resultArray[j].product_id && after[i].product_price != resultArray[j].product_price){
                    resultArray[j].product_price = after[i].product_price
                }
            }
            
        }
        return resultArray
    }
}
