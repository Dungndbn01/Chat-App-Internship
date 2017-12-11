//
//  photoLibrarycell.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/06.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import LBTAComponents

class PhotoLibrarycell: UICollectionViewCell {
    
    var chatLogController : ChatLogController?
    weak var photoLibraryController: PhotoLibraryController?
    var userStatus: UserStatus? {
        didSet {
            if let profileImageUrl = userStatus?.statusImageUrl {
            self.libraryImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            } else { return }
        }
    }
    
    let selectButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let libraryImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    
    let videoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        label.alpha = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    func handleButtonClick() {
        self.photoLibraryController?.delegate()
    }
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let libraryImageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: libraryImageView)
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(libraryImageView)
        addSubview(videoLabel)
        addSubview(alphaView)
        alphaView.addSubview(selectButton)
        libraryImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        videoLabel.frame = CGRect(x: 0, y: self.frame.height - 20, width: self.frame.width, height: 20)
        alphaView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        selectButton.frame = CGRect(x: self.frame.width - 28, y: 8, width: 20, height: 20)
    }
    
    func setup() {
        libraryImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        libraryImageView.contentMode = .scaleToFill
        
    }
    
    func  loadImage(fetchResult: PHFetchResult<PHAsset>, fetchResult2: PHFetchResult<PHAsset>, indexPath: IndexPath)  {
        let requestOptions = PHImageRequestOptions()
        if indexPath.item < fetchResult2.count {
            //        let asset = self.videos.object(at: indexPath.item)
            let width: CGFloat = 150
            let height: CGFloat = 150
            let size = CGSize(width:width, height:height)
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.lightGray.cgColor
            PHImageManager.default().requestImage(for: fetchResult2.object(at: indexPath.item), targetSize: size, contentMode: PHImageContentMode.aspectFit, options: nil)
            { [weak self]  (image, userInfo) -> Void in
                DispatchQueue.main.async {
                    self?.libraryImageView.image = image
                }
            }
            PHImageManager.default().requestAVAsset(forVideo: fetchResult2.object(at: indexPath.item), options: nil, resultHandler: { [weak self] asset, audioMix, info  in
                DispatchQueue.main.async {
                    let asset = asset as! AVURLAsset
                    let duration = Int(round(CMTimeGetSeconds(asset.duration)))
                    let i = Int(duration/60)
                    let j = Int(duration%60)
                    print(String(duration))
                    print(i)
                    print(j)
                    self?.videoLabel.alpha = 0.8
                    self?.alphaView.alpha = 0.5
                    self?.videoLabel.text = String(format: "%02d : %02d", i ,j)
                } }) }
        else if indexPath.item >= fetchResult2.count {
            PHImageManager.default().requestImage(for: fetchResult.object(at: indexPath.item - fetchResult2.count), targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions, resultHandler: {[weak self] image, error in
                DispatchQueue.main.async {
                    self?.videoLabel.alpha = 0
                    self?.alphaView.alpha = 0
                    self?.libraryImageView.image = image
                }
            })
            
        }
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
