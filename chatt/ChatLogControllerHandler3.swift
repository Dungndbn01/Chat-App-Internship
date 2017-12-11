//
//  ChatLogControllerHandler3.swift
//  ChatApp
//
//  Created by DevOminext on 12/8/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

extension ChatLogController {
    
    func addLabel() {
        self.view.addSubview(self.typingLabel)
        typingLabel.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        typingLabel.textColor = .blue
//        self.typingLabel.frame = CGRect(x: 0, y: self.view.frame.height - 80, width: 200, height: 30)
        self.typingLabel.anchor(nil, left: self.view.leftAnchor, bottom: self.inputContainerView.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 30)
    }
    
    func setupTypingLabel() {
            if self.user?.id != nil {
                let ref = Database.database().reference().child("user")
                ref.observe(.childChanged, with: {
                    (DataSnapshot) in
                    let userId = DataSnapshot.key
                    if userId == self.user?.id {
                        let ref = Database.database().reference().child("user").child(userId)
                        ref.observeSingleEvent(of: .value, with: {
                            (DataSnapshot) in
                            let dictionary = DataSnapshot.value as? [String: AnyObject]
                                            let isTypingCheck = dictionary!["isTypingCheck"] as! String
                                            DispatchQueue.main.async {
                                            if isTypingCheck == "true" {
                                                self.typingLabel.text = "\(self.user?.name ?? "") is typing..."
                                                self.addLabel()
                                            } else if isTypingCheck == "false" {
                                                self.typingLabel.removeFromSuperview()
                                            }
                            }

                        })
                    }
                })
        } else if self.user?.id == nil {
            let ref = Database.database().reference().child("group-users")
                ref.observe(.childChanged, with: {
                    (DataSnapshot) in
                      let groupId = DataSnapshot.key
                    let groupRef = Database.database().reference().child("group-users").child(groupId)
                    groupRef.observe(.childAdded, with: {
                        (DataSnapshot) in
                        let userId = DataSnapshot.key
                        let userRef = Database.database().reference().child("user").child(userId)
                        userRef.observeSingleEvent(of: .value, with: {
                            (DataSnapshot) in
                            let dictionary = DataSnapshot.value as! [String: AnyObject]
                            let userName = dictionary["name"] as! String
                            let isTypingCheck = dictionary["isTypingCheck"] as! String
                            if isTypingCheck == "true" && userId != Auth.auth().currentUser?.uid{
                                self.typingLabel.text = "\(userName ) is typing..."
                                self.addLabel()
                            } else if isTypingCheck == "false" {
                                self.typingLabel.removeFromSuperview()
                            }
                        })
                    })
                }, withCancel: nil)
            }
    }
    
    func handleChoosePhoto() {
        inputTextView.endEditing(true)
        
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0)
            window.addSubview(blackView)
            window.addSubview(totalView)
            setupMediaOptionsContainer()
            blackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss4)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.totalView.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
                self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width
                , height: self.view.frame.height - 50)
                self.collectionViewScroll()
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func handleDismiss4() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width
                , height: self.view.frame.height - 50)
            self.totalView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50)
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.totalView.removeFromSuperview()
            self.blackView.removeFromSuperview()
        })
    }
    
    func handleUploadImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        handleDismiss4()
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func handleShowLocation() {
        handleDismiss4()
        self.present(GoogleMapViewController(), animated: true, completion: nil)
    }
    
    func handleShowVoiceMessage() {
        handleDismiss4()
        self.present(AudioRecordedController(), animated: true, completion: nil)
    }
    
    func setupMediaOptionsContainer() {
        imageChooseButton = imageChooseButton.setUpButton(radius: 0, title: "", imageName: "rsz_imagebt", backgroundColor: .clear, fontSize: 0, titleColor: .clear)
        imageChooseButton.addTarget(self, action: #selector(handleUploadImage), for: .touchUpInside)
        locationButton = locationButton.setUpButton(radius: 0, title: "", imageName: "rsz_locationbt", backgroundColor: .clear, fontSize: 0, titleColor: .clear)
        locationButton.addTarget(self, action: #selector(handleShowLocation), for: .touchUpInside)
        voiceMessageButton = voiceMessageButton.setUpButton(radius: 0, title: "", imageName: "rsz_microbt", backgroundColor: .clear, fontSize: 0, titleColor: .clear)
        voiceMessageButton.addTarget(self, action: #selector(handleShowVoiceMessage), for: .touchUpInside)
        cancelButton = cancelButton.setUpButton(radius: 0, title: "", imageName: "rsz_x", backgroundColor: .clear, fontSize: 0, titleColor: .clear)
        cancelButton.addTarget(self, action: #selector(handleDismiss4), for: .touchUpInside)
        
        let imageChooseButtonContainer = UIView()
        let locationButtonContainer = UIView()
        let voiceMessageButtonContainer = UIView()
//        let handWrittenMessageButtonContainer = UIView()
        
        mediaOptionsContainer = UIStackView(arrangedSubviews: [imageChooseButtonContainer, locationButtonContainer, voiceMessageButtonContainer])
        mediaOptionsContainer.axis = .horizontal
        mediaOptionsContainer.distribution = .fillEqually
        
        imageChooseButtonContainer.addSubview(imageChooseButton)
        locationButtonContainer.addSubview(locationButton)
        voiceMessageButtonContainer.addSubview(voiceMessageButton)
//        handWrittenMessageButtonContainer.addSubview(handWrittenMessageButton)
        
        imageChooseButton.fillSuperview()
        locationButton.fillSuperview()
        voiceMessageButton.fillSuperview()
//        handWrittenMessageButton.fillSuperview()
        
        totalView.addSubview(upperView)
//        totalView.addSubview(mediaNameContainer)
        
        upperView.addSubview(mediaOptionsContainer)
        upperView.addSubview(cancelButton)
        
        totalView.backgroundColor = UIColor(r:235, g: 235, b: 235)
        totalView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50)
        
        upperView.anchor(self.totalView.topAnchor, left: self.totalView.leftAnchor, bottom: self.totalView.bottomAnchor, right: self.totalView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        mediaOptionsContainer.anchor(self.upperView.topAnchor, left: self.upperView.leftAnchor, bottom: self.upperView.bottomAnchor, right: self.upperView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 0)
        
        cancelButton.anchor(self.upperView.topAnchor, left: self.mediaOptionsContainer.rightAnchor, bottom: self.upperView.bottomAnchor, right: self.upperView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
//        mediaNameContainer.anchor(self.totalView.centerYAnchor, left: self.totalView.leftAnchor, bottom: self.totalView.bottomAnchor, right: self.totalView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
