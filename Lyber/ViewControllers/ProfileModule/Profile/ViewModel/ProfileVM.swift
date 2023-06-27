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
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
	
	func saveProfilePictureApi(imageName: String, completion: @escaping ( (ProfileAPI?) -> Void )){
		let param : [String: Any] = [Constants.ApiKeys.avatar : imageName]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: param, ofType: ProfileAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PATCHWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
