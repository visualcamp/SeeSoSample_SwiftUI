//
//  ViewController.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import Foundation
import SeeSo
import AVFoundation
import SwiftUI

typealias seeSoCoordi = (Double,Double)

final class SeeSoModel: ObservableObject {
  
  // License Key
  private let licenseKey: String = "Input License Key"
  
  // Init State Control
  @Published var initState: TrackerInitState = .default
  @Published var isInitWithUserOption: Bool = false
  
  // Calibration Control
  @Published var isCalibrating: Bool = false
  @Published var caliMode: CalibrationMode = .FIVE_POINT
  @Published var caliProgress: Double = 0
  @Published var caliPosition: seeSoCoordi = (0,0)
  @Published var savedCaliData : [Double] = []
  
  // Gaze Tracking Control
  @Published var isGazeTracking: Bool = false
  @Published var gazePoint: seeSoCoordi = (0,0)
  private var tracker: GazeTracker? = nil
  
  // User Options
  var customAttentionInterval: Int = 10
  @Published var userOptions = UserOptionsModel.default
  private var blinking: Bool = false
  
  func initGazeTracker() {
    if isCameraAccessAllowed {
      self.initState = .initializing
      
      DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {
        let options = UserStatusOption()
        if self.isInitWithUserOption {
          options.useAll()
        }
        GazeTracker.initGazeTracker(license: self.licenseKey, delegate: self,option: options)
        
      }
    } else {
      requestAccess()
    }
  }
  public func deinitGazeTracker() {
    tracker?.statusDelegate = nil
    tracker?.gazeDelegate = nil
    GazeTracker.deinitGazeTracker(tracker: tracker)
    tracker = nil
    
    initState = .default
    userOptions = UserOptionsModel.default
    isGazeTracking = false
    isCalibrating = false
  }
  // initial error check
  private var errors : InitializationError = .ERROR_NONE
  public func getInitializedError() -> String {
    errors.description
  }
  
  // Calibration
  @MainActor
  public func toggleCalibrtation() {
    let wasCali = isCalibrating
    isCalibrating.toggle()
    if wasCali {
      tracker?.stopCalibration()
    } else {
      guard let result = tracker?.startCalibration(mode: caliMode, criteria: .DEFAULT) else { return }
      if !result {
        print("Calibration Start failed.")
      }
    }
  }
  
  // Gaze tracking Control
  public func toggleTracking() {
    isGazeTracking ? tracker?.stopTracking() : tracker?.startTracking()
  }
  
  // Camera Authorization Check
  var isCameraAccessAllowed: Bool {
    return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
  }
  private func requestAccess() {
    AVCaptureDevice.requestAccess(for: AVMediaType.video) {
      response in
      if response {
        self.initGazeTracker()
      } else {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
          DispatchQueue.main.async {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
          }
        }
      }
    }
  }
}
// MARK: - String Helper
extension SeeSoModel {
  var initBtnHeaderText: Text {
    return Text(initState != .succeed ? HEADER_INIT_STOPPED : isInitWithUserOption ? HEADER_INIT_STARTED_WITH_OPTION : HEADER_INIT_STARTED)
  }
  var initBtnFooter: Text? {
    return (initState == .succeed && !isInitWithUserOption) ? Text( FOOTER_INIT_NO_OPTION) : nil
  }
  var trackBtnHeader: Text {
    return Text(isGazeTracking ? HEADER_TRACK_STARTED : HEADER_TRACK_STOPPED)
  }
  var trackBtnTitle: String {
    return isGazeTracking ? LIST_TRACK_STARTED : LIST_TRACK_STOPPED
  }
  var caliBtnFooter: Text? {
    return isCalibrating ? nil : Text(FOOTER_CALIB)
  }
  var calibBtnTitle: String {
    return isCalibrating ? LIST_CALIB_STARTED : LIST_CALIB_STOPPED
  }
}
// MARK: - Initial Delegate
extension SeeSoModel: InitializationDelegate {
  func onInitialized(tracker: GazeTracker?, error: InitializationError) {
    if tracker != nil {
      self.tracker = tracker
      self.tracker?.setDelegates(statusDelegate: self,
                                 gazeDelegate: self,
                                 calibrationDelegate: self,
                                 imageDelegate: nil,
                                 userStatusDelegate: self)
      
      // Default interval of checking attention score is once in 30 seconds
      self.tracker?.setAttentionInterval(interval: 10)
      self.initState = .succeed
    } else {
      self.errors = error
      self.initState = .failed
      print(error)
    }
    print("initState = \(initState)")
  }
}
// MARK: - Gaze Data Delegate
// While gaze tracking is on, You can get coordinates of gaze through this delegate.
extension SeeSoModel: GazeDelegate {
  func onGaze(gazeInfo: GazeInfo) {
    if gazeInfo.trackingState == .SUCCESS {
      gazePoint.0 = gazeInfo.x
      gazePoint.1 = gazeInfo.y
    }
  }
}
// MARK: - Gaze Data Delegate
// You can check state of tracking with this delegate.
extension SeeSoModel: StatusDelegate {
  func onStarted() {
    isGazeTracking = true
  }
  func onStopped(error: StatusError) {
    isGazeTracking = false
  }
}
// MARK: - User State Delegate
// While gaze tracking is on, You can get detail infomation of user state through this delegate.
extension SeeSoModel: UserStatusDelegate {
  func onAttention(timestampBegin: Int, timestampEnd: Int, score: Double) {
    userOptions.recentAttentionScore = Int(score*100)
  }
  func onBlink(timestamp: Int, isBlinkLeft: Bool, isBlinkRight: Bool, isBlink: Bool, eyeOpenness: Double) {
    if isBlinkLeft && !blinking {
      userOptions.blinked = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
        self?.userOptions.blinked = false
        self?.blinking = false
      }
    }
  }
  func onDrowsiness(timestamp: Int, isDrowsiness: Bool) {
    userOptions.isSleepy = isDrowsiness
  }
}
// MARK: - Calibration Delegate
// You can manage Calibration progress with this delegate.
extension SeeSoModel: CalibrationDelegate {
  func onCalibrationProgress(progress: Double) {
    caliProgress = progress
  }
  func onCalibrationNextPoint(x: Double, y: Double) {
    caliPosition = (x,y)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      if let _ = self.tracker?.startCollectSamples() {
      }
    }
  }
  func onCalibrationFinished(calibrationData: [Double]) {
    isCalibrating = false
  }
}
