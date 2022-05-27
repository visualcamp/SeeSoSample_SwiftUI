//
//  ViewController.swift
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
  var calibrationType: [CalibrationMode] = [.ONE_POINT, .FIVE_POINT]
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
                  
                  Section(
                    header: Text(HEADER_CALIB) ,
                    footer: model.caliBtnFooter
                  ){
                    
                    Text(model.calibBtnTitle)
                      .onTapGesture {
                        model.toggleCalibrtation()
                      }
                    
                    if !model.isCalibrating {
                      
                      HStack {
                        Text(PICKER_CALIB)
                        Picker("type pick",selection: $model.caliMode) {
                          ForEach(calibrationType, id: \.self) {
                            Text($0.description)
                          }
                        }
                        .pickerStyle(.segmented)
                        
                      }
                    }
                  }.textCase(nil)
                  
                  if model.isInitWithUserOption {
                    Section {
                      DisclosureGroup() {
                        HStack {
                          Text("Attention score of recent \(model.customAttentionInterval)s")
                          Spacer()
                          Text("\(model.userOptions.recentAttentionScore)%")
                        }
                        HStack {
                          Text(TITLE_USER_OPTION_BLINK)
                          Spacer()
                          Text("\(model.userOptions.blinked ? "Ȕ _ Ű" : "Ȍ _ Ő")")
                        }
                        HStack {
                          Text(TITLE_USER_OPTION_SLEEPY)
                          Spacer()
                          Text(model.userOptions.isSleepy ? "Yes.." : "Nope!")
                        }
                      } label: {
                        Text(TITLE_USER_OPTION)
                      }
                    }
                  }
                }
              }
            }
          }.listStyle(GroupedListStyle())
          
        }
      }
      
      if model.initState == .initializing {
        ZStack {
          Color
            .black
            .opacity(0.5)
            .ignoresSafeArea()
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(4)
        }
      }
      
      // Gaze Track Icon
      if model.isGazeTracking && !model.isCalibrating {
        Circle()
          .strokeBorder(Color.red,lineWidth: 3)
          .frame(width: 25, height: 25)
          .position(x: model.gazePoint.0, y: model.gazePoint.1)
      }
      
      // Calibrating Progress Icon
      if model.isCalibrating {
        ZStack {
          Color
            .black
            .opacity(0.5)
            .ignoresSafeArea()
          ZStack {
            Text("\(Int(model.caliProgress*100))%")
            Circle()
              .strokeBorder(Color.red,lineWidth: 3)
              .frame(width: 50, height: 50)
          }
          .position(x: model.caliPosition.0,
                    y: model.caliPosition.1)
          Text(GUIDE_CALIB)
        }
        
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
