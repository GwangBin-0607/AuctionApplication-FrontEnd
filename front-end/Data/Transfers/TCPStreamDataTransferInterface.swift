//
//  SocketAdd.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/09.
//

import Foundation
import RxSwift
protocol TCPStreamDataTransferInterface{
    func decode(result:Result<Data,Error>)->Result<[StreamPrice],Error>
    func encodeOutputStreamState(dataType:StreamDataType,output:Encodable)throws -> Data
    func register(completion:@escaping(Result<ResultData,Error>)->Void,timeOut:Int)
}

