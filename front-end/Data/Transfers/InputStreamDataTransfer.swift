//
//  InputStreamData.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/06.
//

import Foundation

enum InputStreamDataType:Codable{
    case RequestResponse
    case StreamProductPrice
    private enum CodingKeys: CodingKey {
        case StreamStateUpdate
        case StreamProductPriceUpdate
    }
    init(from decoder: Decoder) throws {
         let label = try decoder.singleValueContainer().decode(Int8.self)
         switch label {
         case 1: self = .RequestResponse
         case 2: self = .StreamProductPrice
         default:
             throw StreamError.InputStreamDataTypeDecodeError
         }
      }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self{
        case .RequestResponse:
            try container.encode(1)
        case .StreamProductPrice:
            try container.encode(2)
        }
    }
}
struct InputStreamData:Decodable{
    let dataType:InputStreamDataType
    let data:Decodable
    
    private enum CodingKeys: CodingKey {
        case dataType
        case data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(InputStreamDataType.self, forKey: .dataType)
        switch value {
        case .StreamProductPrice:
            do{
                let valueTwo = try container.decode(StreamPrice.self, forKey: .data)
                self.data = valueTwo
            }catch{
                throw StreamError.ProductPriceDecodeError
            }
        case .RequestResponse:
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
