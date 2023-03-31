//
//  PortfolioDetailVM.swift
//  Lyber
//
//  Created by sonam's Mac on 25/07/22.
//

import Foundation
class PortfolioDetailVM{
//    var controller : AllAssetsVC?
    func getCoinInfoApi(Asset : String,completion: @escaping ( (AssetDetailApi?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.id : Asset]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.assetServiceAsset, withParameters: params, ofType: AssetDetailApi.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func getChartDataApi(AssetId : String,timeFrame: String,completion: @escaping ( (ChartAPI?) -> Void )){
        
        let url = "\(Constants.ApiUrlKeys.priceServicePrice)?id=\(AssetId)&tf=\(timeFrame)"
        ApiHandler.callApiWithParameters(url: url, withParameters: [:], ofType: ChartAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func getAssetsNewsApi(id : String,completion: @escaping ( (NewsDataAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.id : id]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.newsService, withParameters: params, ofType: NewsDataAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GetString, img: nil, imageParamater: nil, headerType: "user")
    }
}
