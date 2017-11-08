//
//  EVDemoLiveSettingViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/9.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit
import EVMediaFramework

class EVDemoLiveSettingViewController: UIViewController {
  
  @IBOutlet weak var btn_video_360x640: UIButton!
  @IBOutlet weak var btn_video_540x960: UIButton!
  @IBOutlet weak var btn_video_720x1280: UIButton!
  @IBOutlet weak var videoInitialBitrate: UITextField!
  @IBOutlet weak var audioBitrate: UISegmentedControl!
  @IBOutlet weak var audioHAAC: UIButton!
  @IBOutlet weak var muteBtn: UIButton!
  @IBOutlet weak var frontCameraBtn: UIButton!
  @IBOutlet weak var beautyBtn: UIButton!
  
  private var streamerSize: EVStreamFrameSize = ._default
  
  static let kStartLive = "startLive"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    btn_video_360x640.isSelected = true
    audioBitrate.selectedSegmentIndex = 1
    audioHAAC.isSelected = true
    frontCameraBtn.isSelected = true
    beautyBtn.isSelected = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func select_360x640(_ sender: UIButton) {
    sender.isSelected = true
    btn_video_540x960.isSelected = false
    btn_video_720x1280.isSelected = false
    streamerSize = ._360x640
  }
  
  @IBAction func select_540x960(_ sender: UIButton) {
    sender.isSelected = true
    btn_video_720x1280.isSelected = false
    btn_video_360x640.isSelected = false
    streamerSize = ._540x960
  }
  
  @IBAction func select_720x1280(_ sender: UIButton) {
    sender.isSelected = true
    btn_video_540x960.isSelected = false
    btn_video_360x640.isSelected = false
    streamerSize = ._720x1280
  }
  
  @IBAction func audioBitrate(_ sender: UISegmentedControl) {
  }
  
  @IBAction func useHightAAC(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func mute(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func beauty(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func frontCamera(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func startLive(_ sender: Any) {
    EVMediaAuth.checkAndRequestMicPhoneAndCameraUserAuthed({
      DispatchQueue.main.async {
        self.presentLiveVC()
      }
    }, userDeny: nil)
  }
  
  private func presentLiveVC() {
    let liveVC = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "EVDemoLiveViewController") as! EVDemoLiveViewController
    liveVC.videoBitrate = UInt(videoInitialBitrate.text!)!
    liveVC.audioBitrate = EVStreamerAudioBitrate(rawValue: UInt(audioBitrate.titleForSegment(at: audioBitrate.selectedSegmentIndex)!)!)!
    liveVC.mute = muteBtn.isSelected
    liveVC.frontCamera = frontCameraBtn.isSelected
    liveVC.beauty = beautyBtn.isSelected
    self.present(liveVC, animated: true, completion: nil)
  }  
}
