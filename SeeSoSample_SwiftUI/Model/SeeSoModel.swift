//
//  SeeSoModel.swift
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
  @Published var isDetailOptionOn:Bool = false
  
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
      loadSavedCalibrationData()
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
    if isDetailOptionOn {
      userOptions.attentionData.append(AttentionModel(score: score))
    } else {
      userOptions.attentionData = []
    }
  }
  func onBlink(timestamp: Int, isBlinkLeft: Bool, isBlinkRight: Bool, isBlink: Bool, eyeOpenness: Double) {
    if isBlink && !blinking {
      userOptions.blinked = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
        self?.userOptions.blinked = false
        self?.blinking = false
      }
    }
    let model = BlinkModel(isBlinkLeft: isBlinkLeft,
                           isBlinkRight: isBlinkRight,
                           isBlink: isBlink,
                           eyeOpenness: eyeOpenness)
    if isDetailOptionOn {
    userOptions.blinkData.append(model)
    } else {
      userOptions.blinkData = []
    }
  }
  func onDrowsiness(timestamp: Int, isDrowsiness: Bool) {
    userOptions.isSleepy = isDrowsiness
    
    if isDetailOptionOn {
      userOptions.drowsinessData.append(DrowsinessModel(timestamp:timestamp, isDrowsiness: isDrowsiness))
    } else {
      userOptions.drowsinessData = []
    }
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
      if let result = self.tracker?.startCollectSamples() {
        print("startCollectSamples called \(result)")
      }
    }
  }
  func onCalibrationFinished(calibrationData: [Double]) {
    savedCaliData = calibrationData
    isCalibrating = false
  }
}

// MARK: - Sample Data Helper
extension SeeSoModel {
  // View Design
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
  
  // Calibration Data Save
  func saveCalibrationDataToLocal() {
    UserDefaults.standard.set(savedCaliData, forKey: KEY_CALIBRATION_DATA)
    savedCaliData = []
  }
  func loadSavedCalibrationData() {
    if let calibData = UserDefaults.standard.array(forKey: KEY_CALIBRATION_DATA) as? [Double] {
      let _ = tracker?.setCalibrationData(calibrationData: calibData)
    }
  }
  
  // Example for User Info Data Control
  var averageAttentionScore: Double {
    if userOptions.attentionData.isEmpty {
      return 0
    } else {
      let sum:Double = userOptions.attentionData.reduce(Double.zero, {
        return $0 + $1.score
      })
      return (sum / Double(userOptions.attentionData.count))*100
    }
  }
  var attentionCheckCount: Int {
    return userOptions.attentionData.count
  }
  var leftBlinkCount: Int {
    return userOptions.blinkData.reduce(0) {
      return $0 + ($1.isBlinkLeft ? 1 : 0)
    }
  }
  var rightBlinkCount: Int {
    return userOptions.blinkData.reduce(0) {
      return $0 + ($1.isBlinkRight ? 1 : 0)
    }
  }
  var blinkCount: Int {
    return userOptions.blinkData.reduce(0) {
      return $0 + ($1.isBlink ? 1 : 0)
    }
  }
  var averageEyeOpenness: Double {
    let sum:Double = userOptions.blinkData.reduce(Double.zero, {
      return $0 + $1.eyeOpenness
    })
    return sum / Double(userOptions.blinkData.count)
  }
}
