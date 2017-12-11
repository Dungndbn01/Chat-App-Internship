//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/28.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import AVFoundation
import LBTAComponents

class ChatMessageCell: UICollectionViewCell, UITextViewDelegate {
    
    var chatLogController: ChatLogController?
    var message: Message?
    var count: Int = 0
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play_button")
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    lazy var PlayAudioBTN: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.isHidden = true
        button.setTitleColor(UIColor.green, for: .normal)
        
        button.addTarget(self, action: #selector(PlaySound), for: .touchUpInside)
        return button
    }()
    
    let audioDurationLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "00 : 00"
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var soundPlayer: AVAudioPlayer?
    
    func PlaySound(){
        if PlayAudioBTN.titleLabel?.text != "Stop" {
            
            preparePlayer()
            PlayAudioBTN.setTitle("Stop", for: .normal)
        }
        else {
            soundPlayer?.stop()
            PlayAudioBTN.setTitle("Play", for: .normal)
        }
    }
    
    func preparePlayer(){
//        var error: NSError?
        let link = message?.audioUrl
        if let linkUrl = NSURL(string: link!) {
            URLSession.shared.dataTask(with: linkUrl as URL, completionHandler: {
                (data, response, error) -> Void in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            self.soundPlayer = try AVAudioPlayer(data: data)
                            self.soundPlayer?.delegate = self as? AVAudioPlayerDelegate
                            self.soundPlayer?.prepareToPlay()
                            self.soundPlayer?.play()
                            self.soundPlayer?.volume = 1.0
                        }
                        catch let err as NSError {
                            print(err)
                        }
                    }
                    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
                        self.PlayAudioBTN.setTitle("Play", for: .normal)
                    }

                }
            }).resume()
        }
    }
    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        PlayAudioBTN.setTitle("Play", for: .normal)
//    }

    func checkIfPlayerIsEnded(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem) }
    func playerDidFinishPlaying(note: NSNotification) {
        if self.message?.videoUrl != nil {
            playButton.isHidden = false }
        
    }
    
    func handlePlay() {
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor.clear
        tv.isEditable = false
        tv.isSelectable = true
        tv.dataDetectorTypes = UIDataDetectorTypes.all
//        tv.textColor = UIColor.white
//        tv.translatesAutoresizingMaskIntoConstraints = false
       return tv
    }()
    
    lazy var longTapView = UIView()
    
    static let blue = UIColor(r:0, g: 138, b: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blue
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
        
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if message?.imageUrl == nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
        // Please don't perform a lot of custom logic inside of a view class
    }
    
    let linkAttributes: [String : Any] = [
        NSForegroundColorAttributeName: UIColor.green,
        NSUnderlineColorAttributeName: UIColor.lightGray,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        longTapView.backgroundColor = .blue
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(PlayAudioBTN)
        addSubview(audioDurationLabel)

        // textView is a UITextView
        textView.linkTextAttributes = linkAttributes
        textView.delegate = self

        checkIfPlayerIsEnded()
        messageImageView.isUserInteractionEnabled = true
        profileImageView.isUserInteractionEnabled = true
        bubbleView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        profileImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32)
        
        //        need x,y,w,h constraints
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 220)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        audioDurationLabel.anchor(bubbleView.topAnchor, left: nil, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 0)
        
        PlayAudioBTN.anchor(bubbleView.topAnchor, left: nil, bottom: bubbleView.bottomAnchor, right: audioDurationLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        
        bubbleView.addSubview(messageImageView)
        
        messageImageView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bubbleView.addSubview(playButton)
        
        playButton.anchor(bubbleView.centerYAnchor, left: bubbleView.centerXAnchor, bottom: nil, right: nil, topConstant: -25, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        bubbleView.addSubview(activityIndicatorView)
        
        activityIndicatorView.anchor(bubbleView.centerYAnchor, left: bubbleView.centerXAnchor, bottom: nil, right: nil, topConstant: -25, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        textView.addSubview(longTapView)
        longTapView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder) has not been implemented")
    }
}
