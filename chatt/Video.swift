//
//  Model.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/07.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: String?
    var uploadDate: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
