//
//  AllAssetsVM.swift
//  Lyber
//
//  Created by sonam's Mac on 19/07/22.
//

import Foundation
class AllAssetsVM{
    var controller : AllAssetsVC?
    func getAllAssetsApi(keyword : String,completion: @escaping ( (AllAssetsAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceResume, withParameters: [:], ofType: AllAssetsAPI.self, onSuccess: { response in
                completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getAllAssetsNewApi(completion: @escaping ( (TrendingCoinsAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.coingeckoCoins, withParameters: [:], ofType: TrendingCoinsAPI.self, onSuccess: { response in
//            print(response)
//            var pr : [Double] = []
//            for dt in response.data ?? []{
//                pr.append(dt.currentPrice ?? 0.0)
//            }
//            for dt in (self.controller?.coinsData ?? []){
//                if !pr.contains(dt.currentPrice ?? 0.0){
//                    completion(response)
//                    return
//                }else{
//                    completion(nil)
//                    return
//                }
//            }
//            if let dt = self.controller?.coinsData{
//                print("Here")
                completion(response)
//            }
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getAllAssetsDetailApi(completion: @escaping ( ([AssetDetailData]?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.assetServiceAssets, withParameters: [:], ofType: AssetDetailAPI.self, onSuccess: { response in
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
