//
//  OutputStreamDataTransfer.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/06.
//

import Foundation
struct OutputStreamData:Encodable{
    let dataType:StreamDataType
    let data:Encodable
    
    private enum CodingKeys: CodingKey {
        case dataType
        case data
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(dataType, forKey: .dataType)
        try container.encode(data, forKey: .data)
    }
}
