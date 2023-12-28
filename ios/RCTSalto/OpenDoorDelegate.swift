//
//  RNSaltoKSIOS.swift
//  RNSaltoKS
//

import ClaySDK
import SaltoJustINMobileSDK

class MyOpenDoorDelegate: NSObject, ClaySDK.DigitalKeyDelegate {
  
  var sendEvent: (String, String?)->();
  let openDoorEventSuccess = "openDoorEventSuccess";
  let openDoorEventFound = "openDoorEventFound";
  let openDoorEventFailed = "openDoorEventFailed";
  let openDoorEventTimeout = "openDoorEventTimeout";
  let openDoorEventAlreadyRunning = "openDoorEventAlreadyRunning";
  
  init(_ event :@escaping (String, String?)->()) {
    self.sendEvent = event;
  }
  
  func onLockFound() {
    NSLog("nat mob DID FIND LOCK");
    sendEvent(openDoorEventFound, "");
  }
  
  func onFailure(_ error: ClaySDK.ClayError) {
    switch error {
    case .processAlreadyRunningError:
      NSLog("nat mob ALREADY RUNNING");
      sendEvent(openDoorEventAlreadyRunning, "ALREADY_RUNNING");
    case .timeoutReachedError:
      NSLog("nat mob TIMEOUT");
      sendEvent(openDoorEventTimeout, "TIMEOUT");
    case .bluetoothNotAuthorizedError, .bluetoothNotSupportedError, .bluetoothNotInitializedError, .bluetoothFeatureNotEnabledError:
      NSLog("nat mob OPEN DOOR FAILED");
      sendEvent(openDoorEventFailed, "BLUETOOTH_ERROR");
    default:
      NSLog("nat mob EVENT FAILED");
      sendEvent(openDoorEventFailed, error.localizedDescription);
    }
  }
  
  func onSuccess(_ result: ClaySDK.ClayResult, message: String?) {
    switch result {
    case .success:
      // key successfully sent to lock (we don't know if user have access, access is indicated by light of the lock)
      NSLog("nat mob SUCCESS");
      sendEvent(openDoorEventSuccess, "");
    case .cancelled:
      NSLog("nat mob FAILED: Digital Key needs to be reactivated");
      sendEvent(openDoorEventFailed, message);
      //view?.showStatus(message: "Digital Key needs to be reactivated")
      //updateDeviceCertificate()
    case .failure:
      NSLog("nat mob FAILED: Something went wrong: \(message ?? "No reason found")");
      sendEvent(openDoorEventFailed, message);
    @unknown default:
      NSLog("nat mob FAILED: Something went terribly wrong");
      sendEvent(openDoorEventFailed, message);
    }
  }
}
