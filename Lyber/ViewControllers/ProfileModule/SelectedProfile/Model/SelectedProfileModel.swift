//
//  SelectedProfileModel.swift
//  Lyber
//
//  Created by sonam's Mac on 17/08/22.
//

import Foundation

struct ImageUploadApi: Codable {
    let s3Url,file_name: String?
}

//Profile Update Api
struct profileUpdateApi: Codable {
    let message,profile_pic,profile_pic_type: String?
}
