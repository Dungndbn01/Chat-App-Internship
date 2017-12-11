//
//  PhotoLibraryController.swift
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
import SVProgressHUD

class PhotoLibraryController: UICollectionViewController, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<AnyObject>!
    var assetThumbnailSize: CGSize!
    
    var imageArray = [UIImage]()
    let imagePickerController = UIImagePickerController()
    
    let cellId = "cellId"
    
    let options = PHFetchOptions()
    var videos = PHFetchResult<AnyObject>()
    
    var user: User?
    
    let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image
        , options: PHFetchOptions())

    let fetchResult2: PHFetchResult = PHAsset.fetchAssets(with: .video
        , options: PHFetchOptions())
    
    let imageManager = PHImageManager.default()
    
    let requestOptions = PHImageRequestOptions()
    
    let fetchOptions = PHFetchOptions()
    
    
    deinit {
        self.photosAsset = nil
        self.imageArray = []
        self.arrayVideoInfo = []
        self.user = nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView?.dataSource = self
//        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        collectionView?.alwaysBounceVertical = true
        collectionView?.isScrollEnabled = true
        collectionView?.allowsMultipleSelection = true
        collectionView?.register(PhotoLibrarycell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        
        if self.fetchResult2.count > 0 || self.fetchResult.count > 0{
            count = self.fetchResult2.count + self.fetchResult.count
        }
        
        return count
    }
    
    func delegate() {
        print("ABC")
    }
    
    var arrayImageInfo = [String]()
    var arrayVideoInfo = [String]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath as IndexPath) as! PhotoLibrarycell
        //Modify the cell
        cell.photoLibraryController = self
        cell.chatLogController = ChatLogController()
        cell.loadImage(fetchResult: fetchResult, fetchResult2: fetchResult2, indexPath: indexPath)
        return cell
        }

    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(collectinView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 20)/3, height: (view.frame.width - 20)/3)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SVProgressHUD.show()
        var selectedImage: UIImage?
        let width: CGFloat = 150
        let height: CGFloat = 150
        let size = CGSize(width:width, height:height)
        if indexPath.row < self.fetchResult2.count {
        let asset = self.fetchResult2.object(at: indexPath.row)
        guard (asset.mediaType == PHAssetMediaType.video)   else {
            print("Not a valid video media type")
            return
        }

        PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { asset, audioMix, info  in
            let asset = asset as! AVURLAsset
            let chatLog = ChatLogController()
            chatLog.handleVideoSelectedForUrl(url: asset.url as NSURL)
            print(asset.url)
        }) }

        else if indexPath.row >= fetchResult2.count {

        let asset2 = self.fetchResult.object(at: indexPath.row - fetchResult2.count)
        guard (asset2.mediaType == PHAssetMediaType.image)   else {
                        print("Not a valid video media type")
                        return
                    }
            PHImageManager.default().requestImage(for: asset2 , targetSize: size, contentMode: PHImageContentMode.aspectFit, options: nil)
            {   (image, userInfo) -> Void in
                selectedImage = image
            }

        PHImageManager.default().requestImageData(for: asset2, options: nil) { (data, string, orientation, info) in
            let url = String(describing: info!["PHImageFileURLKey"])
            let chatLog = ChatLogController()
            chatLog.handleSendImageFromLibrary(imageUrl: url, selectedImage: selectedImage)
            } }
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }

}
