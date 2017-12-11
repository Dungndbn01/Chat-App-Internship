//
//  LogginController_ImageHandle.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/25.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import SVProgressHUD

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func handleFacebookRegister(email: String, name: String, imageUrl: String, uid: String){
        let values = ["name": name, "email": email, "profileImageUrl": imageUrl]
        
        let ref = Database.database().reference()
        let usersReference = ref.child("user").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: {  (err, ref) in
            if err != nil {
                print(err!)
                return
            }})
    }
    
    func handleRegister() {
        SVProgressHUD.show()
        if emailTextField.text! == "" || passwordTextField.text! == "" || nameTextField.text! == "" {
            SVProgressHUD.dismiss()
            self.errorAlert(string: "You must complete all text fields") }
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self] (user, Error) in
            if Error != nil {
                print(Error!)
                SVProgressHUD.dismiss()
                self.errorAlert(string: "Your email is not correct. Please type again")
                return
            } else {
                guard (user?.uid) != nil else {
                    return
                }
                
                //successfully authenticated user
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("myImage").child("\(imageName).jpg")
                
                if let image = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(image, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { [unowned self] (metadata, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            let backgroundImageUrl = "https://firebasestorage.googleapis.com/v0/b/chat-app-bbb6e.appspot.com/o/myImage%2F432913C6-F5DB-4D91-8C1C-0D321F969504?alt=media&token=85f04fe2-9f2f-4e36-81aa-8869c7f6af6e"
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "checkOnline": "Disconnect", "backgroundImageUrl": backgroundImageUrl, "id": (user?.uid)!, "lastTimeLoggin": 0, "lastTimeLogout": 0, "isTypingCheck": "false", "chattingWith": "NoOne"] as [String : Any]
                            self.registerUserIntoDatabaseWithUID(uid: (user?.uid)!, values: values as [String : AnyObject])
                            SVProgressHUD.dismiss()

                        }                }    )
                }
               
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("user").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { [unowned self] (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Saved user successfully into Firebase db")
            self.errorAlert(string: "You just created account successfully! Please login on the left button")
        })
 //       self.dismiss(animated: true, completion: nil)
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        profileImage.image = UIImage(named: "avatar")
        profileImage2.image = UIImage(named: "camera")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    func imageTapped()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imageTapped2()
    {
        let imagePicker2 = UIImagePickerController()
        imagePicker2.delegate = self
        imagePicker2.allowsEditing = true
        imagePicker2.sourceType = .camera
        
        present(imagePicker2, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = pickedImage
        profileImage.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}




