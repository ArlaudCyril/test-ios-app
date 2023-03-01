//
//  AllAssetsVM.swift
//  Lyber
//
//  Created by sonam's Mac on 19/07/22.
//

import Foundation
class AllAssetsVM{
    var controller : AllAssetsVC?
    func getAllAssetsApi(keyword : String,completion: @escaping ( (priceServiceResumeAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceResume, withParameters: [:], ofType: priceServiceResumeAPI.self, onSuccess: { response in
                completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getAllAssetsNewApi(completion: @escaping ( (TrendingCoinsAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.coingeckoCoins, withParameters: [:], ofType: TrendingCoinsAPI.self, onSuccess: { response in

                completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getAllAssetsDetailApi(completion: @escaping ( ([AssetBaseData]?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.assetServiceAssets, withParameters: [:], ofType: AssetBaseAPI.self, onSuccess: { response in
            print(response)
            coinDetailData = response.data ?? []
            self.controller?.filteredData = response.data ?? []
            completion(response.data)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
}

