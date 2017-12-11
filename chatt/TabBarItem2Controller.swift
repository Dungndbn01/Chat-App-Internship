//
//  TabBarController2.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/11.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import LBTAComponents

class TabBarController2: UIViewController {
    
    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        button.setTitle("CONTACTS", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addVC1), for: .touchUpInside)
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        button.setTitle("GROUPS", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addVC2), for: .touchUpInside)
        return button
    }()
    
    let cellId = "cellId"
    
    lazy var tabBarContainer: NewMessageController = {
       let tabBar = NewMessageController()
       tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    lazy var tabBarContainer2: GroupListController = {
        let tabBar = GroupListController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    let horizontalView: UIView = {
        let view = UIView()
    view.backgroundColor = UIColor.blue
    view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var position: CGFloat = 0
    let x = UIScreen.main.bounds.width/2
    var height: CGFloat?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        height = barHeight + navigationBarHeight
        UserDefaults.standard.set(height, forKey: "navBarHeight")
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        
        setupButtonConstraint()
    
        self.view.addSubview(horizontalView)

        horizontalView.frame = CGRect(x: 0, y: height! + 38, width: UIScreen.main.bounds.width/2, height: 2 )
        addVC1()
    }
    
    func setupButtonConstraint() {
        
        button1.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.centerXAnchor, topConstant: height!, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        button2.anchor(self.view.topAnchor, left: self.view.centerXAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: height!, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
    func setupPositionForBar(index: Int) {
    let x = CGFloat(index) * self.view.frame.width / 2
    position = x
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.horizontalView.frame = CGRect(x: self.position, y: self.height! + 38, width: UIScreen.main.bounds.width/2, height: 2 )
    self.view.layoutIfNeeded()
    }, completion: nil)
    }

    
    func addVC1() {
        setupPositionForBar(index: 0)
        button1.setTitleColor(UIColor.blue, for: .normal)
        button2.setTitleColor(UIColor.gray, for: .normal)
        tabBarContainer.view.alpha = 1
        tabBarContainer2.view.removeFromSuperview()
        self.addChildViewController(tabBarContainer)
        self.view.addSubview(tabBarContainer.view)
        tabBarContainer.didMove(toParentViewController: self)
        tabBarContainer.view.frame = CGRect(x: 0, y: height! + 40, width: UIScreen.main.bounds.width, height: self.view.frame.height - 104)
    }
    
    func addVC2() {
        setupPositionForBar(index: 1)
        button2.setTitleColor(UIColor.blue, for: .normal)
        button1.setTitleColor(UIColor.gray, for: .normal)
        tabBarContainer.view.removeFromSuperview()
        tabBarContainer2.view.alpha = 1
        self.addChildViewController(tabBarContainer2)
        self.view.addSubview(tabBarContainer2.view)
        tabBarContainer2.didMove(toParentViewController: self)
        tabBarContainer2.view.frame = CGRect(x: 0, y: height! + 40, width: UIScreen.main.bounds.width, height: self.view.frame.height - 104)
    }
    
    
}
