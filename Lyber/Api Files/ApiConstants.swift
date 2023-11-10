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
    
    static var ImageUrl = "https://lyberblob.blob.core.windows.net/original/"
    static var socketBaseUrl  = "wss://ws.lyber.com/websocket/"
}


// MARK: - IMAGE QUALITY
enum Image_Quality : String {
    case medium = "Medium"
    case small = "Small"
    case large = "Orig"
}
