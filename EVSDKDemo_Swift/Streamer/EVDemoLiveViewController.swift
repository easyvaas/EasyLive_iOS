//
//  EVDemoLiveViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/10.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit
import EVMediaFramework
import EVSDKBaseFramework

class EVDemoLiveViewController: UIViewController {
  
  /// public
  var videoBitrate: UInt = 0
  var audioBitrate: EVStreamerAudioBitrate = ._48
  var mute: Bool = false
  var frontCamera: Bool = false
  var beauty: Bool = false

  /// IBOutlets
  @IBOutlet weak var vidLbl: UILabel!
  @IBOutlet weak var chatBtn: UIButton!
  @IBOutlet weak var muteBtn: UIButton!
  @IBOutlet weak var frontCameraBtn: UIButton!
  @IBOutlet weak var flashlightBtn: UIButton!
  @IBOutlet weak var beautyBtn: UIButton!
  @IBOutlet weak var musicBtn: UIButton!
  
  /// private vars
  fileprivate var streamer: EVStreamer!
  fileprivate var vid: String?
  fileprivate var currentBeautyLevel: Int = 3
  fileprivate var isBeautyEnable: Bool = true
  fileprivate var musicNeedContinue: Bool = false
  fileprivate static let kAgoraId = ""
  
  deinit {
    streamer.shutDown()
    streamer.delegate = nil
    UIApplication.shared.isIdleTimerDisabled = true
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configUI()
    self.setupEncoder()
    self.addLiveObserver()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func interactiveLive(_ sender: UIButton) {
    guard streamer.agoraAppid != nil && streamer.agoraAppid.isEmpty == false else {
      CCAlertManager.shareInstance().performComfirmTitle("提示", message: "请先设置agoraAppid", comfirmTitle: "OK", withComfirm: nil)
      return
    }
    
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      streamer.joinChannel("evtest002")
    } else {
      streamer.leaveChannel()
    }
  }
  
  @IBAction func mute(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    streamer.muteStream(sender.isSelected)
  }
  
  @IBAction func switchCamera(_ sender: UIButton) {
    let front = !sender.isSelected
    if front {
      flashlightBtn.isSelected = false
    }
    
    sender.isUserInteractionEnabled = false
    sender.isSelected = streamer.swithCamera() ? front : !front
    sender.isUserInteractionEnabled = true
  }
  
  @IBAction func switchLight(_ sender: UIButton) {
    if frontCameraBtn.isSelected {
      return
    }
    
    sender.isSelected = !sender.isSelected
    streamer.turn(onFlashLight: sender.isSelected)
  }
  
  @IBAction func switchBeauty(_ sender: UIButton) {
    let configBeautyVC = EVConfigBeautyLevelViewController.instanceVC()
    configBeautyVC.index = currentBeautyLevel - 1
    configBeautyVC.isBeautyEnable = isBeautyEnable
    configBeautyVC.segValueChanged = { [weak self] (index: Int) in
      guard let sSelf = self else {
        return
      }
      sSelf.currentBeautyLevel = index
      sSelf.streamer.configBeautyLevel(index)
    }
    configBeautyVC.switchValueChanged = { [weak self] (on: Bool) in
      guard let sSelf = self else {
        return
      }
      sSelf.streamer.enableFaceBeauty(on)
      sSelf.isBeautyEnable = on
    }
    configBeautyVC.showInViewController(parentViewController: self)
  }
  
  @IBAction func switchMusic(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    musicNeedContinue = sender.isSelected
    
    if sender.isSelected {
      let path = Bundle.main.path(forResource: "zebra", ofType: "mp3")
      streamer.bgmPlay(withPath: path)
    } else {
      streamer.bgmPause()
    }
  }
  
  @IBAction func changeVolume(_ sender: UISlider) {
    streamer.bgmVolume = sender.value
  }
  
  @IBAction func generateQR(_ sender: Any) {
    guard vidLbl.text != nil else {
      print("没有lid")
      return
    }
    
    let qrVC = EVGenerateQRViewController()
    qrVC.infoString = vidLbl.text
    self.present(qrVC, animated: true, completion: nil)
  }
  
  @IBAction func close(_ sender: Any) {
    if streamer.chatState == .remoteVideoRendered {
      CCAlertManager.shareInstance().performComfirmTitle("提示", message: "请先结束连麦", cancelButtonTitle: "取消", comfirmTitle: "确定", withComfirm: { [weak self] in
        guard let sSelf = self else {
          return
        }
        
        sSelf.streamer.leaveChannel()
        sSelf.chatBtn.isSelected = !sSelf.chatBtn.isSelected
      }, cancel: nil)
      
      return
    }
    
    CCAlertManager.shareInstance().performComfirmTitle("提示", message: "是否停止当前直播?", cancelButtonTitle: "取消", comfirmTitle: "确定", withComfirm: { [weak self] in
      guard let sSelf = self else {
        return
      }
      
      sSelf.streamer.shutDown()
      sSelf.dismiss(animated: true, completion: nil)
    }, cancel: nil)
  }
  
}

