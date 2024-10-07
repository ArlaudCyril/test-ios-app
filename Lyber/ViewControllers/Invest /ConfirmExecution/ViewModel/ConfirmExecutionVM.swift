//
//  ConfirmExecutionVM.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 18/01/2024.
//

import Foundation
class ConfirmExecutionVM{
    
    func cancelQuoteApi(userUuid : String ,orderId : String, paymentIntentId: String, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.user_uuid : userUuid,
                                       Constants.ApiKeys.orderId : orderId,
                                       Constants.ApiKeys.payment_intent_id : paymentIntentId]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.orderServiceCancelQuote, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "cancelQuoteApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
}
