//
//  Activity.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/23.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Tweet {
    let user: TweetUser!
    let message: String
    
    init(json: JSON) {
        let userJson = json["user"]
        self.user = TweetUser(json: userJson)
        
        self.message = json["message"].stringValue
    }
}
