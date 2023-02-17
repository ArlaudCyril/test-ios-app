//
//  EducationStrategyModel.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import Foundation
import UIKit

struct educationModel{
    var image : UIImage
    var desc : String
    var subDesc : String
}
// MARK: - OTPAPI
struct SuccessAPI: Codable {
    let message,msg: String?
    let data : dataStruct?
}
struct dataStruct : Codable{
    let access_token,refresh_token : String?
}

// MARK: - OTPAPI
struct SocketData: Codable {
    let Symbol,Price: String?
}
