//
//  PortfolioDetailVM.swift
//  Lyber
//
//  Created by sonam's Mac on 25/07/22.
//

import Foundation
class PortfolioDetailVM{
//    var controller : AllAssetsVC?
    func getCoinInfoApi(AssetId : String, isNetwork : Bool = false, controller: ViewController = ViewController(), completion: @escaping ( (AssetDetailApi?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.id : AssetId,
									   Constants.ApiKeys.include_networks : isNetwork]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.assetServiceAsset, withParameters: params, ofType: AssetDetailApi.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "getCoinInfoApi",code: code, error: error, controller: controller, arguments: ["asset": AssetId])
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func getChartDataApi(AssetId : String,timeFrame: String,completion: @escaping ( (ChartAPI?) -> Void )){
        
        let url = "\(Constants.ApiUrlKeys.priceServicePrice)?id=\(AssetId)&tf=\(timeFrame)"
        ApiHandler.callApiWithParameters(url: url, withParameters: [:], ofType: ChartAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getChartDataApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func getAssetsNewsApi(id : String,completion: @escaping ( (NewsDataAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.id : id]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.newsService, withParameters: params, ofType: NewsDataAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getAssetsNewsApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
	
	func OrderGetOrderApi(orderId : String,completion: @escaping ( (OrderAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.orderId : orderId]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.orderServiceOrder, withParameters: params, ofType: OrderAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "OrderGetOrderApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
	
	func getResumeByIdApi(assetId : String,completion: @escaping ( (PriceServiceResumeDataAPI?) -> Void )){
    
        let params : [String : Any] = [Constants.ApiKeys.id : assetId]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceResume, withParameters: params, ofType: PriceServiceResumeDataAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getResumeByIdApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}
