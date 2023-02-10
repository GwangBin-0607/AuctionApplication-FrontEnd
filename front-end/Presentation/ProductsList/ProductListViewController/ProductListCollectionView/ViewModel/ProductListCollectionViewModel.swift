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
    let errorMessage: Observable<HTTPError>
    let presentDetailProductObserver: AnyObserver<Int>
    var presentDetailProductObservable: Observable<Int?>!
    private let footerViewModel:Pr_ProductListCollectionFooterViewModel
    private let cellViewModel:Pr_ProductListCollectionViewCellViewModel
    init(UseCase:Pr_ProductListWithImageHeightUsecase,CellViewModel:Pr_ProductListCollectionViewCellViewModel,FooterViewModel:Pr_ProductListCollectionFooterViewModel) {
        self.usecase = UseCase
        self.footerViewModel = FooterViewModel
        self.cellViewModel = CellViewModel
        disposeBag = DisposeBag()
        let presentDetailProductSubject = PublishSubject<Int>()
        presentDetailProductObserver = presentDetailProductSubject.asObserver()
        let scrollSubject = PublishSubject<[Int]>()
        scrollScrollView = scrollSubject.asObserver()
        let requestSubject = PublishSubject<Void>()
        requestProductsList = requestSubject.asObserver()
        let errorSubject = PublishSubject<HTTPError>()
        errorMessage = errorSubject.asObservable().observe(on: MainScheduler.asyncInstance)
        let errorObserver = errorSubject.asObserver()
        productsList = products.asObservable().scan(ProductSection(products: [])) { (prevValue, newValue) in
            return ProductSection(original: prevValue, items: newValue)
        }.map({[$0]})
        socketState = usecase.returnObservableStreamState()
        presentDetailProductObservable = presentDetailProductSubject.map({
            [weak self] idx in
            self?.returnProductId(index: idx)
        })
        
        scrollSubject.withUnretained(self).flatMap( { owner,visibleCells in
            owner.usecase.updateStreamProduct(visibleCell: visibleCells)
        }).subscribe(onNext: {
            error in
            print("Error Result  \(error)")
        },onDisposed: {
            print("Disposed")
        }).disposed(by: disposeBag)
        
        requestSubject.asObservable().do(onNext: {
            [weak self] _ in
            self?.footerViewModel.activityObserver.onNext(true)
        }).withUnretained(self).flatMap({
            owner,_ in
            return owner.usecase.returnProductList()
        }).withUnretained(self).withLatestFrom(products,resultSelector: {
            arg1,before in
            let (owner,after) = arg1
            return owner.addResult(before: before, after: after)
        }).do(onNext: {
            [weak self] _ in
            self?.footerViewModel.activityObserver.onNext(false)
        }).withUnretained(self).subscribe(onNext: {
            owner,result in
            switch result {
            case .success(let list):
                owner.products.onNext(list)
            case .failure(let err):
                print("-========")
                print(err)
                errorObserver.onNext(err)
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
                print("-========")
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
    func returnAnimationValue(index: IndexPath) -> AnimtionValue? {
        if let product = try? products.value(){
            return AnimtionValue(price: product[index.item].product_price.price, state: product[index.item].checkUpDown.state,beforePrice: product[index.item].product_price.beforePrice)
        }else{
            return nil
        }
    }
    func returnCellViewModel() -> Pr_ProductListCollectionViewCellViewModel {
        cellViewModel
    }
    func returnFooterViewModel() -> Pr_ProductListCollectionFooterViewModel {
        footerViewModel
    }
}
extension ProductListCollectionViewModel{
    private func addArray(array: [Product],addArray:[Product])->[Product]{
        var resultProducts = array
        resultProducts.append(contentsOf:addArray)
        return resultProducts
    }
    private func addResult(before:[Product],after:Result<[Product],HTTPError>)->Result<[Product],HTTPError>{
        switch after {
        case .success(let list):
            return .success(addArray(array: before, addArray: list))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func sumResult(before:[Product],after:Result<[StreamPrice],StreamError>)->Result<[Product],StreamError>{
        switch after {
        case .success(let list):
            return .success(changeProductPrice(before: before, after: list))
        case .failure(let error):
            return .failure(error)
        }
    }
    private func changeProductPrice(before: [Product],after:[StreamPrice])->[Product]{
        var resultArray = before
        after.forEach { eachProduct in
            if let index = resultArray.firstIndex(where: {$0.product_id == eachProduct.product_id}){
                resultArray[index].product_price.price = eachProduct.product_price
                resultArray[index].checkUpDown.state = eachProduct.state
                resultArray[index].product_price.beforePrice = eachProduct.beforePrice
            }
        }
        return resultArray
    }
}
extension ProductListCollectionViewModel{
    func lastIndex() -> IndexPath {
        do{
            let product = try products.value()
            return IndexPath(item: product.count-1, section: 0)
            
        }catch{
           return IndexPath(item: 0, section: 0)
        }
    }
    private func returnProductId(index:Int)->Int?{
        do{
            let product = try products.value()
            return product[index].product_id
        }catch{
            return nil
        }
    }
}
