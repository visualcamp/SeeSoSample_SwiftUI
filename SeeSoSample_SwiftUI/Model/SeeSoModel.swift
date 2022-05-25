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

final class SeeSoModel: ObservableObject {
    
    @Published var state : GazeTrackerState = .none
    @Published var gazePoint : (Double, Double) = (0,0)
    
    private let licenseKey : String = "dev_fudd3b1nh96tjfkvzm4llawb2sd9p4xw7uv7yws8"
    private var tracker : GazeTracker? = nil
    
    
    /* If GazeTracker is nil, the creation failed.
     * At this time, if you look at the InitializationError value, you can see why it failed.
     */
    func initGazeTracker() {
        if checkAccessCamera() {
            DispatchQueue.main.async {
                self.state = .initializing
            }
            GazeTracker.initGazeTracker(license: licenseKey, delegate: self)
        } else {
            requestAccess()
        }
    }
    
    public func deinitGazeTracker() {
        tracker?.statusDelegate = nil
        tracker?.gazeDelegate = nil
        GazeTracker.deinitGazeTracker(tracker: tracker)
        tracker = nil
        state = .none
    }
    
    public func startTracking(){
        tracker?.startTracking()
    }
    
    public func stopTracking(){
        tracker?.stopTracking()
    }
    
    private var errors : InitializationError = .ERROR_NONE
    public func getInitializedError() -> String {
        errors.description
    }
    
    private func checkAccessCamera() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    private func requestAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) {
            response in
            if response {
                self.initGazeTracker()
            }
        }
    }
}
extension SeeSoModel: InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if tracker != nil {
            self.tracker = tracker
            self.tracker?.gazeDelegate = self
            self.tracker?.statusDelegate = self
            self.state = .initialized
        }else {
            self.errors = error
            self.state = .initFailed
            print(error)
        }
    }
}
extension SeeSoModel: GazeDelegate {
    func onGaze(gazeInfo: GazeInfo) {
        if gazeInfo.trackingState == .SUCCESS {
            gazePoint.0 = gazeInfo.x
            gazePoint.1 = gazeInfo.y
            
            print("X: \(Int(gazePoint.0)) Y : \(Int(gazePoint.1))")
        }
    }
}
extension SeeSoModel: StatusDelegate {
    func onStarted() {
        state = .startTracking
        print("start")
    }
    func onStopped(error: StatusError) {
        state = .stopTracking
        print("stop")
    }
}
