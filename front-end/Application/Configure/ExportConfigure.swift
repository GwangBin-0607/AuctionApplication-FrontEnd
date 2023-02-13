//
//  ExportConfigure.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//
import Foundation
class ExportConfigure{
    let bundle:Bundle
    init() {
        bundle = Bundle(for: SceneDelegate.self)
    }
    func getProductListURL()->URL{
        guard let infoListURL = bundle.object(forInfoDictionaryKey: "HTTP_LIST_URL") as? String,let url = URL(string: infoListURL)  else{
            fatalError("No URL Info.plist")
        }
        return url
    }
    func getProductImageURL()->URL{
        guard let infoImageURL = bundle.object(forInfoDictionaryKey: "HTTP_IMAGE_URL") as? String,let url = URL(string: infoImageURL)  else{
            fatalError("No URL Info.plist")
        }
        return url
    }
    func getSocketHost()->String{
        guard let infoSocketHost = bundle.object(forInfoDictionaryKey: "SOCKET_HOST") as? String else{
            fatalError("No Socket Host Info.plist")
        }
        return infoSocketHost
    }
    func getSocketPort()->Int{
        guard let infoSocketPort = bundle.object(forInfoDictionaryKey: "SOCKET_PORT") as? String,let returnPort = Int(infoSocketPort) else{
            fatalError("No Socket Port Info.plist")
        }
        return returnPort
    }
}
