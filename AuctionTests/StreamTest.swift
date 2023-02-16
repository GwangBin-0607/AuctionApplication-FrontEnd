//
//  StreamTest.swift
//  front-endTests
//
//  Created by 안광빈 on 2023/01/29.
//

import XCTest
@testable import front_end_DEBUG
@testable import RxSwift

final class StreamTest: XCTestCase {

    override func setUpWithError() throws {
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
    func test_StreamProductPriceUpdate(){
        let promise = expectation(description: "Multi Device Stream Test")
        let diContainer = SceneDIContainer()
        let oneDevice = diContainer.returnProductListRepositoryInterface()
        let twoDevice = diContainer.returnProductListRepositoryInterface()
        oneDevice.streamingList.subscribe(onNext: {
            result in
            
        })
        twoDevice.streamingList.subscribe(onNext: {
            result in
            switch result {
            case .success(let updateList):
                promise.fulfill()
                print(updateList)
                XCTAssertEqual(updateList[0].product_price, 7000)
            default:
                break;
            }
        })
        let mockUpdateData = UpdateStreamProductPriceData(product_id: 5, product_price: 7000)
        DispatchQueue.global().async {
            sleep(2)
            oneDevice.updateStreamProductPrice(output: mockUpdateData).subscribe(onNext:{
                result in
                print(result)
            })
        }
        wait(for: [promise], timeout: 5.0)
        
    }

}
