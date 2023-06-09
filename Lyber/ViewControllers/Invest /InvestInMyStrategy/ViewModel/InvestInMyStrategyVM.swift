//
//  InvestInMyStrategyVM.swift
//  Lyber
//
//  Created by Lyber on 26/04/2023.
//

import Foundation
class InvestInMyStrategyVM{
	func ordersGetQuoteApi(fromAssetId : String ,toAssetId : String,exchangeFromAmount : Double,completion: @escaping ( (QuoteAPI?) -> Void )){
		let params : [String : Any] = [Constants.ApiKeys.fromAsset : fromAssetId,
									   Constants.ApiKeys.toAsset : toAssetId,
									   Constants.ApiKeys.fromAmount : String(exchangeFromAmount)]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.orderServiceQuote, withParameters: params, ofType: QuoteAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			completion(nil)
			CommonFunctions.toster(error)
		}, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
	}
}

