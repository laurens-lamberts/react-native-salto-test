//
//  RNSaltoKSIOS.swift
//  RNSaltoKS
//

import ClaySDK
import Foundation
import UIKit

struct MKey : Codable {
  var mkey_data:String = "";
}

@objc(RNSaltoKS)
class RNSaltoKS: RCTEventEmitter {
  
  let API_KEY: String! = "NO SALTO_PUBLIC_KEY";
  
  let SALTO_BASE_URL: String! = "NO SALTO_BASE_URL";
  let OPENDOOR_EVENT = "openDoorEvent";
  let MOBILE_STORAGE_KEY = "mobileKey";
  
  private var mKeys: [String:String] = [:]
  
  var hasListener: Bool = false
  
  var delegate: MyOpenDoorDelegate?;

  func didReceive(error: Error) {
  }

  override func supportedEvents() -> [String]! {
      return [OPENDOOR_EVENT]
  }
  @objc
  func initialize() {
    if(delegate === nil){
      delegate = MyOpenDoorDelegate(self.sendEvent);
    }
  }
  @objc
  func requiresMainQueueSetup() -> Bool {
    return true
  }
  override func startObserving() {
    initialize();
    hasListener = true
  }
  override func stopObserving() {
    hasListener = false
  }

  @objc
  func sendEvent(_ openDoorEventProperty: String, error: String? = "") {
     if hasListener {
      self.sendEvent(withName:OPENDOOR_EVENT, body:["eventName": openDoorEventProperty, "error": error]);
     }
  }
  
  @objc
  func getPublicKey(_ deviceId: String, resolver: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock)
  {
    var claySDK: Clay? = nil;
    do {
      claySDK = try Clay(installationUID: deviceId, apiKey: self.API_KEY)
      let publicKey = claySDK?.getPublicKey()
      resolver(publicKey);
    } catch {
      print(error)
      resolver(error.localizedDescription);
    }
  }
}
