//
//  GoogleMapViewController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/13.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
import GooglePlaces

class VacationDestination: NSObject {
    
    let  name: String
    var location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapView: GMSMapView?
    
    var currentDestination: VacationDestination?
    
    lazy var locationManager = CLLocationManager()
    
    lazy var dismissButton = UIButton()
    
    lazy var navigationView = UIView()
    
    lazy var sendLocation = UIButton()
    
//    lazy var destinations  = [VacationDestination(name: "ABC", location: CLLocationCoordinate2DMake(21.042114, 105.760705), zoom: 15), VacationDestination(name: "XYZ", location: CLLocationCoordinate2DMake(21.036347, 105.774608), zoom: 15), VacationDestination(name: "XXX", location: CLLocationCoordinate2DMake(21.025627, 105.766048), zoom: 15)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationView()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView?.delegate = self
        
        GMSServices.provideAPIKey("AIzaSyDr40r-gssutRT6nDwUe4DoxfUjrcRV7Nc")
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        dismissButton = dismissButton.setUpButton(radius: 3, title: "Back", imageName: "", backgroundColor: .clear, fontSize: 18, titleColor: .darkText)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        sendLocation.setImage(UIImage(named: "send"), for: .normal)
        sendLocation.addTarget(self, action: #selector(handleSendLocation), for: .touchUpInside)
        
        self.view.addSubview(navigationView)
        self.view.addSubview(dismissButton)
        self.view.addSubview(sendLocation)
        navigationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        dismissButton.anchor(self.navigationView.topAnchor, left: self.navigationView.leftAnchor, bottom: nil, right: nil, topConstant: 32, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 20)
//        dismissButton.frame = CGRect(x: 10, y: 30, width: 50, height: 22)
//        sendLocation.frame = CGRect(x: self.view.frame.width - 47, y: 17, width: 30, height: 22)
        sendLocation.anchor(self.navigationView.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 27, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 38, heightConstant: 30)
        
    }
    
    @objc private func handleSendLocation() {
        let latitude = UserDefaults.standard.string(forKey: "Latitude")
        let longitude = UserDefaults.standard.string(forKey: "Longitude")
        let chatLog = ChatLogController()
        let properties: [String: AnyObject] = ["text": "https://maps.google.com/?daddr=\(latitude ?? ""),\(longitude ?? "")" as AnyObject]
        chatLog.sendMessageWithProperties(properties: properties)
    }
    
    @objc private func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = true
        }
    }
    
    var location: CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            location = locations.first
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15)
            
            mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            self.view.addSubview(mapView!)
            mapView?.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
            
            let currentLocation = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let marker = GMSMarker(position: currentLocation)
            marker.title = "Ominext Company"
            marker.map = mapView
            UserDefaults.standard.setValue(location?.coordinate.latitude, forKey: "Latitude")
            UserDefaults.standard.setValue(location?.coordinate.longitude, forKey: "Longitude")
            locationManager.stopUpdatingLocation()
        }
    }
    
//    func back() {
//        
//        if currentDestination == nil {
//            currentDestination = destinations.first
//        } else {
//            var index = destinations.index(of: currentDestination!)
//            if index == destinations.count - 1 {
//                index = 0
//            }
//            currentDestination = destinations[index! + 1]
//        }
//        
//        setMapCamera()
//        
//    }
    
    deinit {
        mapView = nil
    }
    
//    private func setMapCamera() {
//        CATransaction.begin()
//        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
//        
//        mapView?.animate(to: GMSCameraPosition.camera(withTarget: (currentDestination?.location)!, zoom: (currentDestination?.zoom)!))
//        
//        CATransaction.commit()
//        
//        let marker = GMSMarker(position: (currentDestination?.location)!)
//        marker.title = currentDestination?.name
//        marker.map = mapView
//    }
    
}
