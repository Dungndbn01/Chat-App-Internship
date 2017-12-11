//
//  UserStatusCollectionController.swift
//  ChatApp
//
//  Created by DevOminext on 11/27/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class UserStatusCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var user: User?
    var statusArray = [UserStatus]()
    let cellId = "cellId"

    func observeMessage() {
        guard let uid = user?.id else {
            return
        }
        
        let userMessageRef = Database.database().reference().child("user-status").child(uid)
                userMessageRef.keepSynced(true)
        userMessageRef.observe(.childAdded, with: {
            (DataSnapshot) in
            let messageId  = DataSnapshot.key
            let messageRef = Database.database().reference().child("user-status").child(uid).child(messageId)
                messageRef.keepSynced(true)
            messageRef.observeSingleEvent(of: .value, with: {
                (DataSnapshot) in
                guard let dictionary = DataSnapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = UserStatus(dictionary: dictionary)
                DispatchQueue.main.async {
                    self.statusArray.insert(message, at: 0)
                    self.collectionView?.reloadData()
                    self.collectionView?.layoutIfNeeded()
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    let whiteView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        whiteView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5)
        observeMessage()
        collectionView?.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.isScrollEnabled = true
        self.collectionView!.register(TweetCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (self.collectionView?.contentOffset.y)! <= CGFloat(0) {
            let translation = self.collectionView?.panGestureRecognizer.translation(in: scrollView.superview!)
            if (translation?.y)! > CGFloat(0) {
                self.collectionView?.isScrollEnabled = false
                self.collectionView?.contentOffset.y = CGFloat(0)
            } else {
                self.collectionView?.isScrollEnabled = true
            }
        } }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! TweetCell
        let userStatus = statusArray[indexPath.item]
        cell.userStatus = userStatus
        cell.profileImageView.isHidden = true
        cell.userStatus?.name = ""
        cell.statusImageView.anchor(nil, left: cell.messageTextView.rightAnchor, bottom: cell.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 32, rightConstant: 0, widthConstant: 150, heightConstant: 150)
        cell.messageTextView.anchor(cell.topAnchor, left: cell.leftAnchor, bottom: nil, right: cell.rightAnchor, topConstant: -20, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = statusArray[indexPath.item]
        
        let estimateHeight = estimateHeightForText(tweet.statusText ?? "")
        if tweet.statusText == "" {
            return CGSize(width: view.frame.width, height: estimateHeight + 74 + 130)
        }
        return CGSize(width: view.frame.width, height: estimateHeight + 74 + 150)
    }
    
    private func estimateHeightForText(_ text: String) -> CGFloat {
        let approximateWidthOfBioTextView = view.frame.width - 12 - 50 - 12 - 2
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        
        let estimateFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimateFrame.height
        
    }
}
