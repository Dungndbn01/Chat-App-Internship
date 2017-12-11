//
//  VideoLauncher.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/11/13.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let pauseButton: UIButton = {
       let button = UIButton(type: .system)
        let image = UIImage(named: "PauseButton")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.tintColor = UIColor.white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "play_button-1")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.tintColor = UIColor.white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    let playAgainButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "playAgain")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.tintColor = UIColor.white
        button.isHidden = true
        button.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        return button
    }()
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoProgressLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        slider.setThumbImage(UIImage(named: "Thumb-1"), for: .normal)
        return slider
    }()
    
    func handlePlay() {
        player?.play()
        self.isUserInteractionEnabled = true
        pauseButton.isHidden = true
        playButton.isHidden = true
        playAgainButton.isHidden = true
    }
    
    func handlePause() {
        player?.pause()
        i = 0
        timer?.invalidate()
        timer = nil
        pauseButton.isHidden = true
        playButton.isHidden = false
        playAgainButton.isHidden = true
        
    }
    
    func playAgain() {
        playAgainButton.isHidden = true
        pauseButton.isHidden = true
        playButton.isHidden = true
        
        let seekTime = CMTime(value: 0, timescale: 1)
        
        self.player?.seek(to: seekTime, completionHandler:  {
            [unowned self] (completedSeek) in
            self.player?.play()
        })
    }
    
    func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler:  {
                (completedSeek) in
                
            })

        }
        
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0.7,1.2]
        
        controlContainerView.layer.addSublayer(gradientLayer)
    }
    
    var timer: Timer?
    var i: Int = 0
    
    func showPauseButton() {
        pauseButton.isHidden = false
        i += 1
        if i >= 2 {
            pauseButton.isHidden = true
            i = 0
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func handleTapVideo() {
        i = 0
        pauseButton.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showPauseButton), userInfo: nil, repeats: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapVideo)))
        
        setupPlayerView()
        setupGradientLayer()
        
        controlContainerView.frame = frame
        addSubview(controlContainerView)
        
        controlContainerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        controlContainerView.addSubview(pauseButton)
        
        pauseButton.anchor(self.centerYAnchor, left: self.centerXAnchor, bottom: nil, right: nil, topConstant: -25, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        controlContainerView.addSubview(playAgainButton)
        
        playAgainButton.anchor(self.centerYAnchor, left: self.centerXAnchor, bottom: nil, right: nil, topConstant: -25, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)

        controlContainerView.addSubview(playButton)
        
        playButton.anchor(self.centerYAnchor, left: self.centerXAnchor, bottom: nil, right: nil, topConstant: -25, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)

        controlContainerView.addSubview(videoLengthLabel)
        
        videoLengthLabel.anchor(nil, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 55, heightConstant: 24)
        
        controlContainerView.addSubview(videoProgressLabel)
        
        videoProgressLabel.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 55, heightConstant: 24)
        
        controlContainerView.addSubview(videoSlider)
        
        videoSlider.anchor(nil, left: videoProgressLabel.rightAnchor, bottom: self.bottomAnchor, right: videoLengthLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
        
        backgroundColor = UIColor.clear
        
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/chat-app-bbb6e.appspot.com/o/message_movies%2F022A2F13-D281-4D9B-9B61-F3BC5FB3362E.mov?alt=media&token=70eae129-2d96-4628-a01d-7c2a33e1611a"
        
        if let url = NSURL(string: urlString) {
            player = AVPlayer(url: url as URL)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            self.playAgainButton.isHidden = true
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //get progress of video 
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {
                (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let duration = self.player?.currentItem?.duration
                let totalSeconds = CMTimeGetSeconds(duration!)
                self.videoSlider.value = Float(seconds / totalSeconds)
                
                let secondsText = Int(seconds) % 60
                
                let minutesText = Int(seconds) / 60
                
                self.videoProgressLabel.text = String(format: "%02d : %02d", minutesText ,secondsText)
                
                if self.videoSlider.value == 1 {
                      self.pauseButton.isHidden = true
                      self.playAgainButton.isHidden = false
                }

            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //video is ready to play
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = UIColor.clear
            
            if let duration = player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            
            let secondsText = Int(seconds) % 60
                
            let minutesText = Int(seconds) / 60
            
            videoLengthLabel.text = String(format: "%02d : %02d", minutesText ,secondsText)
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: UIViewController {
    let video = VideoPlayerView()
    let keyWindow = UIApplication.shared.keyWindow
    let originalFrame = CGRect(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 160, width: 100, height: 100)
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Down_Arrow")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.white
        return button
            }()
    
    func backHandle() {
        self.video.player?.pause()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = self.originalFrame }, completion: { (completedAnimation) in
                UIApplication.shared.isStatusBarHidden = false
                self.backButton.isHidden = true
                self.dismiss(animated: true, completion: nil)
        } )
    }
    
    func setupView() {
        view = UIView(frame: (keyWindow?.frame)!)
        view.backgroundColor = UIColor.white
        
        view.frame = CGRect(x: (keyWindow?.frame.width)! - 10, y: (keyWindow?.frame.height)! - 10, width: 10, height: 10)
        
        let height = (keyWindow?.frame.width)! * 9 / 16
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: (keyWindow?.frame.width)!, height: height)
        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        view.addSubview(videoPlayerView)
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(backHandle), for: .allEvents)
        
        backButton.anchor(videoPlayerView.topAnchor, left: videoPlayerView.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        keyWindow?.addSubview(view)
    }

    func showVideoPlayer() {
        setupView()
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.view.frame = (self.keyWindow?.frame)!}, completion: { (completedAnimation) in
              UIApplication.shared.isStatusBarHidden = true
        } )
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        super.viewDidAppear(animated)
        self.showVideoPlayer()
    }
    
    }
    
