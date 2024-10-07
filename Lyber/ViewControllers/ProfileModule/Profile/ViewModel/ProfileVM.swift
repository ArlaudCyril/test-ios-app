//
//  profileVM.swift
//  Lyber
//
//  Created by sonam's Mac on 27/07/22.
//

import Foundation
class ProfileVM{
    func getProfileDataApi(completion: @escaping ( (ProfileAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: [:], ofType: ProfileAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getProfileDataApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
	
	func saveProfilePictureApi(imageName: String, completion: @escaping ( (ProfileAPI?) -> Void )){
		let param : [String: Any] = [Constants.ApiKeys.avatar : imageName]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: param, ofType: ProfileAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "saveProfilePictureApi",code: code, error: error)
            completion(nil)
        }, method: .PATCHWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
}
