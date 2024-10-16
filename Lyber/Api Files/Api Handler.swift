import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import DeviceCheck
import CryptoKit

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

// MARK: - Api Method Type
enum ApiMethod {
    case GET
    case POST
    case PostWithImage
    case PostWithJSON
    case PUT
    case PUTWithImage
    case DELETE
    case DELETEWithJSON
    case PUTWithJSON
    case PATCHWithJSON
}

class ApiHandler: NSObject {
    
    // Récupère l'identifiant de la clé
    static func getKeyId() {
        let service = DCAppAttestService.shared
        if service.isSupported {
            service.generateKey { keyId, error in
                guard error == nil, let keyId = keyId else {
                    print("ERROR - key generation")
                    return
                }
                userData.shared.keyId = keyId
                userData.shared.dataSave()
            }
        }
    }
    
    // Génère les en-têtes d'intégrité
    static func integritiseRequest(params: [String: Any], completion: @escaping (HTTPHeaders) -> Void) {
        let service = DCAppAttestService.shared
        var header: HTTPHeaders = []
        
        guard let paramsData = try? JSONSerialization.data(withJSONObject: params, options: .sortedKeys) else {
            print("ERROR - Impossible de sérialiser les paramètres en JSON")
            completion(header)
            return
        }
        
        let hash = SHA256.hash(data: paramsData)
        let hashBase64 = Data(hash).base64EncodedString()
        
        ApiVM().getIntegrityAPI(requestHash: hashBase64, keyId: userData.shared.keyId) { response in
            if let challengeString = response?.data, let challengeData = Data(base64Encoded: challengeString) {
                
                var combinedData = Data()
                combinedData.append(paramsData)
                combinedData.append(challengeData)
                
                let hash = Data(SHA256.hash(data: combinedData))
                
                service.attestKey(userData.shared.keyId, clientDataHash: hash) { attestation, error in
                    guard error == nil, let attestation = attestation else {
                        print("ERROR - generation attestation error")
                        completion(header)
                        return
                    }
                    
                    let attestationString = attestation.base64EncodedString()
                    header.add(name: "x-ios-integrity", value: attestationString)
                    completion(header)
                }
            } else {
                print("ERROR - Impossible to decode Base64 chain or null data")
                completion(header)
            }
        }
    }
    
    // Appel API avec intégrité facultative
    static func callApiWithParameters<T: Codable>(url: String, withParameters parameters: [String: Any], ofType: T.Type, onSuccess: @escaping (T) -> (), onFailure: @escaping (Bool, String, String) -> (), method: ApiMethod, img: [UIImage]?, imageParameter: [String]?, headerType: String, integrity: Bool = false) {
        
        var header: HTTPHeaders = []
        var params = parameters
        let dispatchGroup = DispatchGroup()
        
//        if integrity {
//            dispatchGroup.enter() // Commence une tâche
//            integritiseRequest(params: params) { responseHeader in
//                header = responseHeader
//                dispatchGroup.leave() // Tâche terminée
//            }
//        }
        
        dispatchGroup.notify(queue: .main) {
            // Ajout des en-têtes de base
            header.add(name: "x-api-version", value: Constants.apiVersion)
            switch headerType {
            case "user":
                header.add(name: "Authorization", value: "Bearer \(userData.shared.userToken)")
            case "registration":
                header.add(name: "Authorization", value: "Bearer \(userData.shared.registrationToken)")
            case "signature":
                header.add(name: "X-Signature", value: params[Constants.ApiKeys.signature] as! String)
                header.add(name: "X-Timestamp", value: params[Constants.ApiKeys.timestamp] as! String)
                params.removeValue(forKey: Constants.ApiKeys.signature)
                params.removeValue(forKey: Constants.ApiKeys.timestamp)
            case "none":
                break
            default:
                header.add(name: "Authorization", value: "Bearer \(headerType)")
            }
            
            // Impression des données demandées pour le debug
            print("Requested data :-\n URL: \(GlobalVariables.baseUrl)\(url)\n HttpMethod: \(method)\n Header: \(header)\n Requested Params: \(params)")
            
            // Vérification de la connexion internet
            if !Connectivity.isConnectedToInternet {
                onFailure(false, "Internet not found", "0")
                return
            }
            
            // Sélection de la méthode HTTP
            var kMethod: HTTPMethod?
            var fullUrl = "\(GlobalVariables.baseUrl)\(url)"
            
            switch method {
           case .GET:
               kMethod = .get
                
               var i = 0
               for (key, value) in params {
                   fullUrl += (i == 0) ? "?\(key)=\(value)" : "&\(key)=\(value)"
                   i += 1
               }
               params = [:]
           case .POST:
               kMethod = .post
           case .PUT:
               kMethod = .put
           case .DELETE:
               kMethod = .delete
           case .PostWithJSON, .PUTWithJSON, .DELETEWithJSON, .PATCHWithJSON:
               let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted, .sortedKeys])
               
               var request = URLRequest(url: URL(string: fullUrl)!)
               request.httpBody = jsonData
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
               request.headers = header
               
               switch method {
               case .PostWithJSON:
                   request.httpMethod = "POST"
               case .PUTWithJSON:
                   request.httpMethod = "PUT"
               case .DELETEWithJSON:
                   request.httpMethod = "DELETE"
               case .PATCHWithJSON:
                   request.httpMethod = "PATCH"
               default:
                   break
               }
               
               AF.request(request).responseDecodable(of: T.self) { response in
                   handleResponseDecodable(response: response, onSuccess: onSuccess, onFailure: onFailure)
               }
               return
           default:
               break
           }
           
           AF.request(fullUrl, method: kMethod ?? .get, parameters: params, encoding: URLEncoding.default, headers: header).responseDecodable(of: T.self) { response in
               handleResponseDecodable(response: response, onSuccess: onSuccess, onFailure: onFailure)
           }
       }
   }
   
   // Gestion de la réponse avec responseDecodable
   static func handleResponseDecodable<T: Codable>(response: AFDataResponse<T>, onSuccess: @escaping (T) -> (), onFailure: @escaping (Bool, String, String) -> ()) {
       let statusCode = response.response?.statusCode
       let dict = JSON(response.data ?? Data())
       switch response.result {
       case .success(let value):
           if (200...299).contains(statusCode ?? 0) {
               onSuccess(value)
           } else {
               let errorDescription = "Unexpected status code: \(dict[Constants.ApiKeys.code].stringValue)"
               onFailure(false,dict[Constants.ApiKeys.error].stringValue, dict[Constants.ApiKeys.code].stringValue)
           }
       case .failure(let error):
           print("Erreur lors de la requête : \(error)")
           if let data = response.data,
                  let jsonString = String(data: data, encoding: .utf8) {
                   print("Erreur de décodage JSON, réponse brute : \(jsonString)")
               }
           onFailure(false,dict[Constants.ApiKeys.error].stringValue, dict[Constants.ApiKeys.code].stringValue)
       }
   }
}
