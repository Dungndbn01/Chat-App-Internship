//
//  UserCell.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/27.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import LBTAComponents

class UserCell: UITableViewCell {
    let date = NSDate()
    let calendar = Calendar.current
    var name: String?
    
    var message: Message? {
        didSet {
            setupMessageCell()
            setupNameAndProfileImage()
        }
    }
    
    func setupMessageCell(){    
        if let seconds = message?.timeStamp?.doubleValue {
            
            let now = NSDate()
            let nowTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: now)
            
            let timeInterval = Int(nowTimeStamp)! - Int(seconds)
            
            if timeInterval < 60 {
                self.timeLabel.text = String(timeInterval) + " seconds"
            } else if timeInterval > 60 && timeInterval < 3600 {
                let minutes = Int(timeInterval/60)
                self.timeLabel.text = String(minutes) + " minutes"
            } else if timeInterval > 3600 && timeInterval < 86400 {
                let hours = Int(timeInterval/3600)
                self.timeLabel.text = String(hours) + " hours"
            } else if timeInterval > 86400 {
                let days = Int(timeInterval/86400)
                self.timeLabel.text = String(days) + " days"
            }
        }
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    private func setupNameAndProfileImage() {
        if message?.toId?.range(of: "Group") == nil {
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("user").child(id)
            ref.observeSingleEvent(of: .value, with: {
                [unowned self] (DataSnapshot) in
                
                if let dictionary = DataSnapshot.value as? [String: AnyObject]
                {
                    self.name = dictionary["name"] as? String
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl as! String)
                    }
                }
                }, withCancel: nil)
            } }
        else if message?.toId?.range(of: "Group") != nil {
            let ref = Database.database().reference().child("group").child((message?.toId!)!)
            ref.observeSingleEvent(of: .value, with: {
                [unowned self] (DataSnapshot) in
                if let dictionary = DataSnapshot.value as? [String: AnyObject]
                {
                    self.name = dictionary["name"] as? String
                    let text = "Group: " + self.name!
                    self.textLabel?.text = text
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl as! String)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 66, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 66, y: detailTextLabel!.frame.origin.y, width: self.frame.width - 152, height: detailTextLabel!.frame.height)
    }
    
    let onlineView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
       view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let callButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "call_icon_rsz"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let callVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "camera_icon_rsz"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        //        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let  nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(callButton)
        addSubview(callVideoButton)
        addSubview(nameSeparator)
        addSubview(arrowImageView)
        addSubview(onlineView)
        
        arrowImageView.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 12, widthConstant: 20, heightConstant: 20)
        
        nameSeparator.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 66, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        callButton.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 65, widthConstant: 30, heightConstant: 30)
        
        callVideoButton.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 15, widthConstant: 30, heightConstant: 30)
        
        //need x,y,width,height constraints
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        // need x,y,width,height constraints
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 88).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        //need x,y,width,height constraints
        onlineView.rightAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 5).isActive = true
        onlineView.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 5).isActive = true
        onlineView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        onlineView.widthAnchor.constraint(equalToConstant: 8).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