extension EVDemoLiveViewController {
  fileprivate func setupEncoder() {
    UIApplication.shared.isIdleTimerDisabled = false
    
    streamer = EVStreamer()
    view.insertSubview(streamer.preview, at: 0)
    streamer.delegate = self as EVStreamerDelegate
    streamer.videoBitrate = videoBitrate
    streamer.audioBitrate = audioBitrate
    streamer.mute = mute
    streamer.frontCamera = frontCamera
    streamer.enableFaceBeauty(beauty)
    streamer.agoraAppid = EVDemoLiveViewController.kAgoraId
    
    streamer.livePrepareComplete { [weak self] (code: EVStreamerResponseCode, result: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if code == .okay {
        sSelf.streamer.startPreview()
        sSelf.generateLid()
      } else {
        CCAlertManager.shareInstance().performComfirmTitle("开播失败", message: error?.localizedDescription, comfirmTitle: "OK", withComfirm: nil)
      }
    }
  }
  
  fileprivate func configUI() {
    muteBtn.isSelected = mute
    frontCameraBtn.isSelected = frontCamera
    isBeautyEnable = beauty
  }
  
  fileprivate func addLiveObserver() {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: { [weak self] _ in
      guard let sSelf = self else {
        return
      }
      
      if sSelf.musicNeedContinue {
        sSelf.streamer.bgmResume()
      }
    })
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: nil, using: { [weak self] _ in
      guard let sSelf = self else {
        return
      }
      
      if sSelf.musicNeedContinue {
        sSelf.streamer.bgmPause()
      }
    })
  }
  
  private func generateLid() {
    let appID = EVSDKManager.appID()
    let url = "http://api.video.easyvaas.com/v2/server/live/create?appid=\(appID)"
    EVNetRequestManager.httpGet(withUrl: url, moreHeaders: nil, success: { [weak self] (info: [AnyHashable : Any]?) in
      guard let sSelf = self else {
        return
      }
      
      print("generate lid info:\(String(describing: info))")
      let code: Int = info?["state"] as! Int
      if code == 0 {
        let content = info?["content"] as! [String : String]
        let lid = content["lid"]
        
        if lid?.isEmpty == false && lid != nil {
          self?.startLive(lid: lid!)
        }
      } else {
        sSelf.reloadLid()
      }
    }) { [weak self] (error: Error?) in
      guard let sSelf = self else {
        return
      }
      sSelf.reloadLid()
    }
  }
  
  private func reloadLid() {
    CCAlertManager.shareInstance().performComfirmTitle(nil, message: "获取lid失败", cancelButtonTitle: "确定", comfirmTitle: "重试", withComfirm: { 
      self.generateLid()
    }, cancel: nil)
  }
  
  private func startLive(lid: String) {
    vidLbl.text = lid
    streamer.lid = lid
    
    streamer.liveStartComplete { [weak self] (code: EVStreamerResponseCode, result: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if code == .okay {
        sSelf.streamer.startStream()
      } else {
        print("start live failed.")
      }
    }
  }
  
}


// MARK: - EVStreamerDelegate
extension EVDemoLiveViewController: EVStreamerDelegate {
  func evStreamerStreamStateChanged(_ state: EVVideoStreamerState) {
    switch state {
    case .streamIdle:
      print("闲置状态，未推流")
    case .streamConnecting:
      print("服务器连接中")
    case .streamConnected:
      print("开始推流")
      CCAlertManager.shareInstance().performComfirmTitle("开始推流", message: nil, comfirmTitle: "OK", withComfirm: nil)
    case .streamDisconnecting:
      print("断开连接")
    case .streamError:
      print("推流失败")
    }
  }
  
  func evStreamerBufferStateChanged(_ state: EVVideoStreamerStreamBufferState) {
    switch state {
    case .normal:
      print("正常推流")
    case .lv1:
      print("当前网络比较差，等级1，还可以坚持继续播")
    case .lv2:
      print("当前网络弱爆了，等级2，建议关闭直播")
    case .lv3:
      print("当前网络无法直播，可以直接掐掉了")
    }
  }
  
  func evStreamerUpdate(_ chatState: EVVideoChatState) {
    print("连麦状态:\(chatState)")
  }
  
}

