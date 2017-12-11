//
//  UserPhotosCollectionController.swift
//  ChatApp
//
//  Created by DevOminext on 11/27/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

private let cellId = "cellId"

class UserPhotosCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var statusArray = [UserStatus]()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        collectionView?.isScrollEnabled = true
        collectionView?.alwaysBounceVertical = true

        self.collectionView!.register(PhotoLibrarycell.self, forCellWithReuseIdentifier: cellId)
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return statusArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! PhotoLibrarycell
        cell.videoLabel.removeFromSuperview()
        cell.alphaView.removeFromSuperview()
        cell.userStatus = statusArray[indexPath.item]
        cell.setup()
        return cell
    }
    
    func collectionView(collectinView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 20)/3, height: (view.frame.width - 20)/3)
    }

}
