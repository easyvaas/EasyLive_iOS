//
//  EVDemoMessageViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/9.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit
import EVMessageFramework
import EVSDKBaseFramework

class EVDemoMessageViewController: UIViewController {
  
  @IBOutlet weak var channelTF: UITextField!
  @IBOutlet weak var messageTF: UITextField!
  @IBOutlet weak var messageShowStage: UITextView!
  
  fileprivate var showText: String? = ""
  fileprivate var isConnected: Bool = false
  
  deinit {
    EVMessageManager.share().closeConnect()
    EVMessageManager.share().delegate = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messageTF.delegate = self
    EVMessageManager.share().delegate = self
    
    self.refresh()
  }
  
  @IBAction func clearTextView(_ sender: Any) {
    showText = ""
  }
  
  @IBAction func joinChannel(_ sender: Any) {
    guard let channel = channelTF.text else {
      return
    }
    self.appendCurrentUserWithText("connecting in channel:\(channel)")
    
    EVMessageManager.share().connect(channel)
  }
  
  @IBAction func sendMessage(_ sender: Any) {
    guard self.validOfSocket(),
      let channel = channelTF.text,
      let msg = messageTF.text else {
      return
    }
    
    self.appendCurrentUserWithText(">\(msg)")
    
    let ext = ["exct":
      ["nk": "布拉德皮蛋!@#$%"]
    ]
    
    EVMessageManager.share().send(withChannel: channel, message: msg, userData: ext, type: .msg, result: { [weak self] (response: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if error != nil {
        sSelf.appendCurrentUserWithText("Failed send message with error :\(String(describing: error?.localizedDescription))")
      }
    })
  }
  
  @IBAction func leaveChannel(_ sender: Any) {
    guard self.validOfSocket(), let channel = channelTF.text else {
      return
    }
    
    self.appendCurrentUserWithText("Leaving channel:\(channel)")
    
    EVMessageManager.share().leave(withChannel: channel, result: { [weak self] (response: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if error == nil {
        sSelf.appendCurrentUserWithText("Success leave channel:\(channel)")
      }
    })
  }
  
  @IBAction func getRecentHistory(_ sender: Any) {
    guard self.validOfSocket(), let channel = channelTF.text else {
      return
    }
    
    EVMessageManager.share().getLastHistoryMessage(withChannel: channel, count: 20, type: .msg, result: { [weak self] (response: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if error == nil && response != nil {
        let list: NSArray = response!["content"] as! NSArray
        list.enumerateObjects({ (obj, idx, stop) in
          let model: EVMessageModel = obj as! EVMessageModel
          self?.appendCurrentUserWithText("\nuserid: \(model.userID)\ncontext: \(model.context)\nmessageType: \(model.type)\nuserData: \(model.userData)")
        })
        
        self?.appendCurrentUserWithText("以下为最近的历史消息")
      } else {
        sSelf.appendCurrentUserWithText("history error:\(channel)")
      }
    })
                                                   
  }
  
  @IBAction func like(_ sender: Any) {
    guard self.validOfSocket(), let channel = channelTF.text else {
      return
    }
    
    let likeNum: Int = 10
    self.appendCurrentUserWithText(">add like:\(likeNum)")
    EVMessageManager.share().addLikeCount(withChannel: channel, count: UInt(likeNum), result: { [weak self] (response: [AnyHashable : Any]?, error: Error?) in
      guard let sSelf = self else {
        return
      }
      
      if error != nil {
        sSelf.appendCurrentUserWithText("Failed add like count with error :\(String(describing: error?.localizedDescription))")
      }
    })
  }
}

extension EVDemoMessageViewController {
  fileprivate func refresh() {
    DispatchQueue.global().async {
      repeat {
        DispatchQueue.main.async { [weak self] in
          guard let sSelf = self else {
            return
          }
          sSelf.messageShowStage.text = sSelf.showText
        }
        Thread.sleep(forTimeInterval: 1)
      } while(true)
    }
  }
  
  fileprivate func appendUser(user: String, text: String) {
    let time = self.currentTime()
    showText = "\(user):\(time)\r\(text)\r\r\n".appending(showText!)
  }
  
  fileprivate func appendCurrentUserWithText(_ text: String) {
    self.appendUser(user: EVSDKManager.userID(), text: text)
  }
  
  private func currentTime() -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd HH:mm:ss"
    
    return format.string(from: Date())
  }
  
  fileprivate func validOfSocket() -> Bool {
    if isConnected == false {
      CCAlertManager.shareInstance().performComfirmTitle("提示", message: "请先点击‘join’加入该聊天服务器！", comfirmTitle: "OK", withComfirm: nil)
    }
    
    return isConnected
  }
  
}

extension EVDemoMessageViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.sendMessage(UIButton())
    view.endEditing(true)
    
    return true
  }
}

extension EVDemoMessageViewController: EVMessageProtocol {
  func evMessageConnected() {
    isConnected = true
    self.appendCurrentUserWithText("connected!")
  }
  
  func evMessageConnectError(_ error: Error!) {
    self.appendCurrentUserWithText("connect failed!")
    if error != nil {
      self.appendCurrentUserWithText(error.localizedDescription)
    }
  }
  
  func evMessageDidClose(with code: EVMessageErrorCode, reason: String!) {
    isConnected = false
    
    if code != .none {
      self.appendCurrentUserWithText("connect closed with code:\(code) reason:\(reason)")
    }
  }
  
  func evMessageRecievedNewMessage(inChannel channel: String!, sendedFrom userid: String!, message: String!, userData: [AnyHashable : Any]!) {
    self.appendUser(user: userid, text: "<-channel:\(channel) \ruserid:\(userid) \rmessage:\(message) \ruserdata:\(userData)")
  }
  
  func evMessageUsers(_ userids: [String]!, joinedChannel channel: String!) {
    self.appendCurrentUserWithText("\(userids.first!), 来了!")
  }
  
  func evMessageUsers(_ userids: [String]!, leftChannel channel: String!) {
    self.appendCurrentUserWithText("\(userids.first!), 离开了!")
  }
  
  func evMessageDidUpdateLikeCount(_ likeCount: Int64, inChannel channel: String!) {
    self.appendCurrentUserWithText("<-channel:\(channel) \rlike count:\(likeCount)")
  }
  
  func evMessageDidUpdateWatchingCount(_ watchingCount: Int, inChannel channel: String!) {
    self.appendCurrentUserWithText("<-channel:\(channel) \rwatching count:\(watchingCount)")
  }
  
  func evMessageDidUpdateWatchedCount(_ watchedCount: Int, inChannel channel: String!) {
    self.appendCurrentUserWithText("<-channel:\(channel) \rwatched count:\(watchedCount)")
  }
}
