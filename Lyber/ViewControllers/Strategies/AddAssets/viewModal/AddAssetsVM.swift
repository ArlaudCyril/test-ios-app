//
//  AddAssetsVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/07/22.
//

import Foundation

class AddAssetsVM{
    var controller : AddAssetsVC?
    func getAllAssetsApi(order : String,completion: @escaping ( (AllAssetsAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.order : order,
                                       Constants.ApiKeys.page : self.controller?.pageNumber ?? 0,
                                       Constants.ApiKeys.limit : 100
        ]
        
        self.controller?.apiHitting = true
        if self.controller?.canPaginate == true {
            self.controller?.pageNumber = controller!.pageNumber + 1
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.priceServiceResume, withParameters: params, ofType: AllAssetsAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunction.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
}
