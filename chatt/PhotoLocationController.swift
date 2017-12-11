//
//  Photo&LocationController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 13/11/2017.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import LBTAComponents

class PhotoLocationController: UIViewController {

    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        button.setTitle("IMAGES", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(VC1), for: .touchUpInside)
        return button
    }()
    
    func VC1() {
        addVC(index: 0, vcc: tabBarContainer)
        button1.setTitleColor(UIColor.blue, for: .normal)
    }
    
    lazy var button2: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        button.setTitle("LOCATION", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(VC2), for: .touchUpInside)
        return button
    }()
    
    func VC2() {
        addVC(index: 1, vcc: tabBarContainer2)
        button2.setTitleColor(UIColor.blue, for: .normal)
    }
    
    lazy var button3: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        button.setTitle("VOICE", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(VC3), for: .touchUpInside)
        return button
    }()

    func VC3(){
        addVC(index: 2, vcc: tabBarContainer3)
        button3.setTitleColor(UIColor.blue, for: .normal)
    }

    lazy var sendLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "x"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        button.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        button.clipsToBounds = true
        button.isHidden = false
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    
    let cellId = "cellId"
    
    lazy var tabBarContainer3: AudioRecordedController = {
        let tabBar = AudioRecordedController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    lazy var tabBarContainer2: GoogleMapViewController = {
        let tabBar = GoogleMapViewController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    lazy var tabBarContainer: PhotoLibraryController = {
        let tabBar = PhotoLibraryController(collectionViewLayout: UICollectionViewFlowLayout())
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    lazy var horizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    var position: CGFloat = 0
    let x = UIScreen.main.bounds.width/3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        
        setupButtonConstraint()
        
        self.view.addSubview(horizontalView)
        horizontalView.frame = CGRect(x: 0, y: 102, width: UIScreen.main.bounds.width/3, height: 2 )
        
        self.view.addSubview(sendLocationButton)
        
        sendLocationButton.anchor(button2.topAnchor, left: nil, bottom: button2.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 40)
        
        addVC(index: 1, vcc: tabBarContainer2)
        
    }
    
    func setupButtonConstraint() {
        
        button1.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: x - 12, heightConstant: 40)
        
        button3.anchor(view.topAnchor, left: button2.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: x - 12, heightConstant: 40)
        
        button2.anchor(view.topAnchor, left: button1.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: x - 12, heightConstant: 40)
        
    }
    
    func setupPositionForBar(index: Int) {
        let x = CGFloat(index) * (self.view.frame.width / 3 - 12)
        position = x
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.horizontalView.frame = CGRect(x: self.position, y: 38, width: UIScreen.main.bounds.width/3 - 12, height: 2 )
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func addVC(index: Int, vcc: UIViewController){
        setupPositionForBar(index: index)
        button1.setTitleColor(UIColor.gray, for: .normal)
        button2.setTitleColor(UIColor.gray, for: .normal)
        button3.setTitleColor(UIColor.gray, for: .normal)
        tabBarContainer2.view.removeFromSuperview()
        tabBarContainer3.view.removeFromSuperview()
        tabBarContainer.view.removeFromSuperview()
        vcc.view.alpha = 1
        if (vcc == tabBarContainer2) {
            sendLocationButton.setImage(UIImage(named: "send"), for: .normal)
            sendLocationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            tabBarContainer2.view.alpha = 1
        } else {
            sendLocationButton.setImage(UIImage(named: "x"), for: .normal)
            sendLocationButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        }
        self.addChildViewController(vcc)
        self.view.addSubview(vcc.view)
        vcc.didMove(toParentViewController: self)
        
        vcc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        vcc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        vcc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        vcc.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -40).isActive = true
        
    }
    
    let userDefault = UserDefaults.standard
    
    func buttonClicked() {
        if sendLocationButton.imageEdgeInsets == UIEdgeInsetsMake(0, 0, 0, 0) {
            handleSendLocation()
        } else if sendLocationButton.imageEdgeInsets == UIEdgeInsetsMake(10, 0, 10, 0) {
            cancel()
        }
    }
    
    func handleSendLocation() {
        let latitude = userDefault.string(forKey: "Latitude")
        let longitude = userDefault.string(forKey: "Longitude")
        let chatLog = ChatLogController()
        let properties: [String: AnyObject] = ["text": "https://maps.google.com/?daddr=\(latitude ?? ""),\(longitude ?? "")" as AnyObject]
        chatLog.sendMessageWithProperties(properties: properties)
    }
    
    func cancel() {
        let chatLog = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLog.handleDismiss()
//        chatLog.inputTextView.becomeFirstResponder()
    }

}
