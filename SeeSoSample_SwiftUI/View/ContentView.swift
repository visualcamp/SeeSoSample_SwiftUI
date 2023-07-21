//
//  ContentView.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

import SwiftUI
import CoreMedia
import SeeSo

struct ContentView: View {
  @EnvironmentObject var model: SeeSoModel
  
  var body: some View {
    ZStack {
      NavigationView {
        VStack {
          Divider()
            .padding(15)
          
          Text(SeeSoString.GUIDE_MAIN)
            .multilineTextAlignment(.center)
            .navigationTitle(SeeSoString.APP_TITLE)
          
          List {
            if !model.isCameraAccessAllowed {
              Section(header:Text(SeeSoString.GUIDE_CAMERA_AUTH)) {
                Button {
                  DispatchQueue.main.async {
                    model.initGazeTracker()
                  }
                } label: {
                  Text(SeeSoString.LIST_CAMERA_AUTH)
                    .foregroundColor(.primary)
                }
              }.textCase(nil)
              
            } else {
              
              Section(
                header: model.initBtnHeaderText,
                footer: model.initBtnFooter
              ) {
                if model.initState != .succeed {
                  
                  Button {
                    DispatchQueue.main.async {
                      model.initGazeTracker()
                    }
                  } label: {
                    Text(SeeSoString.LIST_INIT_STOPPED)
                      .foregroundColor(.primary)
                  }
                  Toggle(isOn: $model.isInitWithUserOption) {
                    Text(SeeSoString.LIST_INIT_WITH_USER_OPTION)
                  }
                  
                } else {
                  Button {
                    DispatchQueue.main.async {
                      model.deinitGazeTracker()
                    }
                  } label: {
                    Text(SeeSoString.LIST_INIT_STARTED)
                      .foregroundColor(.primary)
                  }
                }
              }.textCase(nil)
              
              if model.initState == .succeed {
                
                Section(header: model.trackBtnHeader) {
                  Button {
                    DispatchQueue.main.async {
                      model.toggleTracking()
                    }
                  } label: {
                    Text(model.trackBtnTitle)
                      .foregroundColor(.primary)
                  }
                  
                }.textCase(nil)
                
                if model.isGazeTracking {
                  FaceViewSection()
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
