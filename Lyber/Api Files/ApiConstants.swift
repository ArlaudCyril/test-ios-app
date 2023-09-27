//
//  ApiConstants.swift
//  Lyber
//
//  Created by sonam's Mac on 29/06/22.
//

import Foundation
// MARK:- API ENVIORMENT
enum ApiEnvironment: String {
    case Dev = "https://dev.lyber.com/"
    case Staging = "https://staging.lyber.com/"
    case Production = "https://production.lyber.com/"
//    case Stage = "http://104.211.21.101:3001/"
//    case Live = "http://104.211.21.101:3002/"
    
    static var ImageUrl = "https://lyberblob.blob.core.windows.net/original/"
    static var socketBaseUrl  = "wss://ws.lyber.com:80/websocket/"
    //static var socketUrl  = "ws://ws.lyber.com:80/websocket/btceur"
}


// MARK: - IMAGE QUALITY
enum Image_Quality : String {
    case medium = "Medium"
    case small = "Small"
    case large = "Orig"
}
