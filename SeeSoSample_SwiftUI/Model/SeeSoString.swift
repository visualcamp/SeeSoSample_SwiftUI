//
//  String.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

class SeeSoString {
  // Title
  static let APP_TITLE = "SeeSo Sample"
  static let GUIDE_MAIN = "Follow steps below to experience gaze tracking."
  // Camera Auth
  static let GUIDE_CAMERA_AUTH = "We must have camera permission!"
  static let LIST_CAMERA_AUTH = "Click here to request camera authorization."

  // Init
  static let HEADER_INIT_STOPPED = "You need to init GazeTracker first."
  static let HEADER_INIT_STARTED = "GazeTracker is activated!"
  static let HEADER_INIT_STARTED_WITH_OPTION = "GazeTracker is activated with User Options!"
  static let FOOTER_INIT_NO_OPTION = "You can init GazeTracker With UserOption!\n(need to restart GazeTraker)"
  static let FOOTER_INIT_WITH_OPTION = "Exapand "
  static let LIST_INIT_STOPPED = "Initialize GazeTracker"
  static let LIST_INIT_STARTED = "Stop GazeTracker"
  static let LIST_INIT_WITH_USER_OPTION = "with User Options"

  // Tracking
  static let HEADER_TRACK_STOPPED = "Now You can track your gaze!"
  static let HEADER_TRACK_STARTED = "Tracking is On!!"
  static let LIST_TRACK_STOPPED = "Start tracking."
  static let LIST_TRACK_STARTED = "Stop tracking"

  // Face View
  static let HEADER_FACE_VIEW = "You can check state of face."
  static let LIST_FACE_VIEW = "Check Face View"
  static let GUIDE_FACE_VIEW = "Move your head!"
  static let TITLE_FACE_SCORE = "face score = "
  static let TITLE_FACE_DISTANCE = "distance from face to camera : "
  
  // Calib
  static let HEADER_CALIB = "And also you can improve accuracy through calibration."
  static let FOOTER_CALIB = "(Calibration only can be done while gaze tracking is activated)"
  static let LIST_CALIB_STOPPED = "Start Calibration"
  static let LIST_CALIB_STARTED = "Calibration started!"
  static let PICKER_CALIB = "Calibration Type"
  static let GUIDE_CALIB = "Look at the circle!"
  static let TITLE_CALIB_SAVE = "Save Calibration Data to local"
  static let ALERT_CALIB_SAVE_TITLE = "Save Done"
  static let ALERT_CALIB_SAVE_BTN = "ok"

  // User Options
  static let TITLE_USER_OPTION = "User Options Info"
  static let TITLE_USER_OPTION_ATTENTION = "Attention score of recent %@s"
  static let TITLE_USER_OPTION_BLINK = "Blink State"
  static let VALUE_USER_OPTION_BLINKED = "Ȕ _ Ű"
  static let VALUE_USER_OPTION_OPENED = "Ȍ _ Ő"
  static let TITLE_USER_OPTION_SLEEPY = "Do I look sleepy now..?"
  static let VALUE_USER_OPTION_SLEEPY = "Yes.."
  static let VALUE_USER_OPTION_NOT_SLEEPY = "Nope!"
  static let TITLE_USER_OPTION_DETAIL = "Show Detail Info\n(it may cause lagging!)"

  // Example for User Info Data Control
  static let TITLE_EXAMPLE_AVE_ATT_SCORE = "average attention score"
  static let TITLE_EXAMPLE_AVE_ATT_COUNT = "attention check count"
  static let TITLE_EXAMPLE_LEFT_EYE_CLOSE_TIME = "left eye closed time"
  static let TITLE_EXAMPLE_RIGHT_EYE_CLOSE_TIME = "right eye closed time"
  static let TITLE_EXAMPLE_BOTH_EYE_CLOSE_TIME = "both eyes closed time"
  static let TITLE_EXAMPLE_LEFT_EYE_OPENNESS = "average left eye Opennes"
  static let TITLE_EXAMPLE_RIGHT_EYE_OPENNESS = "average right eye Opennes"


  static let KEY_CALIBRATION_DATA = "KEY_CALIBRATION_DATA"
}
