//
//  NotificationVM.swift
//  Lyber
//
//  Created by Lyber on 09/05/2023.
//

import Foundation

class NotificationVM{
	func notificationsGetNotificationsAPI(limit : Int, offset: Int, completion: @escaping ( (NotificationAPI?) -> Void )){
		
		let params : [String : Any] = [Constants.ApiKeys.limit : limit,
									   Constants.ApiKeys.offset : offset]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.notificationServiceNotifications, withParameters: params, ofType: NotificationAPI.self, onSuccess: { response in
			print(response)
			completion(response)
		}, onFailure: { reload, error, code in
			completion(nil)
			CommonFunctions.toster(error)
		}, method: .GET, img: nil, imageParamater: nil, headerType: "user")
	}
	
}
