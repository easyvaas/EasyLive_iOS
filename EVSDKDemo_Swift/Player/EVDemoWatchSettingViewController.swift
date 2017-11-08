//
//  EVDemoWatchSettingViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/9.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit

class EVDemoWatchSettingViewController: UIViewController {
  
  private var isLive: Bool = true
  private let kEVWatchLive = "EVWatchLive"
  private let kEVWatchRecord = "EVWatchRecord"
  private let kEVWatchVR = "EVWatchVR"
  
  @IBOutlet weak var liveBtn: UIButton!
  @IBOutlet weak var recordBtn: UIButton!
  @IBOutlet weak var vrBtn: UIButton!
  @IBOutlet weak var inputTF: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    liveBtn.isSelected = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func scanQR(_ sender: UIBarButtonItem) {
    let scanVC = EVScanQRViewController()
    scanVC.getQrCode = { [weak self] (string: String?) in
      guard let sSelf = self, !(string?.isEmpty)! else {
        return
      }
      
      sSelf.inputTF.text = string
    }
    self.present(scanVC, animated: true, completion: nil)
  }
  
  @IBAction func liveBtnClicked(_ sender: UIButton) {
    sender.isSelected = true
    recordBtn.isSelected = false
    isLive = true
  }
  
  @IBAction func recordBtnClicked(_ sender: UIButton) {
    sender.isSelected = true
    liveBtn.isSelected = false
    isLive = false
  }
  
  @IBAction func vrBtnClicked(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      inputTF.placeholder = "请输入VR视频的URL"
    } else {
      inputTF.placeholder = "请输入视频的lid"
    }
  }
  
  @IBAction func watchVideo(_ sender: UIButton) {
    var segueId = kEVWatchLive
    
    if isLive == false {
      segueId = kEVWatchRecord
    }
    
    if vrBtn.isSelected {
      segueId = kEVWatchVR
    }
    
    if (inputTF.text?.isEmpty)! {
      if vrBtn.isSelected {
        CCAlertManager.shareInstance().performComfirmTitle("提示", message: "未输入VR视频URL！", comfirmTitle: "OK", withComfirm: nil)
      } else {
        CCAlertManager.shareInstance().performComfirmTitle("提示", message: "未输入视频lid！", comfirmTitle: "OK", withComfirm: nil)
      }
    }
    
    self.performSegue(withIdentifier: segueId, sender: nil)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let lid = inputTF.text
    
    if segue.identifier == kEVWatchLive {
      let liveVC = segue.destination as! EVDemoWatchViewController
      liveVC.lid = lid!
    } else if segue.identifier == kEVWatchRecord {
      let watchVC = segue.destination as! EVDemoWatchRecordViewController
      watchVC.lid = lid!
    } else if segue.identifier == kEVWatchVR {
      let vrVC = segue.destination as! EVWatchVRViewController
      vrVC.urlString = lid!
    }
  }
  
}
