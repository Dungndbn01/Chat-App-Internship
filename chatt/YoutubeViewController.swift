//
//  ViewController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/05.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var videos: [Video] = []
    let song1: Video = {
        var japaneseMusicChannel = Channel()
        japaneseMusicChannel.name = "Japanese Music Channel"
        japaneseMusicChannel.profileImageName = "japaneseMusic"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Song for a stormy night - Secret Garden of Japan"
        blankSpaceVideo.thumbnailImageName = "AKB48"
        blankSpaceVideo.channel = japaneseMusicChannel
        blankSpaceVideo.numberOfViews = "34,534,523 views"
        
        return blankSpaceVideo
    }()
    
    let song2: Video = {
        var japaneseMusicChannel = Channel()
        japaneseMusicChannel.name = "Japanese Music Channel"
        japaneseMusicChannel.profileImageName = "japaneseMusic"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Flavour of Life - Utada Hikaru"
        blankSpaceVideo.thumbnailImageName = "UtadaHikaru"
        blankSpaceVideo.channel = japaneseMusicChannel
        blankSpaceVideo.numberOfViews = "989,234,593 views"
        
        return blankSpaceVideo
    }()
    
    let song3: Video = {
        var japaneseMusicChannel = Channel()
        japaneseMusicChannel.name = "Japanese Music Channel"
        japaneseMusicChannel.profileImageName = "japaneseMusic"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Anata Ni Deaete Yokatta - RSP Japan"
        blankSpaceVideo.thumbnailImageName = "AnataNiDeaete"
        blankSpaceVideo.channel = japaneseMusicChannel
        blankSpaceVideo.numberOfViews = "23,543,688 views"
        
        return blankSpaceVideo
    }()
    
    let song4: Video = {
        var japaneseMusicChannel = Channel()
        japaneseMusicChannel.name = "Vietnam Music Channel"
        japaneseMusicChannel.profileImageName = "VietnamChannel"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Phía sau 1 cô gái - Soobin Hoàng Sơn"
        blankSpaceVideo.thumbnailImageName = "PhiaSau"
        blankSpaceVideo.channel = japaneseMusicChannel
        blankSpaceVideo.numberOfViews = "234,456,765,234 views"
        
        return blankSpaceVideo
    }()

    let song5: Video = {
        var japaneseMusicChannel = Channel()
        japaneseMusicChannel.name = "Vietnam Music Channel"
        japaneseMusicChannel.profileImageName = "VietnamChannel"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Cô gái mưa - Hương Tràm"
        blankSpaceVideo.thumbnailImageName = "CoGaiMua"
        blankSpaceVideo.channel = japaneseMusicChannel
        blankSpaceVideo.numberOfViews = "63,567,235 views"
        
        return blankSpaceVideo
    }()

    let song6: Video = {
        var japaneseMusicChannel = Channel()
        japaneseMusicChannel.name = "USA Music Channel"
        japaneseMusicChannel.profileImageName = "USAChannel"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "As long as you love me - BackStreet Boys"
        blankSpaceVideo.thumbnailImageName = "AsLongAs"
        blankSpaceVideo.channel = japaneseMusicChannel
        blankSpaceVideo.numberOfViews = "344,654,756 views"
        
        return blankSpaceVideo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        videos = [song1,song2,song3,song4,song5,song6]
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.alwaysBounceVertical = true
        
//        self.navigationController?.hidesBarsOnSwipe = true
        
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath as IndexPath) as! VideoCell
        
        cell.video = videos[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 32) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 40 + 45 + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        self.present(videoLauncher, animated: false, completion: nil)
    }

}

