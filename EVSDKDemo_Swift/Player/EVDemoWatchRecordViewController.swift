//
//  EVDemoWatchRecordViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/10.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit
import EVMediaFramework

class EVDemoWatchRecordViewController: UIViewController {
  
  var lid = ""
  fileprivate var player: EVPlayer?
  fileprivate var timer: Timer?
  fileprivate var stateBtn: UIButton?
  fileprivate var progressView: EVProgressView?
  fileprivate var containerView: UIView?
  fileprivate let width = UIScreen.main.bounds.width
  fileprivate let height = UIScreen.main.bounds.height
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configUI()
    self.setupPlayer()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func close(_ sender: Any) {
    if player != nil {
      player?.shutDown()
      player = nil
    }
    
    self.stopTimer()
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func resizePlayer(_ sender: UIButton) {
    let halfFrame = CGRect(x: width/2, y: 0, width: width/2, height: height/2)
    let originFrame = CGRect(x: 0, y: 0, width: width, height: height)
    
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      player?.playerViewFrame = halfFrame
    } else {
      player?.playerViewFrame = originFrame
    }
  }
  
  private func configUI() {
    
    stateBtn = UIButton.init(type: .custom)
    stateBtn?.frame = CGRect(x: 10, y: height - 60, width: 40, height: 30)
    stateBtn?.setTitle("播放", for: .selected)
    stateBtn?.setTitle("暂停", for: .normal)
    stateBtn?.addTarget(self, action: #selector(stateBtnAction(_:)), for: .touchUpInside)
    stateBtn?.backgroundColor = UIColor.lightGray
    view.addSubview(stateBtn!)
    
    progressView = EVProgressView()
    progressView?.frame = CGRect(x: (stateBtn?.frame.origin.x)! + (stateBtn?.frame.width)! + 10, y: height - 60, width: width - 70, height: 30)
    view.addSubview(progressView!)
    
    containerView = UIView(frame: view.frame)
    view.insertSubview(containerView!, at: 0)
  }
  
  private func setupPlayer() {
    player = EVPlayer()
    player?.playerContainerView = containerView
    player?.live = false
    player?.lid = lid
    player?.delegate = self as EVPlayerDelegate
    
    player?.playPrepareComplete({ [weak self] (code: EVPlayerResponseCode, info: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if code == .okay {
        sSelf.player?.play()
      } else {
        print("录播播放失败:\(String(describing: error?.localizedDescription))")
      }
    })
    
    self.startTimer()
    
    progressView?.dragingSliderCallback = { [weak self] (progress: Float) in
      guard let sSelf = self, let sPlayer = sSelf.player else {
        return
      }
      
      let seekPos = Double(progress) * sPlayer.duration
      sPlayer.seek(to: seekPos)
    }
  }
  
  @objc private func stateBtnAction(_ btn: UIButton) {
    if btn.isSelected {
      player?.play()
    } else {
      player?.pause()
    }
    
    btn.isSelected = !btn.isSelected
  }
  
}

// MARK: - Timer
extension EVDemoWatchRecordViewController {
  fileprivate func startTimer() {
    guard timer == nil else {
      return
    }
    
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateState(_:)), userInfo: nil, repeats: true)
  }
  
  fileprivate func stopTimer() {
    guard timer != nil else {
      return
    }
    
    timer?.invalidate()
    timer = nil
  }
  
  @objc private func updateState(_ timer: Timer) {
    guard player != nil else {
      return
    }
    
    let duration: Float = Float((player?.duration)!)
    let playableDuration: Float = Float((player?.playableDuration)!)
    
    if duration > 0 {
      progressView?.cacheProgress = playableDuration / duration
    } else {
      progressView?.cacheProgress = 0.0
    }
    
    progressView?.totalTimeInSeconds = duration
    progressView?.playProgress = Float((player?.currentPlaybackTime)! / (player?.duration)!)
  }
}

// MARK: - EVPlayerDelegate
extension EVDemoWatchRecordViewController: EVPlayerDelegate {
  func evPlayerFirstVideoFrameDidRender(_ player: EVPlayer!) {
    print("第一帧已渲染")
  }
  
  func evPlayerDidFinishPlay(_ player: EVPlayer!, reason: MPMovieFinishReason) {
    print("播放完毕")
  }
  
  func evPlayer(_ player: EVPlayer!, cacheState state: EVPlayerCacheState) {
    print("缓冲状态:\(state)")
  }
}
