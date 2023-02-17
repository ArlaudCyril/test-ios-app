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
            CommonFunction.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunction.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
}
