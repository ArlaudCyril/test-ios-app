//
//  ApiConstants.swift
//  Lyber
//
//  Created by sonam's Mac on 29/06/22.
//

import Foundation
// MARK:- API ENVIORMENT
enum ApiEnvironment: String {
//    case Dev = "https://dev.lyber.com/"
    case Dev = "https://staging.lyber.com/"
//            "https://lyber.com:3001/"
    case Stage = "http://104.211.21.101:3001/"
    case Live = "http://104.211.21.101:3002/"
    
    static var ImageUrl = "https://lyberblob.blob.core.windows.net/original/"
    static var socketBaseUrl  = "ws://ws.lyber.com:80/websocket/"
    //static var socketUrl  = "ws://ws.lyber.com:80/websocket/btceur"
}


// MARK: - IMAGE QUALITY
enum Image_Quality : String {
    case medium = "Medium"
    case small = "Small"
    case large = "Orig"
}

// MARK: - API URL'S CLASS
class NetworkURL {
    
    var BASE_URL : String{
        return ApiEnvironment.Dev.rawValue
    }
    
}
