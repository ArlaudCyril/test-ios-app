//
//  AddAssetsVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/07/22.
//

import Foundation

class AddAssetsVM{
    var controller : AddAssetsVC?
    func getAllAssetsApi(order : String,completion: @escaping ( ([PriceServiceResume]?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.order : order,
                                       Constants.ApiKeys.page : self.controller?.pageNumber ?? 0,
                                       Constants.ApiKeys.limit : 100
        ]
        
        self.controller?.apiHitting = true
        if self.controller?.canPaginate == true {
            self.controller?.pageNumber = controller!.pageNumber + 1
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceResume, withParameters: params, ofType: PriceServiceResumeAPI.self, onSuccess: { response in
			let priceServiceResumeDataDict : [String:PriceServiceResumeData] = response.data
			var priceServiceResumeArray : [PriceServiceResume] = []
			for (id, priceServiceResumeData) in priceServiceResumeDataDict{
				let priceServiceResume = PriceServiceResume(id: id, priceServiceResumeData: priceServiceResumeData)
				priceServiceResumeArray.append(priceServiceResume)
			}
			
			completion(priceServiceResumeArray)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}
