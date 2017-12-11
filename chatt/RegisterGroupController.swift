//
//  RegisterGroupController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/12/08.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterGroupController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    lazy var groupNameLabel = UILabel()
    lazy var groupNameTextField = UITextField()
    lazy var choosePhotoButton = UIButton()
    lazy var groupImageView = UIImageView()
    lazy var registerButton = UIButton()
    lazy var cancelButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        setupViews()
    }
    
    func setupViews() {
        groupNameLabel.text = "Group Name"
        groupNameTextField.placeholder = "Enter your group name"
        groupNameTextField.backgroundColor = .white
        
        choosePhotoButton.setTitle("Choose Photo", for: .normal)
        choosePhotoButton.setTitleColor(.darkText, for: .normal)
        choosePhotoButton.backgroundColor = .white
        choosePhotoButton.addTarget(self, action: #selector(handleChoosePhoto), for: .touchUpInside)
        
        groupImageView.image = UIImage(named: "avatar")
        
        registerButton.setTitle("Create", for: .normal)
        registerButton.setTitleColor(.darkText, for: .normal)
        registerButton.backgroundColor = .white
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.darkText, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        view.addSubview(groupNameLabel)
        view.addSubview(groupNameTextField)
        view.addSubview(choosePhotoButton)
        view.addSubview(groupImageView)
        view.addSubview(registerButton)
        view.addSubview(cancelButton)
        
        groupNameLabel.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        
        groupNameTextField.anchor(self.view.topAnchor, left: self.groupNameLabel.rightAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 50, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 50)
        
        choosePhotoButton.anchor(self.groupNameLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 50)
        
        groupImageView.anchor(self.groupNameTextField.bottomAnchor, left: self.choosePhotoButton.rightAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 150)
        
        registerButton.anchor(self.groupImageView.bottomAnchor, left: self.groupImageView.centerXAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        
        cancelButton.anchor(self.registerButton.bottomAnchor, left: self.registerButton.leftAnchor, bottom: nil, right: self.registerButton.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    @objc private func handleChoosePhoto() {
        let actionSheet = UIAlertController.init(title: "Group Image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default, handler: {  (action) in
            self.pickerShow(index: 1)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Choose From Photos", style: UIAlertActionStyle.default, handler: {  (action) in
            
            self.pickerShow(index: 0)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleRegister() {
        let imageName = NSUUID().uuidString
        let groupId = "Group" + NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("myImage").child("\(imageName).jpg")
        
        if let image = self.groupImageView.image, let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { [unowned self] (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString, let groupName = self.groupNameTextField.text  {
                    let values = ["id": groupId, "name": groupName, "profileImageUrl": profileImageUrl]
                    
                    self.registerGroupIntoDatabaseWithGroupID(groupId: groupId, values: values as [String : AnyObject])
                    
                }                }    )
        }
    }
    
    func registerGroupIntoDatabaseWithGroupID(groupId: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let groupsReference = ref.child("group").child(groupId)
        groupsReference.updateChildValues(values, withCompletionBlock: {
            [weak self] (err,ref) in
            if err != nil {
                print(err!)
                return
            }
            
            self?.handleDismiss()
        })
        
//        let groupUsersReference = ref.child("groupUsers").child(groupId)
    }
    
    
    @objc private func pickerShow(index: Int)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if index == 0 {
            imagePicker.sourceType = .photoLibrary }
        else if index == 1 {
            imagePicker.sourceType = .camera
        }
         
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.groupImageView.image = pickedImage
        self.groupImageView.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
