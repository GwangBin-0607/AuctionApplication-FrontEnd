//
//  OutputStreamDataTransfer.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/06.
//

import Foundation
struct StreamStateData:Encodable{
    let stateNum:Int
}
struct OutputStreamData:Encodable{
    let dataType:StreamDataType
    let completionId:Int16
    let data:Encodable
    
    private enum CodingKeys: CodingKey {
        case dataType
        case data
        case completionId
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(dataType, forKey: .dataType)
        try container.encode(data, forKey: .data)
        try container.encode(completionId, forKey: .completionId)
    }
}
protocol OutputStreamDataTransferInterface{
    func encodeOutputStreamState(dataType:StreamDataType,completionId:Int16,output:Encodable)throws->Data
}

class OutputStreamDataTransfer:OutputStreamDataTransferInterface{
    private func addSplitter(data:OutputStreamData)throws -> Data{
        let splitter = "/".data(using: .utf8)
        let data = try JSONEncoder().encode(data)+splitter!
        return data
    }
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func encodeOutputStreamState(dataType:StreamDataType,completionId:Int16,output:Encodable)throws->Data{
        let original = OutputStreamData(dataType: dataType, completionId: completionId, data: output)
        return try addSplitter(data: original)
    }
}
