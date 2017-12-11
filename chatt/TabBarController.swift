//
//  TabBarController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/09.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import LBTAComponents

class TabBarController: UITabBarController, UITabBarControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    var searchController : UISearchController!
    
    lazy var tabBarContainer: NewMessageController = {
        let tabBar = NewMessageController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    var filterData = [User]()
    var user: User?
    
    func setupReceivedMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let allUserMessageRef = Database.database().reference().child("user-message").child(uid)
        allUserMessageRef.observe(.childAdded, with: {
            (DataSnapshot) in
            let userId = DataSnapshot.key
            let userMessageRef = Database.database().reference().child("user-message").child(uid).child(userId)
            userMessageRef.observe(.childAdded, with: {
                (DataSnapshot) in
                let messageId = DataSnapshot.key
                let messageRef = Database.database().reference().child("message").child(messageId)
                messageRef.observeSingleEvent(of: .value, with: {
                    (DataSnapshot) in
                    guard let dictionary = DataSnapshot.value as? [String: AnyObject] else {
                        return
                    }
                    
                    let message = Message(dictionary: dictionary)
                    
                    if message.fromId != Auth.auth().currentUser?.uid && message.messageStatus != "Seen" {
                        let messageStatusRef = Database.database().reference(withPath: "message/\(messageId)/messageStatus")
                        
                        messageStatusRef.setValue("Received")
                    }
                })
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReceivedMessage()
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.delegate = self
        self.view.addSubview(tabBarContainer.tableView)
        self.addChildViewController(tabBarContainer)
        tabBarContainer.didMove(toParentViewController: self)
        let y: CGFloat = CGFloat(userDefault.float(forKey: "navBarHeight"))
        tabBarContainer.tableView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: 0)
        setupNavBarButton(imageName: "dotsss")
        nameSeparator.frame = CGRect(x: 0, y: self.view.frame.height - 42, width: self.view.frame.width, height: 2)
        
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(withPath: "user/\(uid)/checkOnline")
            ref.setValue("Connected") }

    }
    
    let userDefault = UserDefaults.standard
    let blackView = UIView()
    
    func handleDismiss2() {
        let y: CGFloat = CGFloat(self.userDefault.float(forKey: "navBarHeight"))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.removeFromSuperview()
            if let window = UIApplication.shared.keyWindow {
                self.tabBarContainer.view.frame = CGRect(x: 0, y: y, width: window.frame.width, height: 0)
            } } , completion: nil  )
    }
    
    let nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchTextField = UITextField(frame: CGRect(x: 58, y: 0, width: UIScreen.main.bounds.width - 116, height: 60))
    
    func setupNavBarButton(imageName: String) {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: nil)
        searchBarButtonItem.tintColor = UIColor.white
        let moreImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        moreBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = moreBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = searchBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    lazy var settingLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore() {
        settingLauncher.showSetting()
        
    }
    
    func showControllerForSettings(setting: Setting){
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.blue
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeTabbarItemsText()
        let item1 = MessageController()
        let icon1 = UITabBarItem(title: nil, image: UIImage(named: "message_icon-1"), selectedImage: UIImage(named: "message_icon-1"))
        item1.tabBarItem = icon1
        
        let item2 = TabBarController2()
        let icon2 = UITabBarItem(title: nil, image: UIImage(named: "about"), selectedImage: UIImage(named: "about"))
        item2.tabBarItem = icon2
        
        let item3 = ViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let icon3 = UITabBarItem(title: nil, image: UIImage(named: "youtubee"), selectedImage: UIImage(named: "youtubee"))
        item3.tabBarItem = icon3
        
        let item4 = UserProfileController()
        let icon4 = UITabBarItem(title: nil, image: UIImage(named: "rsz_threedots"), selectedImage: UIImage(named: "rsz_threedots"))
        item4.tabBarItem = icon4
        
        let item5 = HomeDataSourceController(collectionViewLayout: UICollectionViewFlowLayout())
        let icon5 = UITabBarItem(title: nil, image: UIImage(named: "bell"), selectedImage: UIImage(named: "bell"))
        item5.tabBarItem = icon5
        
//        tabBar.clipsToBounds = true
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let controllers = [item1,item2,item3,item5,item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.index(of: item)
        switch Int(indexOfTab!) {
        case 1: setupNavBarButton(imageName: "add_friend")
                self.navigationItem.title = "Friends"
        case 2: setupNavBarButton(imageName: "bell")
            self.navigationItem.title = "Videos"
        case 3: setupNavBarButton(imageName: "setting")
            self.navigationItem.title = "New Feed"
        case 4:  setupNavBarButton(imageName: "dotsss")
            self.navigationItem.title = "User Profile"
        default: setupNavBarButton(imageName: "dotsss")
            self.navigationItem.title = "Message"
        }
    }
}

