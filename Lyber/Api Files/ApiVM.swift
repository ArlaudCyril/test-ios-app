//
//  ApiVM.swift
//  Lyber
//
//  Created by Elie Boyrivent on 03/10/2024.
//

import Foundation

class ApiVM{
    func getChallengeAPI(completion: @escaping (DataAPI?) -> Void) {
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceIntegrity, withParameters: [:], ofType: DataAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "getIntegrityAPI", code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "none")
    }
    
    func sendAttestationAPI(keyId: String, challenge: String, attestation: String, completion: @escaping (SuccessAPI?) -> Void) {
        let params = [Constants.ApiKeys.keyId : keyId,
                      Constants.ApiKeys.challenge: challenge,
                      Constants.ApiKeys.attestation: attestation]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceAttestation, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "sendAttestationAPI", code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "none")
    }
}
