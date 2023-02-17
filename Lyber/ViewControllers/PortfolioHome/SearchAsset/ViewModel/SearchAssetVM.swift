//
//  SearchAssetVM.swift
//  Lyber
//
//  Created by sonam's Mac on 25/08/22.
//

import Foundation
class SearchAssetVM{
    func getAssetsApi(searchText : String,completion: @escaping ( ([GetAssetsAPIElement]?) -> Void )){
        var param : [String : Any] = [:]
        if searchText != ""{
            param[Constants.ApiKeys.keyword] = searchText
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.assets, withParameters: param, ofType: [GetAssetsAPIElement].self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunction.toster(error)
        }, method: .GetString, img: nil, imageParamater: nil, headerPresent: true)
    }
}
