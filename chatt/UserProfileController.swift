//
//  UserProfileController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/10.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import LBTAComponents

class UserProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    
    let arrayImage = ["People_Nearby", "Chat Room", "Shop", "Sticker", "Game", "Channel"]
    
    let arrayName = ["People Nearby", "Chat Rooms", "Shop", "Sticker", "Game", "Channel"]
    
    var myTableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var profileContainer: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        button.addTarget(self, action: #selector(handleUserProfileDelegate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var writeStatus: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setBackgroundImage(UIImage(named: "Write Icon"), for: .normal)
        button.imageView?.tintColor = UIColor.blue
        button.imageView?.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "My Profile"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        fetchUserAndSetupContainer()
        
        view.addSubview(profileContainer)
        view.addSubview(myTableView)
        
        setupProfileContainer()
        setupMyTableView()
        
        writeStatus.addTarget(self, action: #selector (showStatusController), for: .touchUpInside)
    }
    
    func showStatusController() {
        let statusController = WritingStatusController()
        self.present(statusController, animated: true, completion: nil)
    }
    
    func handleUserProfileDelegate() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user").child(uid!).observeSingleEvent(of: .value, with: { [unowned self] (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.handleUserProfile(user: user)
            }
        }, withCancel: nil)
    }
    
    func handleUserProfile(user: User) {
        profileContainer.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        let myProfileController = MyProfileController()
        myProfileController.user = user
        navigationController?.pushViewController(myProfileController, animated: true)
    }
    
    func fetchUserAndSetupContainer() {
        let uid = Auth.auth().currentUser?.uid
        
    Database.database().reference().child("user").child(uid!).observeSingleEvent(of: .value, with: { [unowned self] (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupContainerWithUser(user: user, nameLabel: self.userNameLabel, profileImageView: self.profileImageView)
            }
        }, withCancel: nil)
    }

    func setupContainerWithUser(user: User, nameLabel: UILabel, profileImageView: UIImageView) {
        nameLabel.text = user.name
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
    }
    
    func setupProfileContainer() {
        let height: CGFloat = CGFloat(self.userDefault.float(forKey: "navBarHeight"))
        
        profileContainer.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: height, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        profileContainer.addSubview(profileImageView)
        profileContainer.addSubview(userNameLabel)
        profileContainer.addSubview(detailLabel)
        profileContainer.addSubview(writeStatus)
        
        writeStatus.anchor(profileContainer.topAnchor, left: nil, bottom: profileContainer.bottomAnchor, right: profileContainer.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 15, rightConstant: 12, widthConstant: 20, heightConstant: 0)
        
        profileImageView.anchor(profileContainer.topAnchor, left: profileContainer.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 34, heightConstant: 34)
        
        userNameLabel.anchor(profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.centerYAnchor, right: profileContainer.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        detailLabel.anchor(profileImageView.centerYAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: profileContainer.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupMyTableView() {
        
        myTableView.anchor(profileContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        cell.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        cell.selectionStyle = .none
        
        cell.profileImageView.image = UIImage(named: arrayImage[indexPath.row])
        cell.textLabel?.text = arrayName[indexPath.row]
        cell.arrowImageView.image = UIImage(named: "arrow")
        cell.callButton.removeFromSuperview()
        cell.callVideoButton.removeFromSuperview()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        return vw
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
}
