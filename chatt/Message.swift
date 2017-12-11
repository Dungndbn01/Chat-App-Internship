//
//  Message.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/26.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    var negativeTimeStamp: NSNumber?
    
    var imageUrl: String?
    
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var audioDuration: NSNumber?
    
    var videoUrl: String?
    var audioUrl: String?
    var messageId: String?
    var messageStatus: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text   = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        negativeTimeStamp = dictionary["negativeTimeStamp"] as? NSNumber
        messageId = dictionary["messageId"] as? String
        messageStatus = dictionary["messageStatus"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
        audioUrl = dictionary["audioUrl"] as? String
        audioDuration = dictionary["audioDuration"] as? NSNumber
        
    }
    
   

}
