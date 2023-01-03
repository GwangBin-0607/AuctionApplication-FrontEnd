//
//  SocketNetworkUtils.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/03.
//

import Foundation

enum isConnecting {
    case connect
    case disconnect
}
enum SocketOutputError:Error{
    case OutputError
}
enum SocketStateError:Error{
    case Encounter
}
struct SocketState {
    let socketConnect:isConnecting
    let error:Error?
}
