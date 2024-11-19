//
//  InvestInMyStrategyVM.swift
//  Lyber
//
//  Created by Lyber on 26/04/2023.
//

import Foundation
class InvestInMyStrategyVM{
    func ordersGetQuoteApi(fromAssetId : String ,toAssetId : String,exchangeFromAmount : Decimal, controller: ViewController, completion: @escaping ( (QuoteAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.fromAsset : fromAssetId,
                                       Constants.ApiKeys.toAsset : toAssetId,
                                       Constants.ApiKeys.fromAmount : exchangeFromAmount.description]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.orderServiceQuote, withParameters: params, ofType: QuoteAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "ordersGetQuoteApi",code: code, error: error, controller: controller, arguments: ["fromAssetId": fromAssetId.uppercased(), "toAssetId": toAssetId.uppercased()])
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func getLastPriceApi(assetId : String, completion: @escaping ( (LastPriceAPI?) -> Void )){
		let param : [String : Any] = [Constants.ApiKeys.id : assetId]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceLastPrice, withParameters: param, ofType: LastPriceAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "getLastPriceApi",code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParameter: nil, headerType: "user")
	}
}

