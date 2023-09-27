//
//  OneTimeInvestmentVM.swift
//  Lyber
//
//  Created by Lyber on 21/07/2023.
//

import Foundation
import AppsFlyerLib

class OneTimeInvestmentVM{
	
	func executeStrategyApi(strategyName : String ,amount : Double, ownerUuid: String, completion: @escaping ( (ExecutionOneInvestmentAPI?) -> Void )){
		let params : [String : Any] = [Constants.ApiKeys.strategy_name : strategyName,
									   Constants.ApiKeys.amount : amount,
									   Constants.ApiKeys.owner_uuid : ownerUuid]
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceStrategyExecution, withParameters: params, ofType: ExecutionOneInvestmentAPI.self, onSuccess: { response in
			completion(response)
            AppsFlyerLib.shared().logEvent(AFEventPurchase, withValues: [
                AFEventParamPrice: amount,
                AFEventParamContentType: "ExecuteStrategy"
            ]);
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
			completion(nil)
		}, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
	}
	
	
	func getStrategyExecutionApi(executionId : String, completion: @escaping ( (OneInvestmentAPI?) -> Void )){
		let params : [String : Any] = [Constants.ApiKeys.executionId : executionId]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceStrategyExecution, withParameters: params, ofType: OneInvestmentAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParamater: nil, headerType: "user")
	}

}
