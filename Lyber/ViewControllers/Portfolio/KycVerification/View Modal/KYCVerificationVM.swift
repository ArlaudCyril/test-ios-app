//
//  KYCVerificationVM.swift
//  Lyber
//
//  Created by sonam's Mac on 04/07/22.
//

import Foundation

class KYCVerificationVM{
    
    func getKYCStatus(completion: @escaping ( (KycStatusModel?) -> Void )){
//        let jsonRequest: [String: Any] = [
//            Constants.ApiKeys.authorization: userData.shared.accessToken ?? ""
//        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.kyc_status, withParameters: [:], ofType: KycStatusModel.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func startVerifyIdentityApi(completion: @escaping ( (KycLivenessModel?) -> Void )){
//        let jsonRequest: [String: Any] = [
//            Constants.ApiKeys.authorization: CoreData.shared.userInfo.accessToken ?? ""
//        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.kyc_liveness, withParameters: [:], ofType: KycLivenessModel.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}
