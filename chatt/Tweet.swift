//
//  Tweet.swift
//  PartFromMainProject
//
//  Created by Nguyen Dinh Dung on 2017/11/22.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Tweet {
    let user: User!
    let message: String
    
    init(json: JSON) {
        let userJson = json["user"]
        self.user = User(json: userJson)
        
        self.message = json["message"].stringValue
    }
}
