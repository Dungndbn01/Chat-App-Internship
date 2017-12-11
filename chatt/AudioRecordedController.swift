//
//  ViewController.swift
//  abcsdef
//
//  Created by Nguyen Dinh Dung on 2017/11/19.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import LBTAComponents
import SVProgressHUD

class AudioRecordedController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    let RecordBTN: UIButton = {
        let button = UIButton()
        button.setTitle("Record", for: .normal)
        button.setImage(UIImage(named: "Record"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(Record), for: .touchUpInside)
        return button
    }()
    
    let audioProgressLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    var backButton = UIButton()
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName = "audioFile.m4a"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupView()
        
        setupRecorder()
    }
    
    func setupBackButton() {
        
    }
    
    @objc private func handleCancel() {
        RecordBTN.setImage(UIImage(named: "Record"), for: .normal)
        RecordBTN.setTitle("Record", for: .normal)
        timer?.invalidate()
        timer = nil
        soundRecorder.stop()
        self.audioProgressLabel.text = "00 : 00"
    }
    
    @objc private func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        
//        backButton = backButton.setUpButton(radius: 0, title: "Back", imageName: "", backgroundColor: .clear, fontSize: 16, titleColor: .blue)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        view.addSubview(RecordBTN)
        view.addSubview(audioProgressLabel)
        view.addSubview(cancelButton)
        view.addSubview(backButton)
        
        RecordBTN.anchor(self.view.centerYAnchor, left: self.view.centerXAnchor, bottom: nil, right: nil, topConstant: -50, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        
        audioProgressLabel.anchor(nil, left: self.view.centerXAnchor, bottom: self.RecordBTN.topAnchor, right: nil, topConstant: 0, leftConstant: -25, bottomConstant: 10, rightConstant: 0, widthConstant: 50, heightConstant: 20)
        
        cancelButton.anchor(RecordBTN.bottomAnchor, left: RecordBTN.centerXAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 20)
        
        backButton.anchor(RecordBTN.bottomAnchor, left: nil, bottom: nil, right: RecordBTN.centerXAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 100, heightConstant: 20)
        
    }
    var timer: Timer?
    var currentTime : Int?
    
    func getCurrentDuration() {
        currentTime = currentTime! + 1

        let secondsText = currentTime! % 60

        let minutesText = currentTime! / 60

    self.audioProgressLabel.text = String(format: "%02d : %02d", minutesText ,secondsText)

 }
    
    func Record(){
        if RecordBTN.titleLabel?.text == "Record" {
        currentTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getCurrentDuration), userInfo: nil, repeats: true)
        RecordBTN.setImage(UIImage(named: "Recording"), for: .normal)
        soundRecorder.record()
        RecordBTN.setTitle("Stop", for: .normal)
        }
        else if RecordBTN.titleLabel?.text == "Stop"{
            RecordBTN.setImage(UIImage(named: "Record"), for: .normal)
            RecordBTN.setTitle("Record", for: .normal)
            timer?.invalidate()
            timer = nil
            soundRecorder.stop()
            self.audioProgressLabel.text = "00 : 00"
            self.Send()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func Send(){
        SVProgressHUD.show()
        let asset = AVURLAsset(url: getFileURL() as URL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = Int(CMTimeGetSeconds(audioDuration))
        FireBaseManager.handleRecordedAudioForUrl(url: asset.url as NSURL, audioDuration: audioDurationSeconds)
    }
    
    func preparePlayer(){
        var error: NSError?
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
        catch let err as NSError {
            error = err
            print(error!)
        }
    }
    
    func setupRecorder() {
        
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey: 320000,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as [String : Any]
        
        var error: NSError?
        do {
            soundRecorder = try AVAudioRecorder(url: getFileURL() as URL, settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch let err as NSError  {
            error = err
            print(error!)
        }
        
    }
    
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    
    }
    
    func getFileURL() -> NSURL{
        let path = getCacheDirectory().appending(fileName)
        
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
    }

}

