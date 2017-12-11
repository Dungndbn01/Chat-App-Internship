//
//  StatusPhotosController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/26.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import LBTAComponents

protocol StatusPhotosControllerDelegate: class {
    func selectImage(image: UIImage)
    func getImageUrl(imageUrl: String)
}

class StatusPhotosController: UICollectionViewController, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout {
    
 var delegate: StatusPhotosControllerDelegate?
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<AnyObject>!
    var assetThumbnailSize: CGSize!
    let imagePickerController = UIImagePickerController()
    
    let cellId = "cellId"
    
    let options = PHFetchOptions()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        collectionView?.alwaysBounceVertical = true
        collectionView?.isScrollEnabled = true
        collectionView?.allowsMultipleSelection = true
        collectionView?.register(PhotoLibrarycell.self, forCellWithReuseIdentifier: cellId)
    }
    
    let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image
        , options: PHFetchOptions())

    let imageManager = PHImageManager.default()
    
    let requestOptions = PHImageRequestOptions()
    
    let fetchOptions = PHFetchOptions()
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        
        if self.fetchResult.count > 0 {
            count = self.fetchResult.count
        }
        
        return count
    }
    
    var arrayImageInfo = [String]()
    var arrayVideoInfo = [String]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath as IndexPath) as! PhotoLibrarycell
        //Modify the cell
            imageManager.requestImage(for: fetchResult.object(at: indexPath.item), targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, error in
                DispatchQueue.main.async {
                    cell.videoLabel.removeFromSuperview()
                    cell.alphaView.removeFromSuperview()
                    cell.libraryImageView.image = image
                }
            })
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
            let asset2 = self.fetchResult.object(at: indexPath.row)
            guard (asset2.mediaType == PHAssetMediaType.image)   else {
                print("Not a valid image type")
                return
            }
        imageManager.requestImage(for: fetchResult.object(at: indexPath.item), targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, error in
            self.delegate!.selectImage(image: image!)
        })

        PHImageManager.default().requestImageData(for: asset2, options: nil) { [unowned self] (data, string, orientation, info) in
            let url = String(describing: info!["PHImageFileURLKey"])
            self.delegate!.getImageUrl(imageUrl: url)
            }
    }
    
}

