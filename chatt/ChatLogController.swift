//
//  ChatLogController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/26.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import SVProgressHUD
import LBTAComponents

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
     var user: User? {
        didSet {
            navigationItem.title = ""
        }
    }
    
    var group: Group?
    var messageIdArray = [String]()
    var width: CGFloat = UIScreen.main.bounds.width / 4
    var message: Message?
    var indexPath: IndexPath?
    var indexPath2: IndexPath?
    var detailUserName: String?
    
    var messages = [Message]()
    weak var containerViewBottomAnchor: NSLayoutConstraint?
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    weak var startingImageView: UIImageView?
    
    lazy var messageOptionsContainer = UIView()
    lazy var replyButton = UIButton()
    lazy var copyButton = UIButton()
    lazy var shareButton = UIButton()
    lazy var detailbutton = UIButton()
    lazy var deleteButton = UIButton()
    lazy var recallButton = UIButton()
    lazy var upperStackView = UIStackView()
    
    lazy var imageChooseButton = UIButton()
    lazy var voiceMessageButton = UIButton()
    lazy var locationButton = UIButton()
    lazy var handWrittenMessageButton = UIButton()
    lazy var cancelButton = UIButton()
    lazy var mediaOptionsContainer = UIStackView()
    lazy var mediaNameContainer = UILabel()
    lazy var upperView = UIView()
    lazy var totalView = UIView()
    
    lazy var typingLabel = UILabel()
        
    lazy var profileContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    lazy var profileSection: UIButton = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var chatImagesSection: UIButton = {
        let button = UIButton()
        button.setTitle("Chat Images", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var playSoundSection: UIButton = {
        let button = UIButton()
        button.setTitle("Play Sound on Speaker", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 12, -8, 0)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var voiceChatSection: UILabel = {
        let label = UILabel()
        label.text = "For voice chat"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy  var separatorLine1: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var separatorLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var arrowImageView1: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var arrowImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var switchView: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.setOn(true, animated: true)
        mySwitch.onTintColor = UIColor(r: 32, g: 32, b: 220)
        mySwitch.tintColor = UIColor(r: 245, g: 245, b: 245)
        mySwitch.thumbTintColor = UIColor.white
        mySwitch.backgroundColor = UIColor.clear
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
//    mySwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
    return mySwitch
    }()

    lazy var photoLibraryController: PhotoLocationController = {
        let photoLibrary = PhotoLocationController()
        return photoLibrary
    }()
    
    var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.lightGray
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    lazy var separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()

    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "send")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var sendButton2: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "rsz_plus")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleChoosePhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
     var uploadImageView: UIImageView = UIImageView()
     var presenceRef = Database.database().reference(withPath: "user/\(String(describing: Auth.auth().currentUser?.uid) )/checkOnline")
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(CGFloat((collectionView?.contentOffset.y)!))
    }
    
    func setupChattingWithWhom() {
        if let uid = Auth.auth().currentUser?.uid {
        let ref = Database.database().reference(withPath: "user/\(uid)/chattingWith")
            if user != nil {
               ref.setValue(user?.id)
            } else if user == nil {
                ref.setValue(group?.id)
    }
        }
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChattingWithWhom()
        self.initViewContrller()
        self.view.addSubview(typingLabel)
        
        profileSection.addTarget(self, action: #selector(pushProfile), for: .touchUpInside)
        
        UserDefaults.standard.setValue(user?.id, forKey: "UserID")
        UserDefaults.standard.set(group?.id, forKey: "GroupID")
        self.navigationItem.hidesBackButton = true
        
        sendButton2.isHidden = false
        sendButton.isHidden = true
        inputTextView.delegate = self
        inputTextView.text = "Write Message"
        inputTextView.textColor = UIColor.lightGray
        inputTextView.textContainerInset = UIEdgeInsetsMake(7, 0, 0, 0)
        
        observeUserMessage()
        setupTypingLabel()
        setupTextView()
        self.hideKeyboardWhenTappedAround(bool: true)
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        uploadImageView.isUserInteractionEnabled = true
        
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 86, right: 0)
//
//        collectionView?.collectionViewLayout = layout
        collectionView?.contentInset = UIEdgeInsetsMake(8,0,40,0)
//        collectionView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
        collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView!.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UserFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView?.alwaysBounceVertical = true
//        collectionView?.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        self.view.backgroundColor = UIColor.clear
        
        view.addSubview(inputContainerView)
        setupInputContainerView()
        setupKeyBoardObservers()
        setupLeftBarItem()
        setupRightBarItem()
        
    }
    
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    deinit {
    }
    
    func initViewContrller()
    {
        self.uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "camera")
        uploadImageView.contentMode = .scaleAspectFit
        uploadImageView.layer.masksToBounds = true
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pushProfile() {
        pushProfile2(sender: "ChatLogController")
    }
    
    func pushProfile2(sender: String) {
        let myProfileController = MyProfileController()
        myProfileController.user = user
        navigationController?.pushViewController(myProfileController, animated: true)
        if sender == "ChatLogController" {
            self.handleProfileDismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("user-message").child(uid).removeAllObservers()
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var inputContainerBottomAnchor: NSLayoutConstraint?
    
    func setupInputContainerView(){
        inputContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputContainerBottomAnchor = inputContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        inputContainerBottomAnchor?.isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 50)
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(sendButton)
        inputContainerView.addSubview(sendButton2)
        inputContainerView.addSubview(uploadImageView)
        inputContainerView.addSubview(inputTextView)
        inputContainerView.addSubview(separatorLineView)
        
        //x,y,w,h
        
        self.uploadImageView.anchor(nil, left: inputContainerView.leftAnchor, bottom: inputContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 5, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        
        //x,y,w,h
        
        sendButton.anchor(nil, left: nil, bottom: inputContainerView.bottomAnchor, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 40, heightConstant: 40)
        
        sendButton2.anchor(nil, left: nil, bottom: inputContainerView.bottomAnchor, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 40, heightConstant: 40)
        
        separatorLineView.anchor(inputContainerView.topAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        inputTextView.anchor(inputContainerView.topAnchor, left: uploadImageView.rightAnchor, bottom: inputContainerView.bottomAnchor, right: sendButton.leftAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setupTextView() {
            inputTextView.scrollsToTop = true
            inputTextView.isScrollEnabled = true
            inputTextView.addObserver(self, forKeyPath: "contentSize", options:[ NSKeyValueObservingOptions.old , NSKeyValueObservingOptions.new], context: nil)
    }
    
    var i: Int = 0
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  inputTextView.textColor == UIColor.lightGray && inputTextView.text == "Write Message" {
            inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
            inputTextView.text = "Write Message"
            inputTextView.textColor = .lightGray
            sendButton2.isHidden = false
            sendButton.isHidden = true
        }
        inputTextView.textColor = .lightGray
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = inputTextView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range as NSRange, with: text)

        if (updatedText?.isEmpty)! {
            sendButton2.isHidden = false
            sendButton.isHidden = true
            inputTextView.text = "Write Message"
            inputTextView.textColor = UIColor.lightGray
            inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
            return true
        }
            
        else if inputTextView.textColor == UIColor.lightGray && !text.isEmpty {
            inputTextView.text = nil
            if let uid = Auth.auth().currentUser?.uid {
                let typingCheckRef = Database.database().reference(withPath: "user/\(uid)/isTypingCheck")
                typingCheckRef.setValue("true")
                observeUserTypingChange(value: 2)
            }
            inputTextView.textColor = UIColor.darkText
            sendButton2.isHidden = true
            sendButton.isHidden = false
             return true
        }

        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if inputTextView.text.isEmpty {
            inputTextView.text = "Write Message"
            inputTextView.textColor = UIColor.lightGray
            sendButton2.isHidden = false
            sendButton.isHidden = true
        }
    }
    
    func observeUserTypingChange(value: NSNumber) {
        let ref = Database.database().reference().child("group-users")
        ref.observe(.childAdded, with: {
            (DataSnapshot) in
            let groupId = DataSnapshot.key
            let groupRef = Database.database().reference().child("group-users").child(groupId)
            groupRef.observe(.childAdded, with: {
                (DataSnapshot) in
                let userId = DataSnapshot.key
                if userId == Auth.auth().currentUser?.uid {
                    let valueRef = Database.database().reference(withPath: "group-users/\(groupId)/\(userId)")
                    valueRef.setValue(value)
                }
            })
        })
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if inputTextView.textColor == UIColor.lightGray && inputTextView.text == "Write Message" {
                inputTextView.selectedTextRange = inputTextView.textRange(from: textView.beginningOfDocument, to: inputTextView.beginningOfDocument)
                inputTextView.text = "Write Message"
                inputTextView.textColor = .lightGray
                if let uid = Auth.auth().currentUser?.uid {
                    let typingCheckRef = Database.database().reference(withPath: "user/\(uid)/isTypingCheck")
                    typingCheckRef.setValue("false")
                    observeUserTypingChange(value: 1)
                }
                sendButton2.isHidden = false
                sendButton.isHidden = true
            } else if inputTextView.textColor == UIColor.lightGray && inputTextView.text != "Write Message" {
                inputTextView.textColor = UIColor.darkText
            }
        }
    }
    
    let cellId = "cellId"
    let footerId = "footerId"
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 18
        } else {if let imageWidth = message.imageWidth?.floatValue , let imageHeight = message.imageHeight?.floatValue {
            
            height = CGFloat(imageHeight / imageWidth * 200) } else {
            
            height = 50
            }
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 220, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
        var messageRef: Message?
    
    lazy var textLabel = UILabel()
    
    func setupTextLabel(message: Message) {
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .center
        textLabel.textColor = twitterBlue
        textLabel.backgroundColor = .lightGray
        textLabel.layer.cornerRadius = 10
        textLabel.clipsToBounds = true
        
        if self.messages.count > 0 && self.messages[messages.count - 1].fromId == Auth.auth().currentUser?.uid {
            self.textLabel.alpha = 1
            self.textLabel.text = message.messageStatus
        } else if self.messages.count == 0 || self.messages[messages.count - 1].fromId != Auth.auth().currentUser?.uid{
            self.textLabel.alpha = 0
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! UserFooter
        footer.addSubview(textLabel)
        textLabel.anchor(footer.topAnchor, left: nil, bottom: footer.bottomAnchor, right: footer.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 6, rightConstant: 14, widthConstant: 80, heightConstant: 0)

        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    func adddGestureRecognizer(cell: ChatMessageCell) {
        let longPress = UILongPressGestureRecognizer()
        let press = UITapGestureRecognizer()
        
        longPress.addTarget(self, action: #selector(handleLongTap(sender:)))
        cell.textView.addGestureRecognizer(longPress)
        //        cell.messageImageView.addGestureRecognizer(longPress)
        press.addTarget(self, action: #selector(pushProfile))
        cell.profileImageView.addGestureRecognizer(press)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        adddGestureRecognizer(cell: cell)
        cell.chatLogController = self
        
        let message1 = self.messages[indexPath.item]
        cell.message = message1
        cell.textView.text = message1.text
        var message2: Message
        
        if self.messages.count == 1 {
            message2 = self.messages[0]
        } else {
            if indexPath.item == 0 {
                message2 = message1
            } else {
                message2 = self.messages[indexPath.item - 1] }
        }
        
        if let text = message1.text {
            cell.bubbleWidthAnchor?.constant = self.estimateFrameForText(text: text).width + 28
            cell.textView.isHidden = false
        } else { if message1.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        } else {
            if message1.audioUrl != nil {
                cell.bubbleWidthAnchor?.constant = 110
                cell.bubbleView.backgroundColor = UIColor.clear
                cell.textView.isHidden = true
                cell.messageImageView.isHidden = true
                cell.PlayAudioBTN.isHidden = false
                cell.audioDurationLabel.isHidden = false
                if let durationSeconds = message1.audioDuration {
                    let secondsText = Int(durationSeconds) % 60
                    
                    let minutesText = Int(durationSeconds) / 60
                    
                    cell.audioDurationLabel.text = String(format: "%02d : %02d", minutesText ,secondsText)
                }
            }
            } }
        self.setupCell(cell: cell, message1: message1, message2: message2)
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message1: Message, message2: Message) {
        if self.user != nil {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            cell.profileImageView.isHidden = true
            } }
           else if self.user == nil {
            if message1.fromId != Auth.auth().currentUser?.uid {
                let userRef = Database.database().reference().child("user").child(message1.fromId!)
                userRef.observeSingleEvent(of: .value, with: {
                    (DataSnapshot) in
                    guard let dictionary = DataSnapshot.value as? [String: AnyObject] else {
                        return
                    }
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] {
                    cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl as! String)
//                        cell.profileImageView.isHidden = true
                    }
                })
            }
        }
        
        if message1.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blue
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g:240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleViewRightAnchor?.isActive = false
            if message2.timeStamp == message1.timeStamp {
                cell.profileImageView.isHidden = false
            } else {
                if message1.toId == message2.toId && message1.fromId == message2.fromId{
                    cell.profileImageView.isHidden = true
                } else {
                    cell.profileImageView.isHidden = false
                    
                } }
        }
        
        if let messageImageUrl = message1.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        cell.playButton.isHidden = message1.videoUrl == nil
        cell.PlayAudioBTN.isHidden = message1.audioUrl == nil
        cell.audioDurationLabel.isHidden = message1.audioDuration == nil
        
        if message1.text == "Message has been recalled" && message1.fromId == Auth.auth().currentUser?.uid {
            cell.textView.textColor = .lightGray
        } else if message1.text == "Message has been recalled" && message1.fromId != Auth.auth().currentUser?.uid {
            cell.textView.textColor = .blue
        }
    }
    
    lazy var blackView = UIView()
    lazy var brightView = UIView()
    
    let userDefault = UserDefaults.standard
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillEnd), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            inputContainerBottomAnchor?.constant = -(keyboardHeight)
            self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width
                , height: self.view.frame.height - keyboardRectangle.height - 50)
            collectionViewScroll()
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    let keyboardHeight: CGFloat = UserDefaults.standard.value(forKey: "keyboardHeight") as! CGFloat
    
    func handleKeyboardDidShow(_ notification: Notification) {
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width
            , height: self.view.frame.height - keyboardHeight - 50)
        collectionViewScroll()
    }
    
    func handleKeyboardWillEnd(_ notification: Notification) {
           let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        inputContainerBottomAnchor?.constant = 0
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width
            , height: UIScreen.main.bounds.height - 50)
            UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func collectionViewScroll() {
        if messages.count > 0 {
            let indexPath = NSIndexPath(item: messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            self.view.layoutIfNeeded() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }

}


