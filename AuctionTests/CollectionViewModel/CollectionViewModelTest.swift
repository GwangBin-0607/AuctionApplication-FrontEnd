//
//  CollectionViewModelTest.swift
//  front-endTests
//
//  Created by 안광빈 on 2023/01/26.
//

import XCTest
@testable import front_end_DEBUG
@testable import RxSwift
func testFinishObservable<testType>()->Observable<testType>{
    return Observable<testType>.create { ob in
        ob.onCompleted()
        return Disposables.create()
    }
}
final class CollectionViewModelTest: XCTestCase {
    var viewModel:Pr_ProductListCollectionViewModel!
    class Mock_ProductListWithImageHeightUsecase:Pr_ProductListWithImageHeightUsecase{
        
        func returnProductList() -> Observable<Result<[Product], HTTPError>> {
            return testFinishObservable()
        }
        
        func returnStreamProduct() -> Observable<Result<[StreamPrice], StreamError>> {
            return streamObservable
        }
        
        func returnObservableStreamState() -> Observable<isConnecting> {
            testFinishObservable()
        }
        
        func returnControlStreamState(state: isConnecting) {
            
        }
        
        func updateStreamProduct(visibleCell: [Int]) -> Observable<Result<Bool, StreamError>> {
            testFinishObservable()
        }
        func sendStreamPrice(price:StreamPrice){
            let stream = [price]
            streamObserver.onNext(.success(stream))
        }
        let streamObservable:Observable<Result<[StreamPrice],StreamError>>
        let streamObserver:AnyObserver<Result<[StreamPrice],StreamError>>
        init() {
            let streamSubject = PublishSubject<Result<[StreamPrice],StreamError>>()
            streamObservable = streamSubject.asObservable()
            streamObserver = streamSubject.asObserver()
        }
        
        
    }
    class Mock_ProductListCollectionViewCellViewModel:Pr_ProductListCollectionViewCellViewModel{
        func returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag> {
            return Observable<CellImageTag>.create { ob in
                ob.onCompleted()
                return Disposables.create()
            }
        }
        
        
    }
    let mock_usecase = Mock_ProductListWithImageHeightUsecase()
    override func setUpWithError() throws {
        viewModel = ProductListCollectionViewModel(UseCase: mock_usecase, CellViewModel: Mock_ProductListCollectionViewCellViewModel(),FooterViewModel: ProductListCollectionFooterViewModel())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func test_requestHttpProductList(){
//        let promise = expectation(description: "wait")
//        viewModel.productsList.subscribe(onNext: {
//            result in
//            print(result)
//            if result[0].products.count != 0,result[0].products[0].product_price != 1000{
//                promise.fulfill()
//                XCTAssertEqual(result[0].products[0].product_price, 1500)
//            }
//        })
//        viewModel.requestProductsList.onNext(())
//        DispatchQueue.global().async {
//            sleep(2)
//            self.mock_usecase.sendStreamPrice(price: StreamPrice(product_id: 1, product_price: 1500))
//        }
//        wait(for: [promise], timeout: 5.0)
    }

}
