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
  
  // Eye Tracking Control
  @Published var isEyeTracking: Bool = false
  @Published var gazePoint: seeSoCoordi = (0,0)
  private var tracker: GazeTracker? = nil
  
  func initGazeTracker() {
    if isCameraAccessAllowed {
      self.initState = .initializing
      DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {
        let options = UserStatusOption()
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
  }
  // initial error check
  private var errors : InitializationError = .ERROR_NONE
  public func getInitializedError() -> String {
    errors.description
  }
  
  // Calibration
  @MainActor
  public func startCalibration() {
    self.isCalibrating = true
    guard let result = tracker?.startCalibration(mode: caliMode, criteria: .DEFAULT) else { return }
    if !result {
      print("Calibration Start failed.")
    }
  }
  public func stopCalibration() {
    isCalibrating = false
    tracker?.stopCalibration()
  }
  
  // Eye tracking Control
  public func startTracking(){
    tracker?.startTracking()
  }
  
  public func stopTracking(){
    tracker?.stopTracking()
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
                                 userStatusDelegate: nil)//self)
      
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
// While gaze tracking is in progress,
// You can get coordinates of gaze through this delegate.
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
    isEyeTracking = true
  }
  func onStopped(error: StatusError) {
    isEyeTracking = false
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
