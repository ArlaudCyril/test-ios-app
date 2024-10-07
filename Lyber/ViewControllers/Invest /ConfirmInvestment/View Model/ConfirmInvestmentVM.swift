//
//  ConfirmInvestmentVM.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import Foundation
import AppsFlyerLib

class ConfirmInvestmentVM{
    func activateStrategyApi(strategyName : String ,amount : Double,frequency: String, ownerUuid: String, minAmount: Int, controller: ViewController, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.strategy_name : strategyName,
                                       Constants.ApiKeys.amount : amount,
                                       Constants.ApiKeys.frequency : CommonFunctions.frequenceEncoder(frequence: frequency),
                                       Constants.ApiKeys.owner_uuid : ownerUuid]
        let arguments = ["minAmount": minAmount.description]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceActiveStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            AppsFlyerLib.shared().logEvent(AFEventPurchase, withValues: [
                AFEventParamPrice: amount,
                AFEventParamContentType: "ActivateStrategy"
            ]);
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "activateStrategyApi",code: code, error: error, controller: controller, arguments: arguments)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func editActiveStrategyApi(strategyName : String ,amount : Double,frequency: String, ownerUuid: String, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.strategy_name : strategyName,
                                       Constants.ApiKeys.amount : amount,
                                       Constants.ApiKeys.frequency : frequency,
                                       Constants.ApiKeys.owner_uuid : ownerUuid]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceActiveStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "editActiveStrategyApi",code: code, error: error)
            completion(nil)
        }, method: .PATCHWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func ordersAcceptQuoteAPI(orderId : String, controller: ViewController, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.orderId : orderId]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.orderServiceAcceptQuote, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            AppsFlyerLib.shared().logEvent(AFEventPurchase, withValues: [
                AFEventParamContentId: orderId,
                AFEventParamContentType: "Order"
            ]);
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "ordersAcceptQuoteAPI",code: code, error: error, controller: controller)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func SellApi(assetId: String,amount : Decimal,assetAmount : Decimal,completion: @escaping ( (SuccessAPI?) -> Void )){
        var params : [String : Any] = [:]
        params[Constants.ApiKeys.asset_id] = assetId
        params[Constants.ApiKeys.amount] = "\(amount)"
        params[Constants.ApiKeys.asset_amount] = assetAmount
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSellCrypto, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "SellApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
	func userGetOtpApi(action: String, data : [String : Any] = [:], completion: @escaping ( (SuccessAPI?) -> Void )){
        var params : [String : Any] = [:]
		
		if(!data.isEmpty){
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
				let base64EncodedString = jsonData.base64EncodedString()
				params[Constants.ApiKeys.details] = base64EncodedString
				
			} catch {
				print("Error creating JSON: \(error)")
			}
		}
		
        params[Constants.ApiKeys.action] = action
        
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceTwoFaOtp, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "userGetOtpApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}

