//
//  ViewController.swift
//  front-end
//
//  Created by 안광빈 on 2022/09/29.
//

import UIKit
import RxSwift
class Main{
    let sub:Sub
    var name:String?
    let disposeBag = DisposeBag()
    init(Sub:Sub){
        self.sub = Sub
        self.sub.observable?.subscribe(onNext: { [weak self] text in
            self?.name = text
        }).disposed(by: disposeBag)
    }
    deinit {
        print("Main DEINIT")
    }
}
class Sub{
    var observable:Observable<String>?
    init() {
        observable = Observable<String>.create({ observer in
            observer.onNext("Hello")
            return Disposables.create()
        })
    }
    deinit {
        print("Sub DEINIT")
    }
}
struct StructTest{
    var num:Int?
}
class CacheTest{
    var cache:NSCache<NSString,NSNumber>?
}
class ViewController: UIViewController {
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "URLL") as? String else {
            fatalError("ApiKey must noasdasdadasdadasdasdasdasdadt be emptaay in plist")
        }
        self.view.addSubview(btn)
        btn.backgroundColor = .yellow
        btn.frame = CGRect(x: 40, y: 40, width: 120, height: 120)
        btn.addTarget(self, action: #selector(action), for: .touchUpInside)
        testFunction()
        let subProperty = Sub()
        let one = CacheTest()
        one.cache?.setObject(NSNumber(integerLiteral: 500), forKey: "key")
        let two = CacheTest()
        two.cache?.setObject(NSNumber(integerLiteral: 5000), forKey: "key")
        testMapFlatMap()
        let firstStruct = StructTest(num: 500)
        sendStruct(structReceive: firstStruct)
        testNetwork()
    
    }
    func testNetwork(){
//        pro = TestRepository()
//        pro.con.start()
    }
    var structMain:StructTest?
    func sendStruct(structReceive:StructTest){
        structMain = structReceive
        structMain?.num = 100
    }
    let repo = ProductListRepository(ApiService: MockProductsListAPI(), StreamingService: SocketNetwork(hostName: "localhost", portNumber: 3200, ProductListServiceState: ProductListServiceState()))
    let request = PublishSubject<String>()
    lazy var ob = self.request.asObserver()
    let httpService = MockProductsListAPI()
    func testMapFlatMap(){
    }
    func testThird(){
    
        
    }
//    class TestRepository{
//        let con = SocketNWConnection(Host: "localhost", Port: 3200)
//        init() {
//            con.inputDataObservable.subscribe(onNext: {
//                result in
//                switch result{
//                case .success(let data):
//                    let jsonDecode = JSONDecoder()
//                    do{
//                        let de = try jsonDecode.decode([StreamPrice].self, from: data)
//                        print(de)
//                    }catch{
//                        print(error)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            })
//        }
//        func sendData(ProductPrice:StreamPrice){
//            let encode = JSONEncoder()
//            do{
//                let data = try encode.encode(ProductPrice)
//                con.sendData(data: data, completion: {
//                    error in
//                    print(error)
//                })
//            }catch{
//                print(error)
//            }
//        }
//    }
    
    @objc func action(){
        repo.buyProduct(output: StreamPrice(product_id: 150, product_price: 150)).subscribe(onNext: {
            error in
            print(error)
        })

//        t.sendData(ProductPrice: StreamPrice(product_id: 150, product_price: 200))
//        repo.buyProduct(output: StreamPrice(product_id: 1500, product_price: 123123)).subscribe(onNext: {
//            err in
//            print(err)
//        })
//        pro.sendData(ProductPrice: StreamPrice(product_id: 5000, product_price: 5000))
//        repo.requestObserver.onNext(2)
//        let diContainer = SceneDIContainer()
//        var productViewController = diContainer.returnProductsListViewController()
//        productViewController.modalPresentationStyle = .fullScreen
//        self.present(productViewController, animated: true, completion: nil)
    }
    func testFunction(){

//        repo.streamState(state: .connect)
//        let subject = PublishSubject<Void>()
//        let observable = subject.asObservable()
//        let observer = subject.asObserver()
//        let ob = Observable<Int>.create { observer in
//            observer.onError(NSError(domain: "22", code: -1))
//            return Disposables.create()
//        }.catch{_ in .just(1)}
//        let obb = PublishSubject<Int>()
//        obb.flatMap { num in
//            return ob
//        }.subscribe { number in
//            print("Next \(number)")
//        } onError: { err in
//            print("ERROR \(err)")
//        } onCompleted: {
//            print("Complete")
//        } onDisposed: {
//            print("Disposed")
//        }
//        obb.onNext(123)

    }
    
    
}

