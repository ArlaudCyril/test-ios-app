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
    
    // Function to handle challenge
    static func attestChallenge(completion: @escaping (String?, Error?) -> Void) {
        ApiVM().getChallengeAPI { response in
            if let challenge = response {
                completion(challenge.data, nil)
            } else {
                completion(nil, NSError(domain: "ChallengeError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get challenge"]))
            }
        }
    }
    
    // Function to handle attestation
    static func attestKey(completion: @escaping (String?, Error?) -> Void) {
        let service = DCAppAttestService.shared
        if service.isSupported {
            attestChallenge { challenge, error in
                if let challenge = challenge {
                    service.generateKey { keyId, error in
                        guard let keyId = keyId, error == nil else {
                            completion(nil, NSError(domain: "AttestationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate key"]))
                            return
                        }
                        let clientDataHash = Data(SHA256.hash(data: challenge.data(using: .utf8)!))
                        service.attestKey(keyId, clientDataHash: clientDataHash) { attestation, error in
                            guard let attestation = attestation, error == nil else {
                                completion(nil, NSError(domain: "AttestationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to attest key"]))
                                return
                            }
                            ApiVM().sendAttestationAPI(keyId: keyId, challenge: challenge, attestation: attestation.base64EncodedString()) { response in
                                if response != nil {
                                    completion(keyId, nil)
                                } else {
                                    completion(nil, NSError(domain: "sendAttestationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to send attestation"]))
                                }
                            }
                        }
                    }
                } else {
                    completion(nil, error)
                }
            }
        } else {
            print("ERROR - Service not supported")
            completion(nil, NSError(domain: "ServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Service not supported"]))
        }
    }
    
    // Function to create an assertion
    static func createIntegrity(_ payload: Data, completion: @escaping (String?) -> Void) {
        let keyId = userData.shared.keyId

        if keyId == "" {
            attestKey { newKeyId, error in
                if let newKeyId = newKeyId {
                    userData.shared.keyId = newKeyId
                    userData.shared.dataSave()
                    generateAssertionForKey(newKeyId, payload: payload, completion: {assertion in
                        do{
                            let integrity = try JSONEncoder().encode([
                                "keyId": newKeyId,
                                "assertion": assertion,
                            ]).base64EncodedString()
                            completion(integrity)
                        }catch{
                            completion(nil)
                        }
                    })
                } else {
                    completion(nil)
                }
            }
        } else {
            generateAssertionForKey(keyId, payload: payload, completion: {assertion in
                do{
                    let integrity = try JSONEncoder().encode([
                        "keyId": keyId,
                        "assertion": assertion,
                    ]).base64EncodedString()
                    completion(integrity)
                }catch{
                    completion(nil)
                }
            })
        }
    }
    
    private static func generateAssertionForKey(_ keyId: String, payload: Data, completion: @escaping (String?) -> Void) {
        let jsonString = String(data: payload, encoding: .utf8) ?? ""
        
        // Manually replace any extra spaces or newlines to ensure compact formatting
        let compactJsonString = jsonString.replacingOccurrences(of: " ", with: "")
                                           .replacingOccurrences(of: "\n", with: "")
                                           .replacingOccurrences(of: "\\", with: "")
        print(compactJsonString)
        // Create SHA256 hash
        let hash = Data(SHA256.hash(data: compactJsonString.data(using: .utf8) ?? Data()))

        let service = DCAppAttestService.shared
        service.generateAssertion(keyId, clientDataHash: hash) { assertion, error in
            if let assertion = assertion {
                completion(assertion.base64EncodedString())
            } else {
                completion(nil)
            }
        }
    }

    // Function to generate integrity headers
    static func integritiseRequest(params: [String: Any], completion: @escaping (HTTPHeaders?, Error?) -> Void) {
        var paramsChanged = params
        attestChallenge { challenge, error in
            if let challenge = challenge {
                paramsChanged["challenge"] = challenge

                do{
                    let sortedKeys = paramsChanged.keys.sorted()

                    // Construct JSON string with sorted keys and formatted values
                    var jsonString = "{"
                    for (index, key) in sortedKeys.enumerated() {
                       if let value = paramsChanged[key] {
                           let valueString: String
                           
                           // Format Double to keep or drop decimal based on value
                           if let doubleValue = value as? Double {
                               valueString = doubleValue == floor(doubleValue) ?
                                   "\"\(Int(doubleValue))\"" :  // For whole numbers like 10
                                   "\"\(doubleValue)\""        // For decimals like 12.5
                           } else {
                               valueString = "\"\(value)\""  // Wrap other types in quotes
                           }

                           jsonString += "\"\(key)\":\(valueString)"
                           if index < sortedKeys.count - 1 {
                               jsonString += ","
                           }
                       }
                    }
                    jsonString += "}"

                    // Convert to Data
                    let payload = jsonString.data(using: .utf8)!
                    print(jsonString)
                    createIntegrity(payload) { integrity in
                        if let integrity = integrity {
                            var header: HTTPHeaders = []
                            header.add(name: "x-ios-integrity", value: integrity)
                            header.add(name: "x-ios-challenge", value: challenge)
                            completion(header, nil)
                        } else {
                            completion(nil, error)
                        }
                    }
                } catch {
                    print("ERROR - Impossible de sérialiser les paramètres en JSON")
                    completion(nil, NSError(domain: "SerializationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize parameters"]))
                    return
                }
            } else {
                completion(nil, error)
            }
        }
    }
    struct RequestPayload: Codable {
        let language: String
        let challenge: String
    }
    
    // API Call with optional integrity
    static func callApiWithParameters<T: Codable>(url: String, withParameters parameters: [String: Any], ofType: T.Type, onSuccess: @escaping (T) -> (), onFailure: @escaping (Bool, String, String) -> (), method: ApiMethod, img: [UIImage]?, imageParameter: [String]?, headerType: String, integrity: Bool = false) {
            
        var header: HTTPHeaders = []
        var params = parameters
        let dispatchGroup = DispatchGroup()
        
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
        
        if integrity {
            dispatchGroup.enter()
            integritiseRequest(params: params) { responseHeader, error in
                if let responseHeader = responseHeader {
                    for integrityHeader in responseHeader{
                        header.add(integrityHeader)
                    }
                    dispatchGroup.leave()
                } else {
                    onFailure(false, "Integrity request failed", "0")
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Requested data :-\n URL: \(GlobalVariables.baseUrl)\(url)\n HttpMethod: \(method)\n Header: \(header)\n Requested Params: \(params)")
            
            if !Connectivity.isConnectedToInternet {
                onFailure(false, "Internet not found", "0")
                return
            }
            
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
