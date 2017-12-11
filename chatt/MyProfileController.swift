//
//  MyProfileController.swift
//  ChatApp
//
//  Created by DevOminext on 11/23/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import LBTAComponents
import Firebase

class MyProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate {
    
    let height = UIScreen.main.bounds.height / 2 + 100
    var user: User?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var btnLeftMenu: UIButton = {
       let button = UIButton()
       let  image = UIImage(named: "back_arrow2")?.withRenderingMode(.alwaysTemplate)
    button.setImage(image, for: .normal)
    button.imageView?.tintColor = .white
    button.setTitle("", for: .normal);
    button.sizeToFit()
        return button
    }()
    
    lazy var statusWritingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 250, g:250, b:250)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setImage(UIImage(named: "imageicon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blue
        button.setTitle("What are you thinking?", for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0,-8,0,0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.isHidden = true
        return button
    }()
    
    lazy var backgroundImageView: UIImageView = {
       let imageView = UIImageView()
//        imageView.image = UIImage(named: "AKB48")
        return imageView
    }()
    
    lazy var imageContainer: ProfileController = {
       let view = ProfileController()
        return view
    }()
    let statusBar = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .blue
        self.statusBar.backgroundColor = .blue
        self.statusBar.alpha = 0
        
        self.view.addSubview(statusBar)
        
        statusBar.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        self.navigationController?.view.addSubview(btnLeftMenu)
        btnLeftMenu.alpha = 1
        btnLeftMenu.anchor(self.navigationController?.view.topAnchor, left: self.navigationController?.view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)

        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = true

        self.statusBar.alpha = 1
        btnLeftMenu.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageContainer.user = user
        
        view.addSubview(backgroundImageView)
        view.addSubview(imageContainer.view)
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(statusWritingButton)
        self.view.layer.addSublayer(gradientLayer)
        
        if user?.backgroundImageUrl != nil {
            self.backgroundImageView.loadImageUsingCacheWithUrlString(urlString: (user?.backgroundImageUrl)!)
        } else { backgroundImageView.image = UIImage()}
        
        if user?.email?.uppercased()  == Auth.auth().currentUser?.email?.uppercased() {
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileActionSheetShow)))
            backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundActionSheetShow)))
            statusWritingButton.isHidden = false

            
        }

        setupContainerWithUser(user: user!)
        self.view.backgroundColor = .white
        setupImage()
        btnLeftMenu.addTarget(self, action: #selector (backButtonClick), for: .touchUpInside)
        statusWritingButton.addTarget(self, action: #selector (showStatusController), for: .touchUpInside)
        
        imageContainer.tabBarContainer.collectionView?.isScrollEnabled = false
        imageContainer.tabBarContainer2.collectionView?.isScrollEnabled = false
    }
    
    func showStatusController() {
        let statusController = WritingStatusController()
        self.present(statusController, animated: true, completion: nil)
    }
    
    let gradientLayer = CAGradientLayer()
    
    private var checkImageSource: Int?
    
    func backgroundActionSheetShow() {
        let actionSheet = UIAlertController.init(title: "Cover", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
            self.handleUploadTap(sourceName: "background",index: 1)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Choose From Photos", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
            
            self.handleUploadTap(sourceName: "background",index: 0)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func profileActionSheetShow() {
        let actionSheet = UIAlertController.init(title: "Avatar", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "View Profile Picture", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
            self.handleZoomTap()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
            self.handleUploadTap(sourceName: "profile",index: 1)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Choose From Photos", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
            self.handleUploadTap(sourceName: "profile",index: 0)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    
    func handleZoomTap() {
        
        let imageView = self.profileImageView
            self.chatLogController.performZoomInForStartingImageView(startingImageView: imageView)
    }
    
    func handleUploadTap(sourceName: String, index: Int) {
            let imagePickerController = UIImagePickerController()
            
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        if index == 0 {
            imagePickerController.sourceType = .photoLibrary }
        if index == 1 {
            imagePickerController.sourceType = .camera
        }
        if sourceName == "profile" {
            checkImageSource = 0
        } else if sourceName == "background" {
            checkImageSource = 1
        }
            
            present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if checkImageSource == 1 {
            self.backgroundImageView.image = pickedImage
            self.backgroundImageView.contentMode = .scaleToFill }
        if checkImageSource == 0 {
            self.profileImageView.image = pickedImage
            self.profileImageView.contentMode = .scaleToFill
        }
        self.uploadToFirebaseStorageUsingImage(image: pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("myImage").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            ref.putData(uploadData, metadata: nil, completion: {
                (metadata, error) in
                if error != nil {
                    print("Failed to upload data", error!)
                    return
                }
                if let backgroundImageUrl = metadata?.downloadURL()?.absoluteString {
                    if let uid = Auth.auth().currentUser?.uid {
                        if self.checkImageSource == 1 {
                            let presenceRef = Database.database().reference(withPath: "user/\(uid)/backgroundImageUrl")
                        presenceRef.setValue(backgroundImageUrl)}
                        if self.checkImageSource == 0 {
                            let presenceRef = Database.database().reference(withPath: "user/\(uid)/profileImageUrl")
                            presenceRef.setValue(backgroundImageUrl)
                        }
                    }
                }
            })        }
    }
    
    
    func setupImage() {
        
        profileImageView.isUserInteractionEnabled = true
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: height))
        
        let gesture1 = UIPanGestureRecognizer(target: self, action: #selector(wasDragged1(recognizer
            :)))
        self.imageContainer.view.addGestureRecognizer(gesture1)
        gesture1.delegate = self as? UIGestureRecognizerDelegate
        
        let gesture2 = UIPanGestureRecognizer(target: self, action: #selector(wasDragged2(recognizer
            :)))
        self.backgroundImageView.addGestureRecognizer(gesture2)
        gesture2.delegate = self as? UIGestureRecognizerDelegate
        
        imageContainer.view.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: height - 150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.height - 20)

        backgroundImageView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: -20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)

        profileImageView.anchor(nil, left: self.view.leftAnchor, bottom: self.imageContainer.view.topAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 50, heightConstant: 50)

        userNameLabel.anchor(self.profileImageView.topAnchor, left: self.profileImageView.rightAnchor, bottom: self.profileImageView.bottomAnchor, right: nil, topConstant: 16, leftConstant: 8, bottomConstant: 16, rightConstant: 0, widthConstant: 250, heightConstant: 20)
        
        statusWritingButton.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7,1.2]
        
    }
    
    func setupContainerWithUser(user: User) {
        userNameLabel.text = user.name
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
    }
    
    func wasDragged1(recognizer:UIPanGestureRecognizer){
        if imageContainer.view.frame.minY <= height - 150 {
            let translation = recognizer.translation(in: view)
        if recognizer.state == .changed {
            self.navigationController?.navigationBar.backgroundColor = .blue
            
            let percentage: CGFloat = (imageContainer.view.frame.minY - 64)/(height - 214)

            self.navigationController?.navigationBar.alpha = 1 - percentage
            self.statusBar.alpha = 1 - percentage
            imageContainer.view.center.y += translation.y
            backgroundImageView.center.y += translation.y
            profileImageView.center.y += translation.y
            userNameLabel.center.y += translation.y
            statusWritingButton.center.y -= translation.y
            
            if statusWritingButton.frame.maxY <= UIScreen.main.bounds.height {
                self.statusWritingButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 45, width: self.view.frame.width, height: 45)
            }
            
            if imageContainer.view.frame.minY <= 20 {
                imageContainer.tabBarContainer.collectionView?.isScrollEnabled = true
                imageContainer.tabBarContainer2.collectionView?.isScrollEnabled = true
                self.imageContainer.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
            }
            
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
            }
        } else if imageContainer.view.frame.minY >= height - 150 {
            if recognizer.state == .changed {
                let translation = recognizer.translation(in: view)
                
                imageContainer.view.center.y += translation.y / 2
                profileImageView.center.y += translation.y / 2
                userNameLabel.center.y += translation.y / 2
                backgroundImageView.center.y += translation.y / 6
                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
                imageContainer.tabBarContainer.collectionView?.isScrollEnabled = false
                imageContainer.tabBarContainer2.collectionView?.isScrollEnabled = false
            }
            
            if recognizer.state == .ended {
                backUpView()
            }
        }
    }
    
    func wasDragged2(recognizer:UIPanGestureRecognizer){
        
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
        
            imageContainer.view.center.y += translation.y / 2
            profileImageView.center.y += translation.y / 2
            userNameLabel.center.y += translation.y / 2
            backgroundImageView.center.y += translation.y / 6
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
        }
        
        if recognizer.state == .ended {
            backUpView()
        }
    }
    
    func backUpView() {
        self.backgroundImageView.frame = CGRect(x: 0, y: -20, width: self.view.frame.width, height: height)
        
        self.imageContainer.view.frame = CGRect(x: 0, y: height - 150, width: self.view.frame.width, height: self.view.frame.height - 20)
        
        self.profileImageView.frame = CGRect(x: 8, y: height - 208, width: 50, height: 50)
        
        self.userNameLabel.frame = CGRect(x: 66, y: height - 190, width: 250, height: 20)
    }
    
    func backButtonClick() {
        
        self.navigationController?.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        self.navigationController?.popoverPresentationController?.sourceView = self.view
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}
