//
//  HomeDataSourceController.swift
//  PartFromMainProject
//
//  Created by Nguyen Dinh Dung on 2017/11/21.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import LBTAComponents
import Firebase

class HomeDataSourceController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var userStatusArray = [UserStatus]()
    var userStatusDictionary = [String: UserStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(r: 232, g: 235, b: 241)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.register(TweetCell.self, forCellWithReuseIdentifier: cellId)
        observeUserStatus()
        }

    func observeUserStatus() {
        let ref = Database.database().reference().child("user-status")
        ref.observe(.childAdded, with: {
            (DataSnapshot) in
            let userId = DataSnapshot.key
            let ref2 = Database.database().reference().child("user-status").child(userId)
            ref2.observe(.childAdded, with: { (DataSnapshot) in
                let statusId = DataSnapshot.key
                let statusReference = Database.database().reference().child("user-status").child(userId).child(statusId)
                statusReference.observeSingleEvent(of: .value, with: {
                    (DataSnapshot) in
                    
                    if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                        let userStatus = UserStatus(dictionary: dictionary)
                        userStatus.setValuesForKeys(dictionary)
                        self.userStatusArray.append(userStatus)
                        
                        self.timer?.invalidate()
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    }
                    
                }, withCancel: nil)
            }, withCancel: nil)

            }, withCancel: nil)
    }
    
    var timer: Timer?
    
    func handleReloadTable() {
        
        self.userStatusArray.sort(by: {
            (userStatus1, userStatus2) -> Bool in
            return (userStatus1.timeStamp?.intValue)! > (userStatus2.timeStamp?.intValue)!
        })
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userStatusArray.count
//    return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! TweetCell
        let userStatus = userStatusArray[indexPath.item]
        cell.userStatus = userStatus
//        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let tweet = userStatusArray[indexPath.item]

            let estimateHeight = estimateHeightForText(tweet.statusText ?? "")
        
        if tweet.statusText == "" {
            return CGSize(width: view.frame.width, height: estimateHeight + 74 + 130)
        }
        
            return CGSize(width: view.frame.width, height: estimateHeight + 74 + 174)
//        return CGSize(width: self.view.frame.width, height: 150)
    }
    
    private func estimateHeightForText(_ text: String) -> CGFloat {
        let approximateWidthOfBioTextView = view.frame.width - 12 - 50 - 12 - 2
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]

        let estimateFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return estimateFrame.height

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
////        if section == 1 {
////            return .zero
////        }
//        return CGSize(width: view.frame.width, height: 50)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
////        if section == 1 {
////            return .zero
////        }
//        return CGSize(width: view.frame.width, height: 64)
//    }
}

