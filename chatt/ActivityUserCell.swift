//
//  UserCell.swift
//  PartFromMainProject
//
//  Created by Nguyen Dinh Dung on 2017/11/21.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import LBTAComponents

class ActivityUserCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            
            guard let user = datasourceItem as? TweetUser else { return }
            nameLabel.text = user.name
            userNameLabel.text = user.username
            bioTextView.text = user.bioText
//            profileImageView.image = user.profileImage
            
            profileImageView.loadImage(urlString: user.profileImageUrl)
        }
    }
    
    let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.image = UIImage(named: "UserImage")
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Niwa Isamu"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@dungnd"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(r: 130, g: 130, b: 130)
        return label
    }()
    
    let bioTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .clear
        return textView
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = twitterBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Add friend", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = twitterBlue
//        button.addTarget(self, action: #selector(addFriendClicked), for: .touchUpInside)
        return button
    }()
    
//    func addFriendClicked() {
//        if followButton.titleLabel?.text == "Add friend" {
//            followButton.titleLabel?.text = "Cancel"
//            followButton.setTitleColor(.darkText, for: .normal)
//            followButton.backgroundColor = .lightGray
//            print("XXX")
//        } else if followButton.titleLabel?.text == "Cancel" {
//            followButton.titleLabel?.text = "Add friend"
//            followButton.setTitleColor(.white, for: .normal)
//            followButton.backgroundColor = twitterBlue
//            print("YYY")
//        }
//    }
    
    override func setupViews() {
        super.setupViews()
        
        
        self.backgroundColor = .white
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(userNameLabel)
        addSubview(bioTextView)
        addSubview(followButton)
        addSubview(separatorLineView)
        
        profileImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        
        nameLabel.anchor(profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: followButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 20)
        
        userNameLabel.anchor(nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        bioTextView.anchor(userNameLabel.bottomAnchor, left: userNameLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: -2, leftConstant: -2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        followButton.anchor(topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 120, heightConstant: 34)
    }
}
