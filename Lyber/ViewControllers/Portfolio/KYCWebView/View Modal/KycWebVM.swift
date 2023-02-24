//
//  KycWebVM.swift
//  Lyber
//
//  Created by sonam's Mac on 07/07/22.
//

import Foundation
class KycWebVM{
    func kycDoneApi(completion: @escaping ( (SuccessAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.status: 1]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userTreezorStatus, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PUT, img: nil, imageParamater: nil, headerPresent: true)
    }
}
