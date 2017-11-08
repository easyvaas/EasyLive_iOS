
//
//  EVDemoWatchViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/10.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit
import EVMediaFramework

class EVDemoWatchViewController: UIViewController {
  
  var lid = ""
  fileprivate var player: EVPlayer?
  fileprivate var streamer: EVStreamer?
  private let kAgoraId = ""
		
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var containerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupPlayer()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func close(_ sender: Any) {
    if streamer?.chatState == .remoteVideoRendered {
      streamer?.leaveChannel()
    } else {
      player?.shutDown()
    }
    
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func interactiveLive(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      player?.pause()
      
      if streamer == nil {
        streamer = EVStreamer()
        streamer?.delegate = self as EVStreamerDelegate
        streamer?.frontCamera = true
        containerView.addSubview((streamer?.preview!)!)
        streamer?.preview.frame = containerView.frame
        streamer?.agoraAppid = kAgoraId
        streamer?.livePrepareComplete(nil)
        streamer?.startPreview()
      }
      
      if (streamer?.agoraAppid.isEmpty)! {
        CCAlertManager.shareInstance().performComfirmTitle("提示", message: "请先设置agoraAppid", comfirmTitle: "OK", withComfirm: nil)
        return
      }
      
      streamer?.joinChannel("evtest002")
    } else {
      streamer?.leaveChannel()
    }
  }
  
  private func setupPlayer() {
    player = EVPlayer()
    player?.playerContainerView = containerView
    player?.live = true
    player?.lid = lid
    
    player?.playPrepareComplete { [weak self] (code: EVPlayerResponseCode, info: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if code == .okay {
        sSelf.player?.play()
      } else {
        print("获取直播地址失败：\(String(describing: error?.localizedDescription))")
      }
    }
  }
  
  
}


extension EVDemoWatchViewController: EVStreamerDelegate {
  func evStreamerUpdate(_ chatState: EVVideoChatState) {
    if chatState == .channelLeaved {
      streamer?.stopPreview()
      streamer?.preview.removeFromSuperview()
      streamer = nil
      player?.play()
    }
  }
}
