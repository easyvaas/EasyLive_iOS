//
//  EVDemoRootViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 17/5/19.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import EVSDKBaseFramework
import EVMessageFramework

class EVDemoRootViewController: UIViewController {
  @IBOutlet weak var appIDTF: UITextField!
  @IBOutlet weak var appKeyTF: UITextField!
  @IBOutlet weak var appSecreteTF: UITextField!
  @IBOutlet weak var userIDTF: UITextField!
  @IBOutlet weak var SDKVersionLabel: UILabel!
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.addEVObserver()
    SDKVersionLabel.text = "SDK Version:\(EVSDKManager.sdkVersion())"
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if EVSDKManager.isSDKInitedSuccess() {
      return true
    }
    
    CCAlertManager.shareInstance().performComfirmTitle(nil, message: "SDK尚未初始化！", comfirmTitle: "OK", withComfirm: nil)
    return false
  }
  
  @IBAction func initSDKAction(_ sender: Any) {
    EVSDKManager.initSDK(withAppID: appIDTF.text!, appKey: appKeyTF.text!, appSecret: appSecreteTF.text!, userID: userIDTF.text!)
  }
}

// MARK: - 注册SDK
extension EVDemoRootViewController {
  fileprivate func addEVObserver() {
    NotificationCenter.default.addObserver(forName: .EVSDKInitSuccess, object: nil, queue: OperationQueue.main, using: { _ in
      CCAlertManager.shareInstance().performComfirmTitle("初始化成功", message: nil, comfirmTitle: "OK", withComfirm: nil)
      print("SDK 初始化成功")
    })
    
    NotificationCenter.default.addObserver(forName: .EVSDKInitError, object: nil, queue: OperationQueue.main, using: { notify in
      print("SDK 初始化失败")
      CCAlertManager.shareInstance().performComfirmTitle(notify.name.rawValue, message: String(format: "%@", notify.object as! CVarArg), comfirmTitle: "ok", withComfirm: nil)
    })
  }
}
