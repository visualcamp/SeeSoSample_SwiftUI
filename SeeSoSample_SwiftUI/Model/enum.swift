//
//  ViewController.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import Foundation

enum GazeTrackerState: Int {
    case none = 0
    case initializing
    case initialized
    case initFailed
    case startTracking
    case stopTracking
    
    var stateText:String {
        switch self {
        case .none,.stopTracking:
            return "Hello SeeSo World."
        case .initializing:
            return "initializing...."
        case .initialized:
            return "init done"
        case .initFailed:
            return "init success."
        case .startTracking:
            return "init failed."
        }
    }
}

enum InitButtonText: String {
    case initializing = "Init"
    case deinitializing = "Deinit"
}

enum StartText: String {
    case start = "Start"
    case stop = "Stop"
}

