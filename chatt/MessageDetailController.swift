//
//  MessageDetailController.swift
//  ChatApp
//
//  Created by DevOminext on 12/7/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

class MessageDetailController: UIViewController {
    lazy var userNameLabel = UILabel()
    lazy var timeSentLabel = UILabel()
    lazy var messageTextView = UITextView()
    lazy var statusLabel = UILabel()
    var userName: String?
    var user: User?
    var textHeight: CGFloat?

    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        self.navigationItem.title = user?.name
        fetchUserName()
        setupTimeSentLabel()
        setupTextView()
    }
    
    func fetchUserName() {
        let userRef = Database.database().reference().child("user").child((message?.fromId)!)
        userRef.observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            let dictionary = DataSnapshot.value as! [String: Any]
            let userName = dictionary["name"] as? String
            if self.message?.fromId == Auth.auth().currentUser?.uid {
                self.userNameLabel = self.userNameLabel.setUpLabel(labelText: "Me (\(userName!))", textColor: .darkText, size: 16)
            } else {
                self.userNameLabel = self.userNameLabel.setUpLabel(labelText: "From: \(userName!)", textColor: .darkText, size: 16)
            }
            
            self.setupUserNameLabel()
            
        })
    }
    
    func setupTimeSentLabel() {
            let seconds = message?.timeStamp?.doubleValue
            let messageTimeStamp = NSDate(timeIntervalSince1970: seconds!)
            let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
            let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateFormat = "dd/MM/yyyy"
            
            let dateString: String = dateFormatter.string(from: messageTimeStamp as Date)
            let dateString2: String = dateFormatter2.string(from: messageTimeStamp as Date)
            
            let timeLabelText = "Sent at: \(dateString2) \(dateString)"
            timeSentLabel = timeSentLabel.setUpLabel(labelText: timeLabelText, textColor: .blue, size: 12)
            timeSentLabel.textAlignment = .right
            timeSentLabel.backgroundColor = .clear
        
        self.view.addSubview(timeSentLabel)
        timeSentLabel.anchor(self.view.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 114, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 200, heightConstant: 16)
    }
    
    func setupUserNameLabel() {
        
        userNameLabel.textAlignment = .right
        userNameLabel.backgroundColor = .clear
        
        self.view.addSubview(userNameLabel)
        userNameLabel.anchor(self.view.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 84, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 200, heightConstant: 20)
    }
    
    func setupStatusLabel() {
        
    }
    
    func setupTextView() {
        if message?.text != nil {
        messageTextView = messageTextView.setUpTextView(text: (message?.text)!, textColor: .darkGray, size: 16)
        messageTextView.layer.cornerRadius = 16
        messageTextView.layer.masksToBounds = true
        messageTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        if message?.fromId == Auth.auth().currentUser?.uid {
            messageTextView.backgroundColor = UIColor.blue
            messageTextView.textColor = .white
        } else {
            messageTextView.backgroundColor = UIColor.lightGray
            messageTextView.textColor = .blue
        }
            
        self.view.addSubview(messageTextView)
            textHeight = estimateFrameForText(text: (message?.text)!).height + 20
            let textWidth = estimateFrameForText(text: (message?.text)!).width + 28
            messageTextView.anchor(self.view.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 138, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: textWidth, heightConstant: textHeight!) } else {
            return
        }
    }
    
    private func estimateHeightForText(_ text: String) -> CGFloat {
        let approximateWidthOfBioTextView = 182
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        
        let estimateFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimateFrame.height
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 182, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

}
