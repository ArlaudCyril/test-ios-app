//
//  AddNewRIBVM.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 14/03/2024.
//

import Foundation

class AddNewRIBVM{
    func addRibApi(iban : String, bic: String, nameRib: String, ownerName: String, bankCountry: String, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.iban : iban,
                                       Constants.ApiKeys.bic : bic,
                                       Constants.ApiKeys.name : nameRib,
                                       Constants.ApiKeys.userName : ownerName,
                                       Constants.ApiKeys.bankCountry : bankCountry]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceRib, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "addRibApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func getRibsApi(completion: @escaping ( (RibAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceRibs, withParameters: [:], ofType: RibAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "getRibsApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func deleteRisApi(ribId: String, completion: @escaping ( (SuccessAPI?) -> Void )){
        
        let param : [String : Any] = [Constants.ApiKeys.ribId : ribId]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceRib, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "deleteRisApi",code: code, error: error)
            completion(nil)
        }, method: .DELETEWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }

}
