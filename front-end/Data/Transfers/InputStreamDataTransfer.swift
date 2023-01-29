//
//  InputStreamData.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/06.
//

import Foundation

enum StreamDataType:Codable{
    case StreamStateUpdate
    case StreamProductPriceUpdate
    private enum CodingKeys: CodingKey {
        case StreamStateUpdate
        case StreamProductPriceUpdate
    }
    init(from decoder: Decoder) throws {
         let label = try decoder.singleValueContainer().decode(Int8.self)
         switch label {
         case 1: self = .StreamStateUpdate
         case 2: self = .StreamProductPriceUpdate
         default:
             throw StreamError.InputStreamDataTypeDecodeError
            // default: self = .other(label)
         }
      }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self{
        case .StreamStateUpdate:
            try container.encode(1)
        case .StreamProductPriceUpdate:
            try container.encode(2)
        }
    }
}
struct InputStreamData:Decodable{
    let dataType:StreamDataType
    let data:Decodable
    
    private enum CodingKeys: CodingKey {
        case dataType
        case data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(StreamDataType.self, forKey: .dataType)
        switch value {
        case .StreamProductPriceUpdate:
            do{
                let valueTwo = try container.decode(StreamPrice.self, forKey: .data)
                self.data = valueTwo
            }catch{
                throw StreamError.ProductPriceDecodeError
            }
        case .StreamStateUpdate:
            do{
                let valueTwo = try container.decode(ResponseStreamOutput.self, forKey: .data)
                self.data = valueTwo
            }catch{
                throw StreamError.ResponseStreamOutputDecodeError
            }
        }
        self.dataType = value
      }
}
struct ResponseStreamOutput:Decodable{
    let result:Bool
    let completionId:Int16
}
protocol InputStreamDataTransferInterface{
    func decodeInputStreamDataType(data:Data)throws-> [InputStreamData]
}

class InputStreamDataTransfer:InputStreamDataTransferInterface{
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func decodeInputStreamDataType(data:Data) throws -> [InputStreamData]{
        let test = String(data: data, encoding: .utf8)
        let splitString = test?.split(separator: "/")
        var resultInputStreamData:[InputStreamData]=[]
        try splitString?.forEach({ sub in
            if let eachData = sub.data(using: .utf8){
                let response = try JSONDecoder().decode(InputStreamData.self, from: eachData)
                resultInputStreamData.append(response)
            }
        })
        
        return resultInputStreamData
    }
}
