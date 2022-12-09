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
        let mainProperty = Main(Sub: subProperty)
        let one = CacheTest()
        one.cache?.setObject(NSNumber(integerLiteral: 500), forKey: "key")
        let two = CacheTest()
        two.cache?.setObject(NSNumber(integerLiteral: 5000), forKey: "key")
        print(one.cache?.object(forKey: "key"))
    
    }
    @objc func action(){
    }
    func testFunction(){
        
        let obser = Observable<String>.create { observer in
            observer.onNext("Hello")
            observer.onCompleted()
            return Disposables.create()
        }
        obser.subscribe(onNext: {
            text in
            print(text)
        })
    }
    
    
}

