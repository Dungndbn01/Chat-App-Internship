//
//  SettingLauncher.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/08.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String{
    case Cancel = "Logout"
    case CreateGroup = "Create Group"
    case AddFriends = "Add Friends"
    case ScanQRCode = "Scan QR Code"
    case ChatAppPCWeb = "Chat App PC - Web"
}

class SettingLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
        let CreateGroupSetting = Setting(name: .CreateGroup, imageName: "Create Group")
        let AddFriendsSetting = Setting(name: .AddFriends, imageName: "Add Friends")
        let ScanQRCodeSetting = Setting(name: .ScanQRCode, imageName: "Scan QR Code")
        let ChatAppPCWebSetting = Setting(name: .ChatAppPCWeb, imageName: "Chat App PC- Web")
        let cancelSetting = Setting(name: .Cancel, imageName: "logout_icon")
        return [CreateGroupSetting, AddFriendsSetting, ScanQRCodeSetting, ChatAppPCWebSetting, cancelSetting]
    }()
    
    var homeController: TabBarController?
    func showSetting() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight + 10
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1

                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)

            }, completion: nil)
            
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.removeFromSuperview()
            if let window = UIApplication.shared.keyWindow {
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            } } , completion: nil  )
    }
    
    let cellId = "cellId"
    
    func handleSetting(setting: Setting){

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.blackView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completion: Bool) in
            
            if  setting.name == .Cancel {
                do {
                    let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                    if let uid = Auth.auth().currentUser?.uid {
                        let presenceRef = Database.database().reference(withPath: "user/\(uid)/checkOnline")
                    presenceRef.setValue("Disconnect")
                        let lastLogoutRef = Database.database().reference(withPath: "user/\(uid)/lastTimeLogout")
                    lastLogoutRef.setValue(timeStamp)
                    }

                    try Auth.auth().signOut()
                } catch let logoutError {
                    print(logoutError)
                }
                
                let loginController = LoginController()
                UIApplication.shared.delegate?.window??.rootViewController = loginController
                UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            }
            
            if setting.name != .Cancel {
                self.homeController?.showControllerForSettings(setting: setting)
            
            }
        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settings.count - 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! SettingCell
            let setting = settings[indexPath.item]
            cell.setting = setting
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! SettingCell
            let setting = settings[settings.count - 1]
            cell.setting = setting
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0: return CGSize(width: 0, height: 0)
        default: return CGSize(width: UIScreen.main.bounds.width, height: 10)
        }
    }
    
    let Header = "Header"
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Header, for: indexPath as IndexPath)
            
            headerView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
            return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: let setting = self.settings[indexPath.row]
        handleSetting(setting: setting)
        default:
            let setting = self.settings[settings.count - 1]
            handleSetting(setting: setting)
        }
        
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")

    }
}
