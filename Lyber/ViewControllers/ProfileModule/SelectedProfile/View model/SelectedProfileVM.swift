//
//  SelectedProfileVM.swift
//  Lyber
//
//  Created by sonam's Mac on 17/08/22.
//

import Foundation
import UIKit

class SelectedProfileVM{
    func uploadImgApi(ProfilePic : UIImage,completion: @escaping ( (ImageUploadApi?) -> Void )){
       
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.upload, withParameters: [:], ofType: ImageUploadApi.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithImage, img: [ProfilePic], imageParamater: ["file"], headerType: "user")
    }
    
    func updateProfileImgApi(ProfilePic : String, ProfileType : profilePicType?,completion: @escaping ( (profileUpdateApi?) -> Void )){
       
        let params : [String: Any] = [Constants.ApiKeys.profile_pic : ProfilePic,
                                      Constants.ApiKeys.profile_pic_type : ProfileType?.rawValue ?? ""]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.user, withParameters: params, ofType: profileUpdateApi.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PUTWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
