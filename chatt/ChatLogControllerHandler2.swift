//
//  ChatLogControllerHandler2.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/12.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

extension ChatLogController {
    
    func handleLongTap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.collectionView)
            if let indexPathh = self.collectionView?.indexPathForItem(at: touchPoint) {
                self.indexPath = indexPathh
                self.message = self.messages[indexPath!.item]
            }
        
            inputTextView.endEditing(true)
            if self.message?.text == "Message has been recalled" {
                self.messageOptionsContainer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 100)
            } else {
                self.messageOptionsContainer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 200) }
            
            self.blackView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            window.addSubview(messageOptionsContainer)
                self.setupMessageOptionsContainer(message: message!)
            self.blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                if self.message?.text == "Message has been recalled" {
                    self.messageOptionsContainer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width, height: 100)
                } else {
                    self.messageOptionsContainer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: UIScreen.main.bounds.width, height: 200) }

                self.blackView.alpha = 1
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss3)))

          }
       }
    }
    
    func handleDismiss3() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.messageOptionsContainer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 200)
        self.blackView.alpha = 0
        }, completion: { (finished: Bool) in
            self.blackView.removeFromSuperview()
            self.deleteButton.removeFromSuperview()
            self.upperStackView.removeFromSuperview()
            self.messageOptionsContainer.removeFromSuperview()
        })
    }
    
    func setupMessageOptionsContainer(message: Message) {
        replyButton = replyButton.setUpButton(radius: 0, title: "Reply", imageName: "Reply_BT", backgroundColor: .clear, fontSize: 16, titleColor: .black)
        replyButton.imageEdgeInsets = UIEdgeInsetsMake(0, (width - 45)/2, 0, (width - 45)/2)
        replyButton.titleEdgeInsets = UIEdgeInsetsMake(62, -22, 0, 0)
        replyButton.tintColor = .blue
        
        copyButton = copyButton.setUpButton(radius: 0, title: "Copy", imageName: "Copy_BT", backgroundColor: .clear, fontSize: 16, titleColor: .black)
        copyButton.imageEdgeInsets = UIEdgeInsetsMake(0, (width - 45)/2, 0, (width - 45)/2)
        copyButton.titleEdgeInsets = UIEdgeInsetsMake(62, -22, 0, 0)
        copyButton.addTarget(self, action: #selector(copyMessage), for: .touchUpInside)
        
        shareButton = shareButton.setUpButton(radius: 0, title: "Share", imageName: "Share_BT", backgroundColor: .clear, fontSize: 16, titleColor: .black)
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, (width - 45)/2, 0, (width - 45)/2)
        shareButton.titleEdgeInsets = UIEdgeInsetsMake(62, -22, 0, 0)
        
        detailbutton = detailbutton.setUpButton(radius: 0, title: "Detail", imageName: "Detail_BT", backgroundColor: .clear, fontSize: 16, titleColor: .black)
        detailbutton.imageEdgeInsets = UIEdgeInsetsMake(0, (width - 45)/2, 0, (width - 45)/2)
        detailbutton.titleEdgeInsets = UIEdgeInsetsMake(62, -22, 0, 0)
        detailbutton.addTarget(self, action: #selector(detailMessage), for: .touchUpInside)
        
        deleteButton = deleteButton.setUpButton(radius: 0, title: "Delete", imageName: "Delete_BT", backgroundColor: .clear, fontSize: 16, titleColor: .black)
        deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, (100 - 45)/2, 0, (100 - 45)/2)
        deleteButton.titleEdgeInsets = UIEdgeInsetsMake(62, -22, 0, 0)
        deleteButton.addTarget(self, action: #selector(deleteMessage), for: .touchUpInside)
        
        recallButton = deleteButton.setUpButton(radius: 0, title: "Recall", imageName: "Recall_BT", backgroundColor: .clear, fontSize: 16, titleColor: .black)
        recallButton.imageEdgeInsets = UIEdgeInsetsMake(0, (100 - 45)/2, 0, (100 - 45)/2)
        recallButton.titleEdgeInsets = UIEdgeInsetsMake(62, -22, 0, 0)
        recallButton.addTarget(self, action: #selector(recallMessage), for: .touchUpInside)
        
        let replyButtonContainer = UIView()
        let copyButtonContainer = UIView()
        let shareButtonContainer = UIView()
        let detailbuttonContainer = UIView()
        
        upperStackView = UIStackView(arrangedSubviews: [replyButtonContainer, copyButtonContainer, shareButtonContainer,detailbuttonContainer])
        upperStackView.axis = .horizontal
        upperStackView.distribution = .fillEqually
        
        messageOptionsContainer.backgroundColor = UIColor(r: 252, g: 252, b: 252)
        let path = UIBezierPath(roundedRect: messageOptionsContainer.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        messageOptionsContainer.layer.mask = mask
        
        if message.text == "Message has been recalled" {
            messageOptionsContainer.addSubview(deleteButton)
        } else if message.text != "Message has been recalled" {
            
            messageOptionsContainer.addSubview(deleteButton)
            messageOptionsContainer.addSubview(upperStackView)
            
            upperStackView.addSubview(replyButton)
            upperStackView.addSubview(copyButton)
            upperStackView.addSubview(shareButton)
            upperStackView.addSubview(detailbutton)
            upperStackView.addSubview(recallButton)
            
            upperStackView.anchor(messageOptionsContainer.topAnchor, left: messageOptionsContainer.leftAnchor, bottom: messageOptionsContainer.centerYAnchor, right: messageOptionsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            replyButton.anchor(replyButtonContainer.topAnchor, left: replyButtonContainer.leftAnchor, bottom: replyButtonContainer.bottomAnchor, right: replyButtonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            copyButton.anchor(copyButtonContainer.topAnchor, left: copyButtonContainer.leftAnchor, bottom: copyButtonContainer.bottomAnchor, right: copyButtonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            shareButton.anchor(shareButtonContainer.topAnchor, left: shareButtonContainer.leftAnchor, bottom: shareButtonContainer.bottomAnchor, right: shareButtonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            detailbutton.anchor(detailbuttonContainer.topAnchor, left: detailbuttonContainer.leftAnchor, bottom: detailbuttonContainer.bottomAnchor, right: detailbuttonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            recallButton.anchor(detailbuttonContainer.topAnchor, left: detailbuttonContainer.leftAnchor, bottom: detailbuttonContainer.bottomAnchor, right: detailbuttonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
        deleteButton.anchor(nil, left: messageOptionsContainer.centerXAnchor, bottom: messageOptionsContainer.bottomAnchor, right: nil, topConstant: 0, leftConstant: -50, bottomConstant: 10, rightConstant: 0, widthConstant: 100, heightConstant: 80)
        
        checkSentTime(message: message)
    }
    
    func checkSentTime(message: Message) {
        if let seconds = message.timeStamp?.doubleValue {
            let date = NSDate()
            let calendar = Calendar.current
            let timeStampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter1 = DateFormatter(), dateFormatter2 = DateFormatter(), dateFormatter3 = DateFormatter()
            dateFormatter1.dateFormat = "dd"
            dateFormatter2.dateFormat = "HH"
            dateFormatter3.dateFormat = "mm"
            
            let messageDay: String = dateFormatter1.string(from: timeStampDate as Date)
            let messageHour: String = dateFormatter2.string(from: timeStampDate as Date)
            let messageMinute: String = dateFormatter3.string(from: timeStampDate as Date)
        
            let day = calendar.component(.day, from: date as Date)
            let hour = calendar.component(.hour, from: date as Date)
            let minute = calendar.component(.minute, from: date as Date)
            
            if Int(messageDay) == Int(day) && Int(messageHour) == Int(hour) && (Int(minute) - Int(messageMinute)! <= 3) && message.fromId == Auth.auth().currentUser?.uid {
                detailbutton.isHidden = true
                recallButton.isHidden = false
            } else {
                detailbutton.isHidden = false
                recallButton.isHidden = true
            }
        }
    }
    
    func copyMessageDelegate(message: Message) {
        UIPasteboard.general.string = message.text
    }
    
    func copyMessage() {
        copyMessageDelegate(message: message!)
        self.handleDismiss3()
    }
    
    func detailMessageDelegate(message: Message) {
        let messageDetailController = MessageDetailController()
        messageDetailController.message = message
        messageDetailController.user = self.user
        messageDetailController.userName = self.detailUserName
        navigationController?.pushViewController(messageDetailController, animated: true)
    }
    
    func detailMessage() {
        detailMessageDelegate(message: message!)
        self.handleDismiss3()
    }
    
    func recallMessageDelegate(message: Message, indexPath: IndexPath) {
        if let messageId = message.messageId {
            let messageRef = Database.database().reference(withPath: "message/\(messageId)/text")
            messageRef.setValue("Message has been recalled")
        }
        
        message.text = "Message has been recalled"
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.textView.textColor = .lightGray
        
        self.collectionView?.reloadData()
    }
    
    func recallMessage() {
        recallMessageDelegate(message: message!, indexPath: indexPath!)
        self.handleDismiss3()
    }
    
    func deleteMessageDelegate(message: Message, indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let messageId = messageIdArray[indexPath.item]
        if user != nil {
        let chatPartnerId = message.chatPartnerId()
            Database.database().reference().child("user-message").child(uid).child(chatPartnerId!).child(messageId).removeValue(completionBlock: {
                (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
            } ) } else  if user == nil {
            Database.database().reference().child("user-message").child((group?.id!)!).child(messageId).removeValue()
        }
        self.messages.remove(at: indexPath.item)
        self.collectionView?.deleteItems(at: [indexPath])
//        Database.database().reference().child("user-message").child(uid).child(chatPartnerId!).removeAllObservers()
        self.handleDismiss3()
    }
    
    func deleteMessage() {
        deleteMessageDelegate(message: message!, indexPath: indexPath!)
    }

    func backButtonClick(sender : UIButton) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(withPath: "user/\(uid)/chattingWith")
            ref.setValue("NoOne")
        }

        handleProfileDismiss()
        let chatLog = ChatLogController()
        chatLog.removeFromParentViewController()
        NotificationCenter.default.removeObserver(self)
        Database.database().reference().child("user-message").removeAllObservers()
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        self.navigationController?.popoverPresentationController?.sourceView = self.view
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
    }
                
    func showProfileContainer() {
        
        if let window = UIApplication.shared.keyWindow {

            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            brightView.backgroundColor = UIColor(white: 0, alpha: 0)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileDismiss)))
//            brightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileDismiss)))
            
            window.addSubview(blackView)
//            window.addSubview(brightView)
            window.addSubview(profileContainerView)
            window.addSubview(profileSection)
            window.addSubview(chatImagesSection)
            window.addSubview(playSoundSection)
            window.addSubview(voiceChatSection)
            window.addSubview(separatorLine1)
            window.addSubview(separatorLine2)
            window.addSubview(arrowImageView1)
            window.addSubview(arrowImageView2)
            window.addSubview(switchView)
            
            profileContainerView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: UIApplication.shared.statusBarFrame.size.height + 60, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 150)
            
            separatorLine2.anchor(chatImagesSection.bottomAnchor, left: profileContainerView.leftAnchor, bottom: nil, right: profileContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
            
            separatorLine1.anchor(profileSection.bottomAnchor, left: profileContainerView.leftAnchor, bottom: nil, right: profileContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
            
            voiceChatSection.anchor(playSoundSection.bottomAnchor, left: profileContainerView.leftAnchor, bottom: nil, right: profileContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 12)
            
            playSoundSection.anchor(chatImagesSection.bottomAnchor, left: profileContainerView.leftAnchor, bottom: nil, right: profileContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
            
            chatImagesSection.anchor(profileSection.bottomAnchor, left: profileContainerView.leftAnchor, bottom: nil, right: profileContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
            
            profileSection.anchor(profileContainerView.topAnchor, left: profileContainerView.leftAnchor, bottom: nil, right: profileContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
            
            arrowImageView1.anchor(profileSection.topAnchor, left: nil, bottom: profileSection.bottomAnchor, right: profileContainerView.rightAnchor, topConstant: 11, leftConstant: 0, bottomConstant: 11, rightConstant: 12, widthConstant: 20, heightConstant: 20)
            
            arrowImageView2.anchor(chatImagesSection.topAnchor, left: nil, bottom: chatImagesSection.bottomAnchor, right: profileContainerView.rightAnchor, topConstant: 11, leftConstant: 0, bottomConstant: 11, rightConstant: 12, widthConstant: 20, heightConstant: 20)

            switchView.rightAnchor.constraint(equalTo: profileContainerView.rightAnchor, constant: -12).isActive = true
            switchView.widthAnchor.constraint(equalToConstant: 51).isActive = true
            switchView.centerYAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: -33).isActive = true
            switchView.heightAnchor.constraint(equalToConstant: 31).isActive = true

            blackView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
//                self.brightView.alpha = 1
                self.profileContainerView.alpha = 1
                self.profileSection.alpha = 1
                self.chatImagesSection.alpha = 1
                self.playSoundSection.alpha = 1
                self.voiceChatSection.alpha = 1
                self.separatorLine1.alpha = 1
                self.separatorLine2.alpha = 1
                self.arrowImageView1.alpha = 1
                self.arrowImageView2.alpha = 1
                self.switchView.alpha = 1
                
            }, completion: nil)
            
        }

    }
    
    func handleProfileDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            self.blackView.removeFromSuperview()
//            self.brightView.removeFromSuperview()
            self.profileContainerView.removeFromSuperview()
            self.profileSection.removeFromSuperview()
            self.chatImagesSection.removeFromSuperview()
            self.playSoundSection.removeFromSuperview()
            self.voiceChatSection.removeFromSuperview()
            self.separatorLine1.removeFromSuperview()
            self.separatorLine2.removeFromSuperview()
            self.arrowImageView1.removeFromSuperview()
            self.arrowImageView2.removeFromSuperview()
            self.switchView.removeFromSuperview()
            
//            self.profileContainerView.removeFromSuperview()
            
        } , completion: nil
//            {
//            (_) -> Void in
//            self.blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleDismiss)))
//        }
        )
    }

}
