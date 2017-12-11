//
//  ChatLogControllerHandler.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/11.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import SVProgressHUD

extension ChatLogController {
    
    func observeUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        UserDefaults.standard.setValue(user?.checkOnline, forKey: "CheckOnline")
        
        let userMessageRef = (user?.id) == nil ? Database.database().reference().child("user-message").child((group?.id)!) : Database.database().reference().child("user-message").child(uid).child((user?.id)!)
        
        userMessageRef.observe(.childAdded, with: {
           (DataSnapshot) in
            let messageId  = DataSnapshot.key
            let messageRef = Database.database().reference().child("message").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: {
                (DataSnapshot) in
                
                guard let dictionary = DataSnapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                
                DispatchQueue.main.async {
                    if message.fromId != Auth.auth().currentUser?.uid {
                        let messageStatusRef = Database.database().reference(withPath: "message/\(messageId)/messageStatus")
                        messageStatusRef.setValue("Seen")
                    }

                    self.messages.append(message)
                    self.setupTextLabel(message: message)
                    self.messageIdArray.append(messageId)
                    self.collectionView?.insertItems(at: [IndexPath(item: self.messages.count - 1, section: 0)])
//                    self.collectionView?.reloadData()
                    self.collectionViewScroll()
                    self.collectionView?.layoutIfNeeded()
                    SVProgressHUD.dismiss()
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var dy: CGFloat?
        if let changeDict = change {
            if object as? NSObject == self.inputTextView && keyPath == "contentSize" {
                if let oldContentSize = (changeDict[NSKeyValueChangeKey.oldKey] as AnyObject).cgSizeValue,
                    let newContentSize = (changeDict[NSKeyValueChangeKey.newKey] as AnyObject).cgSizeValue {
                    
                    if ((inputContainerViewHeightAnchor?.constant)! > CGFloat(100)) && (newContentSize.height - oldContentSize.height > 0) {
                        dy = 0
                    } else {
                        dy = newContentSize.height - oldContentSize.height }
                    
                    if newContentSize.height > 80 && dy! < CGFloat(0) {
                        dy = 0
                    }
                    
                    inputContainerViewHeightAnchor?.constant = (inputContainerViewHeightAnchor?.constant)! + dy!
                    
                    if (inputContainerViewHeightAnchor?.constant)! < CGFloat(50) {
                        inputContainerViewHeightAnchor?.constant = 50
                    }
                    
                    self.collectionView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (self.collectionView?.frame.height)! - dy!)
                    self.view.layoutIfNeeded()
                    let contentOffsetToShowLastLine = CGPoint(x: 0.0, y: self.inputTextView.contentSize.height - view.bounds.height)
                    self.inputTextView.contentOffset = contentOffsetToShowLastLine
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] {
            // we selected a video
            handleVideoSelectedForUrl(url: videoUrl as! NSURL)
            
        } else {
            //we selected an image
            handleImageSelectedForInfo(info: info as [String : AnyObject]) }
        SVProgressHUD.show()
        dismiss(animated: true, completion: nil)
    }
    
     func handleRecordedAudioForUrl(url: NSURL, audioDuration: Int) {
        let filename = NSUUID().uuidString + ".m4a"
        let audioRef = Storage.storage().reference().child("message_audios").child(filename)
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"
        
        audioRef.putFile(from: url as URL, metadata: metadata, completion: {
            [unowned self] (metadata, error) in
            if error != nil {
                print("Failed to upload video", error!)
                return
            }
            
            if let audioUrl = metadata?.downloadURL()?.absoluteString {
                
                let properties: [String: AnyObject] = ["audioUrl": audioUrl as AnyObject,
                                                       "audioDuration": audioDuration as NSNumber]
                self.sendMessageWithProperties(properties: properties)
            }
        } )
    }
    
     func handleVideoSelectedForUrl(url: NSURL) {
        let filename = NSUUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url as URL, metadata: nil, completion: {
            (metadata, error) in
            if error != nil {
                print("Failed to upload video", error!)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url) {
                    
                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: {
                        (imageUrl) in
                        
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject,"videoUrl": videoUrl as AnyObject]
                        self.sendMessageWithProperties(properties: properties)
                        
                    })
                }
                
            }
        })
        
        uploadTask.observe(.progress, handler: {
            [unowned self] (DataSnapshot) in
            if let completedUnitCount = DataSnapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        })
        
        uploadTask.observe(.success, handler: { [unowned self] (DataSnapshot) in
            self.navigationItem.title = ""
        }
        )
    }
    
