//
//  EVWatchVRViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/10.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit
import EVVRFramework

class EVWatchVRViewController: UIViewController {
  
  var urlString = ""
  fileprivate var vrPlayer: EVVRPlayer?
		
  @IBOutlet weak var containerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    urlString = "http://media.qicdn.detu.com/@/70955075-5571-986D-9DC4-450F13866573/2016-05-19/573d15dfa19f3-2048x1024.m3u8"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    
    self.setupVRPlayer()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func close(_ sender: UIButton) {
    self.destoryVRPlayer()
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func switchMode(_ sender: UISegmentedControl) {
    let index = sender.selectedSegmentIndex
    vrPlayer?.mode = EVVRPlayerMode(rawValue: UInt(index))!
  }
  
  private func setupVRPlayer() {
    vrPlayer = EVVRPlayer(vrPlayerWithFrame: view.bounds)
    containerView.addSubview((vrPlayer?.renderView)!)
    vrPlayer?.renderView.backgroundColor = UIColor.clear
    vrPlayer?.delegate = self as EVVRPlayerDelegate
    vrPlayer?.play(withUrl: urlString, isliving: false)
  }
  
  private func destoryVRPlayer() {
    guard vrPlayer != nil else {
      return
    }
    
    vrPlayer?.shutdown()
    vrPlayer?.delegate = nil
    vrPlayer = nil
  }
}

extension EVWatchVRViewController: EVVRPlayerDelegate {
  func evVRPlayer(_ player: EVVRPlayer!, status: EVVRPlayerStatus) {
    switch status {
    case .prepared:
      vrPlayer?.play()
    case .end:
      vrPlayer?.stop()
    case .failed:
      vrPlayer?.stop()
    default:
      break
    }
  }
}
