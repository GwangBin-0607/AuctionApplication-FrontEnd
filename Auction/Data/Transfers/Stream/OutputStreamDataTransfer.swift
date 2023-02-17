//
//  OutputStreamDataTransfer.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/06.
//

import Foundation
enum OutputStreamDataType:Codable{
    case SocketStatusUpdate
    case StreamProductPriceUpdate
    private enum CodingKeys: CodingKey {
        case SocketStatusUpdate
        case StreamProductPriceUpdate
    }
    init(from decoder: Decoder) throws {
         let label = try decoder.singleValueContainer().decode(Int8.self)
         switch label {
         case 1: self = .SocketStatusUpdate
         case 2: self = .StreamProductPriceUpdate
         default:
             throw StreamError.EncodeError
         }
      }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self{
        case .SocketStatusUpdate:
            try container.encode(1)
        case .StreamProductPriceUpdate:
            try container.encode(2)
        }
    }
}
struct UpdateStreamStateData:Encodable{
    let stateNumber:Int8
}
struct UpdateStreamProductPriceData:Encodable{
    let product_id:Int
    let product_price:Int
}
struct OutputStreamData:Encodable{
    let dataType:OutputStreamDataType
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
    func encodeOutputStreamState(dataType:OutputStreamDataType,completionId:Int16,output:Encodable)throws->Data
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
    func encodeOutputStreamState(dataType:OutputStreamDataType,completionId:Int16,output:Encodable)throws->Data{
        let original = OutputStreamData(dataType: dataType, completionId: completionId, data: output)
        return try addSplitter(data: original)
    }
}