    func thumbnailImageForFileUrl(fileUrl: NSURL) -> UIImage? {
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    
     func handleImageSelectedForInfo(info: [String:AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: {
                (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
        }
        
    }
    
    func handleSendImageFromLibrary(imageUrl: String, selectedImage: UIImage!){
        uploadToFirebaseStorageUsingImage(image: selectedImage!, completion: {
                (imageUrl) in
            self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage!)
            })
    }
    
    func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()
        ) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            ref.putData(uploadData, metadata: nil, completion: {
                (metadata, error) in
                if error != nil {
                    print("Failed to upload data", error!)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
                
            })        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSend() {
        if let uid = Auth.auth().currentUser?.uid {
            let typingCheckRef = Database.database().reference(withPath: "user/\(uid)/isTypingCheck")
            typingCheckRef.setValue("false")
            observeUserTypingChange(value: 1)
        }
        
        if inputTextView.text != "" {
            var string: String! = inputTextView.text!
            while string[string.index(before: string.endIndex)] == " " && string != " "{
                string.remove(at: string.index(before: string.endIndex))
            }
            inputTextView.text = string }
        
        if inputTextView.text == " " {
            inputTextView.text = "Write Message"
            inputTextView.textColor = UIColor.lightGray
            
            inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument) }
        
        if inputTextView.text != "" && inputTextView.text != " " && inputTextView.textColor != UIColor.lightGray {
            let properties: [String: AnyObject] = ["text": inputTextView.text! as AnyObject]
            sendMessageWithProperties(properties: properties)
            //            inputTextView.text = ""
            
            inputTextView.text = "Write Message"
            inputTextView.textColor = UIColor.lightGray
            
            inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
        }
        inputTextView.textColor = UIColor.lightGray
    }
    
    func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : AnyObject]
        sendMessageWithProperties(properties: properties)
        
    }
    
    func sendMessageWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("message")
        let childRef = ref.childByAutoId()
        let messageId = childRef.key
        let toId = user != nil ? userDefault.string(forKey: "UserID") : userDefault.string(forKey: "GroupID")
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let negativeTimeStamp: NSNumber = NSNumber(value: -(Int(NSDate().timeIntervalSince1970)))
        var messageStatus: String?
        
        if toId == userDefault.string(forKey: "UserID") {
            let userRef = Database.database().reference().child("user").child(toId!)
            userRef.observeSingleEvent(of: .value, with: {( DataSnapshot) in
                let dictionary = DataSnapshot.value as! [String: AnyObject]
                let lastTimeLoggin = dictionary["lastTimeLoggin"] as! NSNumber
                let lastTimeLogout = dictionary["lastTimeLogout"] as! NSNumber
                let chattingWith = dictionary["chattingWith"] as! String
                
                if chattingWith == fromId {
                    messageStatus = "Seen"
                } else
                { if Int(lastTimeLoggin) <= Int(lastTimeLogout) {
                    messageStatus = "Sent"
                } else if Int(lastTimeLoggin) > Int(lastTimeLogout) {
                    messageStatus = "Received"
                    } }
                
                var values = ["toId": toId!, "fromId": fromId, "timeStamp": timeStamp, "negativeTimeStamp": negativeTimeStamp, "messageId": messageId, "messageStatus": messageStatus!] as [String : AnyObject]
                
                //append properties dictionary on to values
                //key $0, value $1
                properties.forEach({values[$0] =  $1})
                
                childRef.updateChildValues(values, withCompletionBlock: {
                    (error ,ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                        let userMessaegRef1 = Database.database().reference().child("user-message").child(fromId).child(toId!)
                        let userMessaegRef2 = Database.database().reference().child("user-message").child(toId!).child(fromId)
                        userMessaegRef1.updateChildValues([messageId: 1])
                        userMessaegRef2.updateChildValues([messageId: 1])
                    
                })

            })
        }   else if toId == userDefault.string(forKey: "GroupID") {
            var values = ["toId": toId!, "fromId": fromId, "timeStamp": timeStamp, "negativeTimeStamp": negativeTimeStamp, "messageId": messageId, "messageStatus": "Sent"] as [String : AnyObject]
            properties.forEach({values[$0] =  $1})
            
            childRef.updateChildValues(values, withCompletionBlock: {
                (error ,ref) in
                if error != nil {
                    print(error!)
                    return
                }
            let groupUsersRef = Database.database().reference().child("group-users").child(toId!)
            let userMessageRef2 = Database.database().reference().child("user-message").child(toId!)
            groupUsersRef.updateChildValues([fromId: 1])
            userMessageRef2.updateChildValues([messageId: 1])
            
            groupUsersRef.observe(.childAdded, with: {
                (DataSnapshot) in
                let userId = DataSnapshot.key
                let userMessaegRef1 = Database.database().reference().child("user-message").child(userId).child(toId!)
                userMessaegRef1.updateChildValues([messageId: 1])
            }, withCancel: nil)
            })
        }
    }
        
    //custom zooming logic
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        startingImageView.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.blue
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.removeFromSuperview()
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseInOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
        
    }
    
    func handleZoomOut(tapGesture: UIPanGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            // need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.removeFromSuperview()
                self.inputContainerView.alpha = 1
            }, completion: { [unowned self] (completion: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
        
    func setupRightBarItem() {
        let moreImage = UIImage(named: "rsz_threedots")?.withRenderingMode(.alwaysTemplate)
        //        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: nil)

        let callImage = UIImage(named: "call_icon_rsz")?.withRenderingMode(.alwaysTemplate)
        let callButtonItem = UIBarButtonItem(image: callImage, style: .plain, target: self, action: nil)
        
        let videoCallImage = UIImage(named: "camera_icon_rsz")?.withRenderingMode(.alwaysTemplate)
        let videoCallButtonItem = UIBarButtonItem(image: videoCallImage, style: .plain, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem,videoCallButtonItem,callButtonItem]
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

    }
    
    func handleProfile() {
    }
    
    func setupLeftBarItem() {
        
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "back_arrow2")?.withRenderingMode(.alwaysTemplate)
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.setTitle("", for: .normal);
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        
        
        let userName = UILabel()
        if user != nil {
            userName.text = user?.name } else
        { userName.text = group?.name }
        userName.textColor = UIColor.white
        userName.font = UIFont.systemFont(ofSize: 16)
        userName.translatesAutoresizingMaskIntoConstraints = false

        let statusName = UILabel()
        statusName.text = "Online Just Now"
        statusName.textColor = UIColor.lightText
        statusName.font = UIFont.systemFont(ofSize: 12)
        statusName.translatesAutoresizingMaskIntoConstraints = false
        
        let labelName = UIButton()
        labelName.backgroundColor = UIColor.clear
        labelName.frame = CGRect(x: 50, y: 20, width: 150, height: 40)
        labelName.addSubview(userName)
        if user != nil {
            labelName.addSubview(statusName)
            statusName.anchor(nil, left: labelName.leftAnchor, bottom: labelName.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 19)
            labelName.addTarget(self, action: #selector(showProfileContainer), for: .touchUpInside) }
        
        userName.anchor(labelName.topAnchor, left: labelName.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 19)
        
//        statusName.anchor(nil, left: labelName.leftAnchor, bottom: labelName.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 19)
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelButton = UIBarButtonItem(customView: labelName)
        navigationItem.leftBarButtonItems = [barButton, nameLabelButton]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }

}
