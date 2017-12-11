//
//  FireBaseManager.swift
//  ChatApp
//
//  Created by DevOminext on 11/20/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import Foundation
import Firebase

class FireBaseManager {
    
    static func handleRecordedAudioForUrl(url: NSURL, audioDuration: Int) {
        let filename = NSUUID().uuidString + ".mp3"
        let audioRef = Storage.storage().reference().child("message_audios").child(filename)
//        let metadata = StorageMetadata()
//        metadata.contentType = "audio/mp3"
        
        audioRef.putFile(from: url as URL, metadata: nil, completion: {
            (metadata, error) in
            if error != nil {
                print("Failed to upload video", error!)
                return
            }
            
            let chatLog = ChatLogController()
            
            if let audioUrl = metadata?.downloadURL()?.absoluteString {
                
                let properties: [String: AnyObject] = ["audioUrl": audioUrl as AnyObject,
                                                       "audioDuration": audioDuration as NSNumber]
                chatLog.sendMessageWithProperties(properties: properties)
            }
        } )
    }
}
