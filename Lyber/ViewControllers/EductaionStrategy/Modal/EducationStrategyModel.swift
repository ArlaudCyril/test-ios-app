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

struct DataAPI: Codable {
    let data: String
}

struct UserInfoDataAPI: Codable {
    let data: UserInfoAPI
}

struct UserInfoAPI: Codable {
    let firstName: String
    let lastName: String
    let phoneNo: String
}

struct FailureAPI {
	let message: String?
	let code: String?
	
	init(message:String, code: String) {
		self.message = message
		self.code = code
	}
}
struct dataStruct : Codable{
    let access_token,refresh_token : String?
}

// MARK: - OTPAPI
struct SocketData: Codable {
    let Symbol,Price: String?
}
