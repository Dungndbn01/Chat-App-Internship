//
//  TweetCell.swift
//  PartFromMainProject
//
//  Created by Nguyen Dinh Dung on 2017/11/22.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import LBTAComponents
import Firebase

class TweetCell: UICollectionViewCell {
    let date = NSDate()
    let calendar = Calendar.current
    var timeLabelString: String?
    var userStatus: UserStatus? {
        didSet {
            profileImageView.loadImage(urlString: (userStatus?.profileImageUrl) ?? "")
            
            self.statusImageView.loadImageUsingCacheWithUrlString(urlString: (self.userStatus?.statusImageUrl) ?? "")
            
            let attributedText = NSMutableAttributedString(string: "\(userStatus?.name ?? "")\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
            
            setupStatusCell()
            
//            let usernameString = "\(String(describing: userStatus?.timeStamp) )\n"
            attributedText.append(NSAttributedString(string: "\(timeLabelString ?? "") \n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.gray]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let range = NSMakeRange(0, attributedText.string.characters.count)
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            
            attributedText.append(NSAttributedString(string: (userStatus?.statusText) ?? "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]))
            
            messageTextView.attributedText = attributedText
            }
    }
    
    func setupStatusCell(){
        if let seconds = userStatus?.timeStamp?.doubleValue {
            let timeStampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy/MM/dd"
            
            let dateString: String = dateFormatter.string(from: timeStampDate as Date)
            let dateString2: String = dateFormatter2.string(from: timeStampDate as Date)
            
            let year = calendar.component(.year, from: date as Date)
            let month = calendar.component(.month, from: date as Date)
            let day = calendar.component(.day, from: date as Date)
            
            let refString: String = String(format: "%0.2d/%0.2d/%0.2d",year, month, day)
            
            if refString > dateString2 {
                timeLabelString = refString
            } else if refString == dateString2 {
                timeLabelString = dateString
            }
            
        }
    }
    
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Some thing you wanat to wirte"
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Like", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setImage(UIImage(named: "Like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comment", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setImage(UIImage(named: "Comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100)
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setImage(UIImage(named: "Share")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100)
        return button
    }()

    override init(frame: CGRect) {
            super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(messageTextView)
        addSubview(statusImageView)
        
        profileImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 8, widthConstant: 50, heightConstant: 50)
        
        messageTextView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        statusImageView.anchor(nil, left: self.messageTextView.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 32, rightConstant: 0, widthConstant: 150, heightConstant: 150)
        
        setupBottomButtons()

    }
    
     func setupBottomButtons() {
        let likeButtonContainerView = UIView()
        
        let commentButtonContainerView = UIView()
        
        let shareButtonContainerView = UIView()
        
        let buttonStackView = UIStackView(arrangedSubviews: [likeButtonContainerView, commentButtonContainerView, shareButtonContainerView])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        addSubview(buttonStackView)
        buttonStackView.anchor(nil, left: messageTextView.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        likeButton.anchor(likeButtonContainerView.topAnchor, left: likeButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 20)
        
        commentButton.anchor(commentButtonContainerView.topAnchor, left: commentButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 20)
        
        shareButton.anchor(shareButtonContainerView.topAnchor, left: shareButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
