//
//  EducationStrategyVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/07/22.
//

import Foundation

class EducationStrategyVM{
    func readEductionStrategyApi( completion: @escaping ( (SuccessAPI?) -> Void )){
       
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestEducation, withParameters: [:], ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
//            CommonFunction.toster(response.message ?? "")
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
            completion(nil)
        }, method: .POST, img: nil, imageParamater: nil, headerType: "user")
    }
}
