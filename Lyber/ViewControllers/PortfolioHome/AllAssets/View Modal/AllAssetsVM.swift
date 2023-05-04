//
//  AllAssetsVM.swift
//  Lyber
//
//  Created by sonam's Mac on 19/07/22.
//

import Foundation
class AllAssetsVM{
    var controller : AllAssetsVC?
    func getAllAssetsApi(completion: @escaping ( ([PriceServiceResume]?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceResume, withParameters: [:], ofType: PriceServiceResumeAPI.self, onSuccess: { response in
			print(response)
			var priceServiceResumeDataDict : [String:PriceServiceResumeData] = response.data
			var priceServiceResumeArray : [PriceServiceResume] = []
			for (id, priceServiceResumeData) in priceServiceResumeDataDict.sorted(by: {$0.value.rank < $1.value.rank}){
				let priceServiceResume = PriceServiceResume(id: id, priceServiceResumeData: priceServiceResumeData)
				priceServiceResumeArray.append(priceServiceResume)
			}
		
			completion(priceServiceResumeArray)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func getAllAssetsNewApi(completion: @escaping ( (TrendingCoinsAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.coingeckoCoins, withParameters: [:], ofType: TrendingCoinsAPI.self, onSuccess: { response in

                completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
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
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
}

