//
//  SocketAdd.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/09.
//

import Foundation
import RxSwift
protocol ProductListRepositorySocketTransferInterface{
    func decode(result:Result<Data,Error>)->Result<[StreamPrice],Error>
    func encode(socketNetwork:SocketNetworkInterface,dataType:StreamDataType,data:Encodable,completion:@escaping (Error?)->Void)->Observable<Error?>
}
extension ProductListRepositorySocketTransferInterface{
    func encode(socketNetwork:SocketNetworkInterface,dataType:StreamDataType = .OutputStreamReaded,data:Encodable,completion:@escaping (Error?)->Void)->Observable<Error?>{
        encode(socketNetwork: socketNetwork, dataType: dataType, data: data, completion: completion)
    }
}
