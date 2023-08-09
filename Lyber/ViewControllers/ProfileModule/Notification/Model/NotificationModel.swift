//
//  NotificationModel.swift
//  Lyber
//
//  Created by Lyber on 09/05/2023.
//

import Foundation

//MARK: NotificationAPI
struct NotificationAPI: Codable{
	var data : [NotificationData]
}

//MARK: Notification
struct NotificationData: Codable{
	var date : String
	var log: String
}
