//
//  WritingStatusController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/25.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import LBTAComponents

class WritingStatusController: UIViewController, UITextViewDelegate {
    lazy var keyboardHeight: CGFloat = CGFloat(UserDefaults.standard.float(forKey: "keyboardHeight"))
    
    lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        return view
    }()
    
    lazy var containerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy var statusTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Write your thought here..."
        textView.textColor = UIColor.lightGray
       textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
       return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "send")
        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "StatusCamera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addVC1), for: .touchUpInside)
        return button
    }()
    
    lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "picture_icon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addVC2), for: .touchUpInside)
        return button
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "StatusMicro")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addVC3), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageUrl: String!
    
    func handleSend() {
        self.dismiss(animated: true, completion: nil)

        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("statusImages").child("\(imageName).jpg")
        
        if let image = self.statusImageView.image, let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }

                let statusImageUrl = metadata?.downloadURL()?.absoluteString
                var statusText = self.statusTextView.text
                
                if statusImageUrl != nil && statusText != nil && self.statusTextView.textColor == .darkText {
                    self.sendMessageWithImageUrlAndText(statusImageUrl: statusImageUrl!, statusText: statusText!)
                }
                
                if self.i == 1 {
                    self.sendMessageWithOnlyText(statusText: statusText!)
                }
                
                if statusImageUrl != nil && (statusText == nil || self.statusTextView.textColor == .lightGray) {
                    statusText = nil
                    self.sendMessageWithOnlyImageUrl(statusImageUrl: statusImageUrl!)
                }
            }    )
        }
    }
    
    func sendMessageWithOnlyImageUrl(statusImageUrl: String) {
        let properties: [String: AnyObject] = ["statusImageUrl": statusImageUrl as AnyObject]
        sendMessageWithProperties2(properties: properties)
    }
    
    func sendMessageWithOnlyText(statusText: String) {
        let properties: [String: AnyObject] = ["statusText": statusText as AnyObject]
        sendMessageWithProperties2(properties: properties)
    }
    
    func sendMessageWithImageUrlAndText(statusImageUrl: String, statusText: String) {
        let properties: [String: AnyObject] = ["statusImageUrl": statusImageUrl, "statusText": statusText] as [String : AnyObject]
        sendMessageWithProperties2(properties: properties)
    }
    
    func sendMessageWithProperties2(properties: [String: AnyObject]) {
        let uid = Auth.auth().currentUser?.uid
        let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        var name: String?
        var profileImageUrl: String?
        Database.database().reference().child("user").child(uid!).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                name = user.name
                profileImageUrl = user.profileImageUrl
                
                var values = ["name": name ?? "", "profileImageUrl": profileImageUrl ?? "", "timeStamp": timeStamp as AnyObject] as [String: AnyObject]
                
                properties.forEach({values[$0] = $1})
                
                let ref = Database.database().reference().child("user-status").child(uid!)
                let childRef = ref.childByAutoId()
                childRef.updateChildValues(values, withCompletionBlock: { (error ,ref) in
                    if error != nil {
                        print(error!)
                        return
                    } } )
            }
            }, withCancel: nil)
    }
    
    func addVC1() {
        statusTextView.endEditing(true)
        cameraButton.tintColor = .purple
        imageButton.tintColor = .blue
        voiceButton.tintColor = .blue
        audioRecorder.view.removeFromSuperview()
        profileImageView.alpha = 1
        statusPhotos.view.removeFromSuperview()
    }
    
    lazy var statusPhotos = StatusPhotosController(collectionViewLayout: UICollectionViewFlowLayout())
    let audioRecorder = AudioRecordedController()
    
    func addVC2() {
        statusTextView.endEditing(true)
        cameraButton.tintColor = .blue
        imageButton.tintColor = .purple
        voiceButton.tintColor = .blue
        audioRecorder.view.removeFromSuperview()
        profileImageView.alpha = 0
        statusPhotos.view.alpha = 1
        self.addChildViewController(statusPhotos)
        self.view.addSubview(statusPhotos.view)
        statusPhotos.didMove(toParentViewController: self)
        statusPhotos.view.anchor(self.containerView2.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func addVC3() {
        statusTextView.endEditing(true)
        cameraButton.tintColor = .blue
        imageButton.tintColor = .blue
        voiceButton.tintColor = .purple
        audioRecorder.view.alpha = 1
        statusPhotos.view.removeFromSuperview()
        profileImageView.alpha = 0
        self.addChildViewController(audioRecorder)
        self.view.addSubview(audioRecorder.view)
        audioRecorder.didMove(toParentViewController: self)
        audioRecorder.view.anchor(self.containerView2.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  statusTextView.textColor == UIColor.lightGray {
            statusTextView.selectedTextRange = statusTextView.textRange(from: statusTextView.beginningOfDocument, to: statusTextView.beginningOfDocument)
            statusTextView.text = "Write your thought here..."
            statusTextView.isHidden = false
            sendButton.isEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = statusTextView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range as NSRange, with: text)
        
        if (updatedText?.isEmpty)! {
            sendButton.isEnabled = false
            statusTextView.text = "Write your thought here..."
            statusTextView.textColor = UIColor.lightGray
            statusTextView.selectedTextRange = statusTextView.textRange(from: statusTextView.beginningOfDocument, to: statusTextView.beginningOfDocument)
            return true
        }
            
        else if statusTextView.textColor == UIColor.lightGray && !text.isEmpty {
            statusTextView.text = nil
            statusTextView.textColor = UIColor.darkText
            sendButton.isEnabled = true
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if statusTextView.text.isEmpty {
            statusTextView.text = "Write your thought here..."
            statusTextView.textColor = UIColor.lightGray
            sendButton.isEnabled = false
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if statusTextView.textColor == UIColor.lightGray {
                statusTextView.selectedTextRange = statusTextView.textRange(from: textView.beginningOfDocument, to: statusTextView.beginningOfDocument)
                statusTextView.text = "Write your thought here..."
                sendButton.isEnabled = false
            }
        }
    }
    var i: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        i = 0
        statusPhotos.delegate = self
        cameraButton.tintColor = .purple
        self.view.backgroundColor = .green
        sendButton.isEnabled = false
        statusTextView.delegate = self
        
        view.addSubview(containerView)
        view.addSubview(cancelButton)
        view.addSubview(statusTextView)
        view.addSubview(sendButton)
        view.addSubview(containerView2)
        view.addSubview(profileImageView)
        view.addSubview(statusImageView)
        containerView2.addSubview(cameraButton)
        containerView2.addSubview(imageButton)
        containerView2.addSubview(voiceButton)
        
        cancelButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        setupSubView()
    }
    
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupSubView() {
    containerView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 64)
    cancelButton.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.containerView.bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 69, heightConstant: 44)
    statusTextView.anchor(self.containerView.bottomAnchor, left: self.view.leftAnchor, bottom: containerView2.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    sendButton.anchor(nil, left: nil, bottom: self.containerView.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 6, rightConstant: 8, widthConstant: 30, heightConstant: 30)
    containerView2.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: keyboardHeight, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    voiceButton.anchor(self.containerView2.topAnchor, left: nil, bottom: self.containerView2.bottomAnchor, right: self.containerView2.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 8, widthConstant: 35, heightConstant: 0)
    imageButton.anchor(self.containerView2.topAnchor, left: nil, bottom: self.containerView2.bottomAnchor, right: self.voiceButton.leftAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 8, widthConstant: 50, heightConstant: 0)
    cameraButton.anchor(self.containerView2.topAnchor, left: nil, bottom: self.containerView2.bottomAnchor, right: self.imageButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 50, heightConstant: 0)
    profileImageView.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: self.view.frame.width/2 - 50, bottomConstant: keyboardHeight/2 - 50, rightConstant: self.view.frame.width/2 - 50, widthConstant: 0, heightConstant: 100)
    statusImageView.anchor(nil, left: self.view.centerXAnchor, bottom: self.containerView2.topAnchor, right: nil, topConstant: 0, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
    }
}

extension WritingStatusController: StatusPhotosControllerDelegate {
    func selectImage(image: UIImage) {
        self.statusImageView.image = image
        self.sendButton.isEnabled = true
        i = i! + 1
    }
    func getImageUrl(imageUrl: String) {
        print(imageUrl)
        self.imageUrl = imageUrl
    }
}

