//
//  EVSocketManager.swift
//  CentrifugeDemo
//
//  Created by Lcrnice on 2017/6/12.
//  Copyright © 2017年 Easyvaas. All rights reserved.
//

import Foundation

public class CentrifugeManager: NSObject, ELInnerCentrifugeClientDelegate, ELInnerCentrifugeChannelDelegate, ELInnerResponseMessageDelegate  {
    
    //MARK:- Interactions with server
    var manager: InnerManager!
    public var channel: String {
        get {
            return manager.channel
        }
        set (newValue) {
            manager.channel = newValue
        }
    }
    
    //MARK: Delegates
    public var clientDelegate: ELPublicCentrifugeClientDelegate!
    public var channelDelegate: ELPublicCentrifugeChannelDelegate!
    public var errorDelegate: ELPublicResponseMessageDelegate!
    
    convenience public init(url: String, channel: String, user: String, token: String, timeStamp: String) {
        self.init()
        manager = InnerManager.init(kURL: url, kChannel: channel, kUser: user, kToken: token, kTimeStamp: timeStamp)
        manager.innerChannelDelegate = self;
        manager.innerClientDelegate = self;
        manager.innerErrorDelegate = self;
        
        self.channel = channel
    }
    
    //MARK: actions
    public func sendMessage(message: String) {
        manager.sendMessage(msg: message)
    }
    
    public func connnect() {
        manager.connect()
    }
    
    public func disconnect() {
        manager.disconnect()
    }
    
    public func joinChannel() {
        manager.joinChannel()
    }
    
    public func leaveChannel() {
        manager.leaveChannel()
    }
    
    
    
    //MARK: ELInnerCentrifugeClientDelegate
    public func client(didReceiveError error: NSError) {
        self.clientDelegate.client(didReceiveError: error)
    }
    public func client(didReceiveRefresh uid: String?, error: String?, body: [String : Any]?) {
        self.clientDelegate.client(didReceiveRefresh: uid, error: error, body: body)
    }
    public func client(didDisconnect uid: String?, error: String?, body: [String : Any]?) {
        self.clientDelegate.client(didDisconnect: uid, error: error, body: body)
    }
    public func client(didSendMessage uid: String?, error: NSError?, body: [String : Any]?) {
        self.clientDelegate.client(didSendMessage: uid, error: error, body: body)
    }
    
    //MARK: ELInnerCentrifugeChannelDelegate
    public func client(didReceiveMessageInChannel channel: String, uid: String?, error: String?, body: [String : Any]?) {
        self.channelDelegate.client(didReceiveMessageInChannel: channel, uid: uid, error: error, body: body)
    }
    public func client(didReceiveJoinInChannel channel: String, uid: String?, error: String?, body: [String : Any]?) {
        self.channelDelegate.client(didReceiveJoinInChannel: channel, uid: uid, error: error, body: body)
    }
    public func client(didReceiveLeaveInChannel channel: String, uid: String?, error: String?, body: [String : Any]?) {
        self.channelDelegate.client(didReceiveLeaveInChannel: channel, uid: uid, error: error, body: body)
    }
    public func client(didReceiveUnsubscribeInChannel channel: String, uid: String?, error: String?, body: [String : Any]?) {
        self.channelDelegate.client(didReceiveUnsubscribeInChannel: channel, uid: uid, error: error, body: body)
    }
    
    //MARK: ELPublicResponseMessageDelegate
    public func client(didReceiveResponseMessage uid: String?, error: String?, body: [String : Any]?, method: CentrifugeMethod) {
        let methodStr: String? = method.rawValue
        self.errorDelegate.client(didReceiveResponseMessage: uid, error: error, body: body, method: methodStr!)
    }
}
