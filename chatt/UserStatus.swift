//
//  UserStatus.swift
//  ChatApp
//
//  Created by DevOminext on 11/27/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class UserStatus: NSObject {
    var statusText: String?
    var statusImageUrl: String?
    var name: String?
    var profileImageUrl: String?
    var timeStamp: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        statusText = dictionary["statusText"] as? String
        statusImageUrl = dictionary["statusImageUrl"] as? String
        name = dictionary["name"] as? String
        profileImageUrl = dictionary["profileImageUrl"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
    }
}


