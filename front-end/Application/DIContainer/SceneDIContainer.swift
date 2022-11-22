//
//  SceneDIContainer.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/19.
//

import Foundation
// MARK: Case 1
protocol SceneDIContainerProtocol{
    func register<Service>(type:Service.Type,component:Any)
    func resolve<Service>(type:Service.Type)->Service?
}
final class SceneDIContainer:SceneDIContainerProtocol{
    static let shared = SceneDIContainer()
    private init() {}
    var service:[String:Any]=[:]
    
    func register<Service>(type: Service.Type, component: Any) {
        service["\(type)"] = component
    }
    func resolve<Service>(type: Service.Type) -> Service? {
        service["\(type)"] as? Service
    }
}
@propertyWrapper
class Dependency<T>{
    let wrappedValue:T?//필수
    init(){
        self.wrappedValue = SceneDIContainer.shared.resolve(type: T.self)
    }
}
class Food{
    
}
class Main{
    @Dependency var foods:Food? //Property wrapper can only be applied to a 'var'
    func test(){
        //precondition ->
        //assert ->
        assert(false)
    }
}
/*
 받는 개체 클라이언트
 전달된(주입된) 개체를 서비스
 
 */
