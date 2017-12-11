//
//  ProfileController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/24.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    var user: User?
    
    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("TIMELINE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("PHOTOS", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    lazy var tabBarContainer2: UserPhotosCollectionController = {
        let tabBar = UserPhotosCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        return tabBar
    }()
    
    lazy var tabBarContainer: UserStatusCollectionController = {
        let tabBar = UserStatusCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        return tabBar
    }()
    
    lazy var horizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    var position: CGFloat = 0
    let x = UIScreen.main.bounds.width/2
    
    func setupPositionForBar(index: Int) {
        let x = CGFloat(index) * self.view.frame.width / 2
        position = x
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.horizontalView.frame = CGRect(x: x, y: self.button1.frame.maxY - 2, width: UIScreen.main.bounds.width/2, height: 2 )
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func addVC() {
        self.addChildViewController(tabBarContainer)
        self.view.addSubview(tabBarContainer.view)
        tabBarContainer.didMove(toParentViewController: self)
        tabBarContainer.view.anchor(self.button1.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.height - 60)
    }
    
    func addVC1() {
            self.setupPositionForBar(index: 0)
        button1.setTitleColor(.red, for: .normal)
        button2.setTitleColor(.white, for: .normal)
        tabBarContainer.view.alpha = 1
        tabBarContainer2.view.removeFromSuperview()
    }
    
    func addVC2() {
            self.setupPositionForBar(index: 1)
        button2.setTitleColor(.red, for: .normal)
        button1.setTitleColor(.white, for: .normal)
        tabBarContainer2.statusArray = tabBarContainer.statusArray
        tabBarContainer.view.alpha = 0
        tabBarContainer2.view.alpha = 1
        
        self.addChildViewController(tabBarContainer2)
        self.view.addSubview(tabBarContainer2.view)
        tabBarContainer2.didMove(toParentViewController: self)
        tabBarContainer2.view.anchor(self.button2.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.height - 60)

    }
    func setupButtonConstraint() {
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(horizontalView)
        
        horizontalView.anchor(nil, left: self.view.leftAnchor, bottom: self.button1.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: x, heightConstant: 2)
        
        button1.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        button2.anchor(self.view.topAnchor, left: self.view.centerXAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarContainer2.user = user
        tabBarContainer.user = user
        
        setupButtonConstraint()
        setupPositionForBar(index: 0)
        addVC()
        button1.setTitleColor(UIColor.red, for: .normal)
        
        button1.addTarget(self, action: #selector(addVC1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(addVC2), for: .touchUpInside)
    }

}
