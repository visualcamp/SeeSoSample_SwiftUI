//
//  UserOptionsModel.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import Foundation

struct UserOptionsModel {
  // Simple
  var recentAttentionScore: Int = 0
  var blinked:Bool = false
  var isSleepy: Bool = false
  
  // Detailed figures
  var attentionData: [AttentionModel] = []
  var blinkData: [BlinkModel] = []
  var drowsinessData: [DrowsinessModel] = []
  
  static let `default` = UserOptionsModel()
}

struct AttentionModel {
  var score:Double
}
struct BlinkModel {
  var isBlinkLeft:Bool
  var isBlinkRight:Bool
  var isBlink:Bool
  var eyeOpenness:Double
}

struct DrowsinessModel {
  var timestamp:Int
  var isDrowsiness:Bool
}
