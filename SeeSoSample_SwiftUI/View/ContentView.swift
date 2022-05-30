//
//  ContentView.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI
import CoreMedia
import SeeSo

struct ContentView: View {
  @EnvironmentObject var model: SeeSoModel
  @State var isOpened: Bool = true
  
  var body: some View {
    ZStack {
      NavigationView {
        VStack {
          Divider()
            .padding(15)
          
          Text(GUIDE_MAIN)
            .multilineTextAlignment(.center)
            .navigationTitle(APP_TITLE)
          
          List {
            if !model.isCameraAccessAllowed {
              
              Section(header:Text(GUIDE_CAMERA_AUTH)) {
                Text(LIST_CAMERA_AUTH)
                  .onTapGesture {
                    DispatchQueue.main.async {
                      model.initGazeTracker()
                    }
                  }
              }.textCase(nil)
              
            } else {
              
              Section(
                header: model.initBtnHeaderText,
                footer: model.initBtnFooter
              ) {
                if model.initState != .succeed {
                  
                  Text(LIST_INIT_STOPPED)
                    .onTapGesture {
                      DispatchQueue.main.async {
                        model.initGazeTracker()
                      }
                    }
                  Toggle(isOn: $model.isInitWithUserOption) {
                    Text(LIST_INIT_WITH_USER_OPTION)
                  }
                  
                } else {
                  
                  Text(LIST_INIT_STARTED)
                    .onTapGesture {
                      DispatchQueue.main.async {
                        model.deinitGazeTracker()
                      }
                    }
                }
              }.textCase(nil)
              
              if model.initState == .succeed {
                
                Section(header: model.trackBtnHeader) {
                  Text(model.trackBtnTitle)
                    .onTapGesture {
                      DispatchQueue.main.async {
                        model.toggleTracking()
                      }
                    }
                }.textCase(nil)
                
                if model.isGazeTracking {
                  CalibrationSection()
                  if model.isInitWithUserOption {
                    UserOptionSection()
                    if model.isDetailOptionOn {
                      DetailUserInfoSection()
                    }
                  }
                }
              }
            }
          }.listStyle(GroupedListStyle())
        }
      }
      
      if model.initState == .initializing {
        LoadingView()
      }
      
      // Gaze Track Icon
      if model.isGazeTracking && !model.isCalibrating {
        GazeTrackerIcon()
      }
      
      // Calibrating Progress Icon
      if model.isCalibrating {
        CalibrationView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
