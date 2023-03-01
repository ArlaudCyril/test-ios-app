//
//  Api Handler.swift
//  Lyber
//
//  Created by sonam's Mac on 29/06/22.
//

import Foundation
import UIKit


import Alamofire
import SwiftyJSON

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

// MARK:- Api Method Type
enum ApiMethod {
    case GET
    case POST
    case PostWithImage
    case PostString
    case GetString
    case PostWithJSON
    case PUT
    case PUTWithImage
    case DELETE
    case DELETEWithJSON
    case PUTWithJSON
    case PATCHWithJSON
}


class ApiHandler: NSObject {

    // MARK:- THIS METHOD RETURN RESPONSE IN CODEABLE
    static func callApiWithParameters<T:Codable>(url: String , withParameters parameters: [String: Any], ofType : T.Type, onSuccess:@escaping (T)->(), onFailure: @escaping (Bool, String)->(), method: ApiMethod, img: [UIImage]? , imageParamater: [String]?, headerPresent: Bool){
        
        var header : HTTPHeaders = [
            
        ]
        
        userData.shared.getData()
        
        // MARK: - HEADER CREATED, YOU CAN ALSO SEND YOUR CUSTOM HEADER
        if headerPresent{
            header = [.authorization("Bearer \(userData.shared.accessToken)")]
        }
        
        // MARK:- PRINT ALL REQUESTED DATA
        print("Requested data :-\n URL: \(NetworkURL().BASE_URL)\(url)\n HttpMethod: \(method)\n Header: \(header)\n Requested Params: \(parameters)\n\n\n\n\n")
        print("\(NetworkURL().BASE_URL)\(url)")
        print(parameters)
        print(header)
        print(method)
        
        // MARK:- CHECK WHETHER INTERNET IS CONNECTED OR NOT
        if !Reachability.isConnectedToNetwork(){
            onFailure(false, "Internet not found")
            return
        }
        
        // MARK:- REQUESTED METHODS
        if method == .GET || method == .POST || method == .PUT || method == .DELETE{
            
            var kMehod: HTTPMethod?
            
            switch method {
            case .GET:
                kMehod = .get
            case .POST:
                kMehod = .post
            case .PUT:
                kMehod = .put
            case .DELETE:
                kMehod = .delete
            default:
                break
            }
            
            AF.sessionConfiguration.timeoutIntervalForRequest = 90              //FOR TIMEOUT SETTINGS
            AF.request("\(NetworkURL().BASE_URL)\(url)", method: kMehod ?? .get, parameters: parameters, encoding: URLEncoding.default, headers: header).response{ response in
//                print(response)
                
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let jsondata = try JSON(data: data)
                                print(jsondata)
                                let json = try JSONDecoder().decode(T.self, from: data)
                                print(json)
                                onSuccess(json)

                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.error_description].stringValue == "you are not authorized to perform this action." || dict[Constants.ApiKeys.message].stringValue == "Your account is blocked, please contact admin to unblock."{
                                CommonFunctions.logout()
                                userData.shared.deleteData()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != "" && dict[Constants.ApiKeys.message].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                            if dict[Constants.ApiKeys.error_description].stringValue != ""{
                                print(dict[Constants.ApiKeys.error_description].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.error_description].stringValue )
                            }
                            
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
            
        }else if method == .PostWithJSON || method == .PUTWithJSON || method == .DELETEWithJSON || method == .PATCHWithJSON{
            
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var request = URLRequest(url: URL(string: "\(NetworkURL().BASE_URL)\(url)")!)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(header)", forHTTPHeaderField: "Authorization")
            request.headers = header
            
            if method == .PostWithJSON{
                request.httpMethod = "POST"
            }else if method == .PUTWithJSON{
                request.httpMethod = "PUT"
            }else if method == .PATCHWithJSON{
                    request.httpMethod = "PATCH"
            }else{
                request.httpMethod = "DELETE"
            }
            
            AF.request(request).responseJSON{response in
                let statusCode = response.response?.statusCode
                    switch response.result{
                    case .success(_):
                        if (200...299).contains(statusCode ?? 0){
                            if let data = response.data{
                                do{
                                    let jsondata = try JSON(data: data)
                                    print(jsondata)
                                    let json = try JSONDecoder().decode(T.self, from: data)
                                    onSuccess(json)
                                }
                                catch let error as NSError {
                                    print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                    print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                    onFailure(false, error.userInfo.debugDescription)
                                }
                            }
                        }else{
                            let dict = JSON(response.data ?? Data())
                            if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                                if dict[Constants.ApiKeys.error].stringValue == "you are not authorized to perform this action." || dict[Constants.ApiKeys.message].stringValue == "Your account is blocked, please contact admin to unblock."{
                                    CommonFunctions.logout()
                                    userData.shared.deleteData()
                                }
                                if dict[Constants.ApiKeys.error].stringValue != ""{
                                    print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                    onFailure(false,dict[Constants.ApiKeys.error].stringValue )
                                }
                            }else if (statusCode == 500 || statusCode == 503){
                                print("Server Error")
                                onFailure(false,"Server Error")
                            }else{
                                if dict[Constants.ApiKeys.error].stringValue != ""{
                                    print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                    onFailure(false,dict[Constants.ApiKeys.error].stringValue )
                                }
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        onFailure(false, error.localizedDescription)
                    }
//                }
                
            }
        }else if method == .GetString || method == .PostString{
            var kMehod: HTTPMethod?
            
            switch method {
            case .GetString:
                kMehod = .get
            case .PostString:
                kMehod = .post
            default:
                break
            }
            
            AF.request("\(NetworkURL().BASE_URL)\(url)", method: kMehod ?? .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseString{ response in
                print(response)
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let jsondata = try JSON(data: data)
                                print(jsondata)
                                let json = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.error_description].stringValue == "you are not authorized to perform this action." || dict[Constants.ApiKeys.message].stringValue == "Your account is blocked, please contact admin to unblock."{
                                CommonFunctions.logout()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
            
        }else{       // MARK:- UPLOAD IMAGE IN THIS CASE, However it is better to make upload 1 by 1 instead of uploading all at once.
            //                        because if it failed, it will only failed on 1 image. but upload all at once,
            //                         if 1 file failed user need to restart the uploading process from the beginning.
            //                         nevertheless here is what you going have to do if you want to upload multiple data at once.
            
            // MARK:- IMAGES AND IMAGE PARAMS MUST BE EQUAL
            if img?.count != imageParamater?.count{
                print("\nNumber of images and number of image parameters must be same.")
                return
            }
            
            var kMehod: HTTPMethod = .post
            
            if method == .PUTWithImage{
                kMehod = .put
            }
            
            AF.upload(multipartFormData: {multipartFormData in
                
                for (num, value) in (imageParamater ?? []).enumerated() {
                    guard let compressedImg = img?[num].jpegData(compressionQuality: 0.2)else{
                        return
                    }
                    multipartFormData.append(compressedImg, withName: value, fileName: "File-\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    print("\n param : \(value) \n imgName : \("File-\(Date().timeIntervalSince1970).jpeg") ")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }, to: "\(NetworkURL().BASE_URL)\(url)", method: kMehod, headers: header).uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseJSON(completionHandler: { data in
                print("upload finished: \(data)")
            }).response { (response) in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let resut):
                    print("upload success result: \(resut ?? Data())")
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.error_description].stringValue == "you are not authorized to perform this action."{
                                CommonFunctions.logout()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
        }
    }
    
    // MARK:- THIS METHOD RETURN RESPONSE IN JSON
    static func callApiWithParametersJson(url: String , withParameters parameters: [String: Any], onSuccess:@escaping (JSON)->(), onFailure: @escaping (Bool, String)->(), method: ApiMethod, img: [UIImage]? , imageParamater: [String]?, headerPresent: Bool){
        
        var header : HTTPHeaders = [
            
        ]
        
        userData.shared.getData()
        
        // MARK:- HEADER CREATED, YOU CAN ALSO SEND YOUR CUSTOM HEADER
        if headerPresent{
                header = [.authorization(userData.shared.accessToken )]
            
//            header = [.authorization(userData.shared.userAccessToken ?? "")]
            
        }
        
        // MARK:- PRINT ALL REQUESTED DATA
        print("Requested data :-\n URL: \(NetworkURL().BASE_URL)\(url)\n HttpMethod: \(method)\n Header: \(header)\n Requested Params: \(parameters)\n\n\n\n\n")
        print("\(NetworkURL().BASE_URL)\(url)")
        print(parameters)
        print(header)
        print(method)
        
        // MARK:- CHECK WHETHER INTERNET IS CONNECTED OR NOT
        if !Reachability.isConnectedToNetwork(){
            onFailure(false, "Internet not found")
            return
        }
        
        // MARK:- REQUESTED METHODS
        if method == .GET || method == .POST || method == .PUT || method == .DELETE{
            
            var kMehod: HTTPMethod?
            
            switch method {
            case .GET:
                kMehod = .get
            case .POST:
                kMehod = .post
            case .PUT:
                kMehod = .put
            case .DELETE:
                kMehod = .delete
            default:
                break
            }
            
            AF.sessionConfiguration.timeoutIntervalForRequest = 60              //FOR TIMEOUT SETTINGS
            AF.request("\(NetworkURL().BASE_URL)\(url)", method: kMehod ?? .get, parameters: parameters, encoding: URLEncoding.default, headers: header).response{ response in
                print(response)
                
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSON(data: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.error_description].stringValue == "you are not authorized to perform this action."{
                                CommonFunctions.logout()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
            
        }else if method == .PostWithJSON || method == .PUTWithJSON || method == .DELETEWithJSON{
            
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var request = URLRequest(url: URL(string: "\(NetworkURL().BASE_URL)\(url)")!)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = header
            
            if method == .PostWithJSON{
                request.httpMethod = "POST"
            }else if method == .PUTWithJSON{
                request.httpMethod = "PUT"
            }else{
                request.httpMethod = "DELETE"
            }
            
            AF.request(request).responseJSON{response in
                print(response)
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSON(data: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.message].stringValue == "Your account is blocked, please contact admin to unblock."{
                                CommonFunctions.logout()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
        }else if method == .GetString || method == .PostString{
            var kMehod: HTTPMethod?
            
            switch method {
            case .GetString:
                kMehod = .get
            case .PostString:
                kMehod = .post
            default:
                break
            }
            
            AF.request("\(NetworkURL().BASE_URL)\(url)", method: kMehod ?? .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseString{ response in
                print(response)
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSON(data: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.message].stringValue == "Your account is blocked, please contact admin to unblock."{
                                CommonFunctions.logout()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
            
        }else{       // MARK:- UPLOAD IMAGE IN THIS CASE, However it is better to make upload 1 by 1 instead of uploading all at once.
//                        because if it failed, it will only failed on 1 image. but upload all at once,
//                         if 1 file failed user need to restart the uploading process from the beginning.
//                         nevertheless here is what you going have to do if you want to upload multiple data at once.
            
            // MARK:- IMAGES AND IMAGE PARAMS MUST BE EQUAL
            if img?.count != imageParamater?.count{
                print("\nNumber of images and number of image parameters must be same.")
                return
            }
            
            var kMehod: HTTPMethod = .post
            
            if method == .PUTWithImage{
                kMehod = .put
            }
            
            AF.upload(multipartFormData: {multipartFormData in
                
                for (num, value) in (imageParamater ?? []).enumerated() {
                    guard let compressedImg = img?[num].jpegData(compressionQuality: 0.2)else{
                        return
                    }
                    multipartFormData.append(compressedImg, withName: value, fileName: "File-\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }, to: "\(NetworkURL().BASE_URL)\(url)", method: kMehod, headers: header).uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseJSON(completionHandler: { data in
                print("upload finished: \(data)")
            }).response { (response) in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let resut):
                    print("upload success result: \(resut ?? Data())")
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSON(data: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict[Constants.ApiKeys.message].stringValue == "Your account is blocked, please contact admin to unblock."{
                                CommonFunctions.logout()
                            }
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict[Constants.ApiKeys.error].stringValue != ""{
                                print(dict[Constants.ApiKeys.error].stringValue,"\n", dict[Constants.ApiKeys.message].stringValue)
                                onFailure(false,dict[Constants.ApiKeys.message].stringValue )
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
        }
    }
}


