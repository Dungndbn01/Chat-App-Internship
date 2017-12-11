//
//  ActivityUser.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/23.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TweetUser {
    let name: String
    let username: String
    let bioText: String
    let profileImageUrl: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.bioText = json["bio"].stringValue
        self.profileImageUrl = json["profileImageUrl"].stringValue
    }
}
