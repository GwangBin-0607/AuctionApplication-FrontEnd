//
//  InputStreamData.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/06.
//

import Foundation

enum InputStreamDataDecodeError:Error{
    case InputStreamDataTypeDecodeError
    case ResultOutputStreamReadedDecodeError
    case ProductPriceDecodeError
}
enum StreamDataType:Codable{
    case InputStreamProductPrice
    case OutputStreamReaded
    private enum CodingKeys: CodingKey {
        case InputStreamProductPrice
        case OutputStreamReaded
    }
    init(from decoder: Decoder) throws {
         let label = try decoder.singleValueContainer().decode(String.self)
         switch label {
         case "InputStreamProductPrice": self = .InputStreamProductPrice
         case "OutputStreamReaded": self = .OutputStreamReaded
         default:
             throw InputStreamDataDecodeError.InputStreamDataTypeDecodeError
            // default: self = .other(label)
         }
      }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self{
        case .OutputStreamReaded:
            try container.encode("OutputStreamReaded")
        case .InputStreamProductPrice:
            try container.encode("InputStreamProductPrice")
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
        case .InputStreamProductPrice:
            do{
                let valueTwo = try container.decode([StreamPrice].self, forKey: .data)
                self.data = valueTwo
            }catch{
                throw InputStreamDataDecodeError.ProductPriceDecodeError
            }
        case .OutputStreamReaded:
            do{
                let valueTwo = try container.decode(ResultOutputStreamReaded.self, forKey: .data)
                self.data = valueTwo
            }catch{
                throw InputStreamDataDecodeError.ResultOutputStreamReadedDecodeError
            }
        }
        self.dataType = value
      }
}
struct ResultOutputStreamReaded:Decodable{
    let result:Bool
    let completionId:Int16
}
protocol InputStreamDataTransferInterface{
    func decode(completioHandler:ExecuteOutputStreamCompletionHandlerInterface,data:Data)->Result<[StreamPrice],Error>
}

class InputStreamDataTransfer:InputStreamDataTransferInterface{
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    private func decodeInputStreamDataType(data:Data) throws -> [InputStreamData]{
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
    func decode(completioHandler:ExecuteOutputStreamCompletionHandlerInterface,data:Data)->Result<[StreamPrice],Error>{
        var returnArray:[StreamPrice]=[]
        do {
            let inputData = try decodeInputStreamDataType(data: data)
            inputData.forEach {
                inputStreamData in
                switch inputStreamData.dataType{
                case .InputStreamProductPrice:
                    if let inputStream = inputStreamData.data as? StreamPrice{
                        returnArray.append(inputStream)
                    }
                case .OutputStreamReaded:
                    if let resultData = inputStreamData.data as? ResultOutputStreamReaded{
                        completioHandler.executeCompletionExtension(completionId: resultData.completionId,data: resultData.result)
                    }
                }
            }
            if returnArray.count == 0{
                let error = NSError(domain: "No StreamPrice Data", code: -1)
                return .failure(error)
            }else{
                return .success(returnArray)
            }
        }catch{
            return .failure(error)
        }
    }
}
