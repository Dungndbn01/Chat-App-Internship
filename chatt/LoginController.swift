//
//  LoginController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/22.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import LBTAComponents
import SVProgressHUD

class LoginController: UIViewController, UITextFieldDelegate {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let hideShowPassword: UIButton = {
        let button = UIButton(type: .custom)
        let image1 = UIImage(named: "hide_pass")
        let image2 = UIImage(named: "show_pass")
        button.setImage(image1, for: .normal)
        button.setImage(image2, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hideshow_password), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let  nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let  emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginRegesterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    let Slide1Controller : UIPageViewController = {
        let view = PageVC.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let slidesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton = FBSDKLoginButton()
    
    lazy var customFBButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customFBButton.backgroundColor = .blue
        customFBButton.frame = CGRect(x: 20, y: view.frame.height - 80, width: view.frame.width - 40, height: 50)
        customFBButton.setTitle("Login with Facebook", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customFBButton)
        
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        setupKeyBoardObservers()
        
        customFBButton.isHidden = true
//        loginButton.isHidden = true
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        profileImage.isUserInteractionEnabled = true
        profileImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped2)))
        profileImage2.isUserInteractionEnabled = true
        
        view.backgroundColor = UIColor(r: 61 , g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(slidesContainerView)
        view.addSubview(profileImage)
        view.addSubview(profileImage2)
        view.addSubview(loginRegesterSegmentedControl)
        loginRegesterSegmentedControl.isEnabledForSegment(at: 1)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupSlidesContainerView()
        setupProfileImage()
        setupProfileImage2()
        setupLoginRegisterSegmentedControl()
        
    }
    func handleCustomFBLogout() {
        
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        customFBButton.setTitle("Login with Facebook", for: .normal)
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        print("Did logout of facebook")
        } }
    
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self)
        { (result, err) in
            if err != nil {
                print("Login facebook failed", err!)
                return
            }
        self.registerAccount()
        self.customFBButton.setTitle("Log Out", for: .normal)
        self.customFBButton.addTarget(self, action: #selector(self.handleCustomFBLogout), for: .touchUpInside)
    }
    }
    
    
    func registerAccount() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: {
            [unowned self] (user, error) in
            if error != nil {
                print("Something went wrong with your FBuser", error!)
                return
            }
            
            print("Successfully logged in with your FB user", user!)
            
            let request = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
            let _ = request?.start(completionHandler: { [unowned self] (connection, result, error) in
                guard let userInfo = result as? [String: Any] else { return } //handle the error
                
                //The url is nested 3 layers deep into the result so it's pretty messy
                if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String, let email = userInfo["email"] as? String, let name = userInfo["name"] as? String, let uid = user?.uid {
                    //Download image from imageURL
                    self.handleFacebookRegister(email: email, name: name, imageUrl: imageURL, uid: uid)
                    
                }
                let userLoggedInController = TabBarController()
                let navController = UINavigationController(rootViewController: userLoggedInController)
                UIApplication.shared.delegate?.window??.rootViewController = navController
                UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            })
            
        })
        
    }
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UserDefaults.standard.set(keyboardHeight, forKey: "keyboardHeight")
        }
    }

    
    func handleLoginRegister() {
        if loginRegesterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func errorAlert(string: String){
        let alert = UIAlertController.init(title: "NOTICE", message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleLogin() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.errorAlert(string: "You must complete all textfields") }
        guard let email = emailTextField.text, let password = passwordTextField.text
            else {
            return
        }
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [unowned self] (user,error) in
            
            if error != nil {
                print(error ?? "")
                self.errorAlert(string: "Your email or password is wrong. Please type again")
                return
            }
            
            
            //successfully logged in user
            let uid = Auth.auth().currentUser?.uid
            let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            
            let presenceRef = Database.database().reference(withPath: "user/\(uid!)/checkOnline")
            presenceRef.setValue("Connected")
            let lastLoginRef = Database.database().reference(withPath: "user/\(uid!)/lastTimeLoggin")
            lastLoginRef.setValue(timeStamp)
            
              let userLoggedInController = TabBarController()
              let navController = UINavigationController(rootViewController: userLoggedInController)
              UIApplication.shared.delegate?.window??.rootViewController = navController
              UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            SVProgressHUD.dismiss()
        })
    }
    
    func checkPartnerOnline() {
        Database.database().reference().child("user").observe(.childAdded, with: { (DataSnapshot) in
            let presenceRef = Database.database().reference(withPath: "user/\(DataSnapshot.key)/checkOnline")
            presenceRef.onDisconnectSetValue("Disconnect") })
    }
    
    func handleLoginRegisterChange() {
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
        let title = loginRegesterSegmentedControl.titleForSegment(at: loginRegesterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of inputsViewContainer
        inputsContainerViewHeightAnchor?.constant = loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //change text holder of nameTextField
        nameTextField.placeholder = loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        
        //change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        //change height of profile image 
        profileImage.isHidden = loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        profileImage2.isHidden = loginRegesterSegmentedControl.selectedSegmentIndex == 0 ?
            true : false
        customFBButton.isHidden = loginRegesterSegmentedControl.selectedSegmentIndex == 0 ? false : true
        
    }
        
    func setupLoginRegisterSegmentedControl() {
        
    loginRegesterSegmentedControl.anchor(nil, left: inputsContainerView.leftAnchor, bottom: inputsContainerView.topAnchor, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        
    }
    
    func hideshow_password(){
        if passwordTextField.isSecureTextEntry {
           passwordTextField.isSecureTextEntry = false
            let image1 = UIImage(named: "hide_pass")
            hideShowPassword.setImage(image1, for: .normal)
        } else {
           passwordTextField.isSecureTextEntry = true
            let image2 = UIImage(named: "show_pass")
             hideShowPassword.setImage(image2, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupProfileImage() {
        //need x, y, width, height constraints
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
        profileImage.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 20).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageHeightAnchor = profileImage.widthAnchor.constraint(equalToConstant: 100)
            profileImageHeightAnchor?.isActive = true
    }
    
    func setupProfileImage2() {
        //need x, y, width, height constraints
        profileImage2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
        profileImage2.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 20).isActive = true
        profileImage2.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage2HeightAnchor = profileImage2.widthAnchor.constraint(equalToConstant: 100)
            profileImage2HeightAnchor?.isActive = true
    }
    
    func setupSlidesContainerView() {

        slidesContainerView.anchor(view.topAnchor, left: loginRegesterSegmentedControl.leftAnchor, bottom: loginRegesterSegmentedControl.topAnchor, right: loginRegesterSegmentedControl.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var profileImageHeightAnchor: NSLayoutConstraint?
    var profileImage2HeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
            inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
            inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparator)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparator)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(hideShowPassword)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -12).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparator.anchor(nameTextField.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -12).isActive = true
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparator.anchor(emailTextField.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            passwordTextFieldHeightAnchor?.isActive = true
        
        
        hideShowPassword.anchor(passwordTextField.topAnchor, left: nil, bottom: passwordTextField.bottomAnchor, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 3, widthConstant: 30, heightConstant: 20)
        
        slidesContainerView.addSubview(Slide1Controller.view)
        
        Slide1Controller.view.anchor(slidesContainerView.topAnchor, left: slidesContainerView.leftAnchor, bottom: slidesContainerView.bottomAnchor, right: slidesContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginRegisterButton.centerYAnchor.constraint(equalTo: self.inputsContainerView.bottomAnchor, constant: 32).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }

}


