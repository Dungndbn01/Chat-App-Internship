//
//  User.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/24.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var checkOnline: String?
    var backgroundImageUrl: String?
    var isTypingCheck: String?
    var lastTimeLoggin: NSNumber?
    var lastTimeLogout: NSNumber?
    var chattingWith: String? 
}

