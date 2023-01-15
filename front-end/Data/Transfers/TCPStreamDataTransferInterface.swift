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
    func encodeOutputStreamState(dataType:StreamDataType,output:Encodable)throws  -> (Int16,Data)
    func register(completion:@escaping(Result<ResultData,Error>)->Void)
    func executeIfSendError(completionId:Int16,error:Error)
}

