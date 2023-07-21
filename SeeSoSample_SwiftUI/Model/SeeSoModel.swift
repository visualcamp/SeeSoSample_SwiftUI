//
//  SeeSoModel.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

import Foundation
import SeeSo
import AVFoundation
import SwiftUI

typealias seeSoCoordi = (Double,Double)

final class SeeSoModel: ObservableObject {
  
  // License Key
  private let licenseKey: String = "Input your license key here"
  
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
  var trackingFPS = 30
  
  // User Options
  var customAttentionInterval: Int = 10
  @Published var userOptions = UserOptionsModel.default
  private var leftBlinking: Bool = false
  private var rightBlinking: Bool = false
  @Published var isDetailOptionOn:Bool = false
  @Published var faceInfo:FaceInfo? 
  
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
    tracker?.setTrackingFPS(fps: trackingFPS)
    
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
  public func toggleCalibration() {
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
      self.tracker?.statusDelegate = self
      self.tracker?.gazeDelegate = self
      self.tracker?.calibrationDelegate = self
      self.tracker?.userStatusDelegate = self
      
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
// MARK: - Init status Delegate
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
// While gaze tracking is on, You can get detail information of user state through this delegate.
extension SeeSoModel: UserStatusDelegate {
  func onAttention(timestampBegin: Int, timestampEnd: Int, score: Double) {
    userOptions.recentAttentionScore = Int(score*100)
    if isDetailOptionOn {
      userOptions.attentionData.append(AttentionModel(score: score))
    } else {
      userOptions.attentionData = []
    }
  }
  func onBlink(timestamp: Int, isBlinkLeft: Bool, isBlinkRight: Bool, isBlink: Bool, leftOpenness: Double, rightOpenness: Double) {
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
                           leftOpenness: leftOpenness,
                           rightOpenness: rightOpenness)
    if isDetailOptionOn {
      userOptions.blinkData.append(model)
    } else {
      userOptions.blinkData = []
    }
  }
  func onDrowsiness(timestamp: Int, isDrowsiness: Bool, intensity: Double) {
    userOptions.isSleepy = isDrowsiness
    
    if isDetailOptionOn {
      userOptions.drowsinessData.append(DrowsinessModel(timestamp:timestamp, isDrowsiness: isDrowsiness, intensity: intensity))
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
extension SeeSoModel: FaceDelegate {
  func onFace(faceInfo: FaceInfo) {
    self.faceInfo = faceInfo
  }
}
// MARK: - Sample Data Helper
extension SeeSoModel {
  // View Design
  var initBtnHeaderText: Text {
    return Text(initState != .succeed ? SeeSoString.HEADER_INIT_STOPPED : isInitWithUserOption ? SeeSoString.HEADER_INIT_STARTED_WITH_OPTION : SeeSoString.HEADER_INIT_STARTED)
  }
  var initBtnFooter: Text? {
    return (initState == .succeed && !isInitWithUserOption) ? Text(SeeSoString.FOOTER_INIT_NO_OPTION) : nil
  }
  var trackBtnHeader: Text {
    return Text(isGazeTracking ? SeeSoString.HEADER_TRACK_STARTED : SeeSoString.HEADER_TRACK_STOPPED)
  }
  var trackBtnTitle: String {
    return isGazeTracking ? SeeSoString.LIST_TRACK_STARTED : SeeSoString.LIST_TRACK_STOPPED
  }
  var caliBtnFooter: Text? {
    return isCalibrating ? nil : Text(SeeSoString.FOOTER_CALIB)
  }
  var calibBtnTitle: String {
    return isCalibrating ? SeeSoString.LIST_CALIB_STARTED : SeeSoString.LIST_CALIB_STOPPED
  }
  
  // Calibration Data Save
  func saveCalibrationDataToLocal() {
    UserDefaults.standard.set(savedCaliData, forKey: SeeSoString.KEY_CALIBRATION_DATA)
    savedCaliData = []
  }
  func loadSavedCalibrationData() {
    if let calibData = UserDefaults.standard.array(forKey: SeeSoString.KEY_CALIBRATION_DATA) as? [Double] {
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
  var leftEyeClosedTime: Float {
    return Float(userOptions.blinkData.reduce(0) {
      return $0 + ($1.isBlinkLeft ? 1 : 0)
    }) / Float(trackingFPS)
  }
  var rightEyeClosedTime: Float {
    return Float(userOptions.blinkData.reduce(0) {
      return $0 + ($1.isBlinkRight ? 1 : 0)
    }) / Float(trackingFPS)
  }
  var bothEyeClosedTime: Float {
    return Float(userOptions.blinkData.reduce(0) {
      return $0 + ($1.isBlink ? 1 : 0)
    }) / Float(trackingFPS)
  }
  var averageLeftEyeOpenness: Double {
    let sum:Double = userOptions.blinkData.reduce(Double.zero, {
      return $0 + $1.leftEyeOpenness
    })
    return sum / Double(userOptions.blinkData.count)
  }
  var averageLeftOpenness: Double {
    let sum:Double = userOptions.blinkData.reduce(Double.zero, {
      return $0 + $1.leftOpenness
    })
    return sum / Double(userOptions.blinkData.count)
  }

  var averageRightOpenness: Double {
    let sum:Double = userOptions.blinkData.reduce(Double.zero, {
      return $0 + $1.rightOpenness

    })
    return sum / Double(userOptions.blinkData.count)
  }
}
