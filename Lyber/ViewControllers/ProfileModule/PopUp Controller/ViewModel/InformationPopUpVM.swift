//
//  InformationPopUpVM.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 09/10/2024.
//

import Foundation
import UIKit

class InformationPopUpVM{
    func getUserNameByPhoneApi(phone: String, completion: @escaping ( (UserInfoDataAPI?) -> Void )){
        let param = ["phone": phone]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUserByPhone, withParameters: param, ofType: UserInfoDataAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "GetUserNameByPhoneApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}

