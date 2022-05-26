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
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Divider()
                        .padding(15)
                    Text("Follow steps below to experience eye tracking.")
                        .multilineTextAlignment(.center)
                        .navigationTitle("SeeSo Sample")
                    List {
                        if !model.isCameraAccessAllowed {
                            Section(header:Text("We must have camera permission!")) {
                                Text("Allow camera use authorization.")
                                    .onTapGesture {
                                        DispatchQueue.main.async {
                                            model.initGazeTracker()
                                        }
                                    }
                            }.textCase(nil)
                        } else {
                            Section(
                                header:Text(model.initState != .succeed ? "You need to init GazeTracker first." : "GazeTracker is activated!"),
                                footer: (model.initState == .succeed && !model.isInitWithUserOption) ? Text("You can init GazeTracker With UserOption!\n(need to restart GazeTraker)") : nil
                            ){
                                if model.initState != .succeed {
                                    Text("Initialize GazeTracker")
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                model.initGazeTracker()
                                            }
                                        }
                                } else {
                                    Text("Stop GazeTracker")
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                model.deinitGazeTracker()
                                            }
                                        }
                                    
                                }
                            }.textCase(nil)
                            
                            if model.initState == .succeed {
                                Section(header:Text(model.isEyeTracking ? "Tracking is On!!" : "Now You can track your gaze!")) {
                                    Text(model.isEyeTracking ? "Stop tracking" : "Start tracking.")
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                model.isEyeTracking ? model.stopTracking() : model.startTracking()
                                            }
                                        }
                                }.textCase(nil)
                                
                                if model.isEyeTracking {
                                    Section(
                                        header: Text("And also you can improve accuracy through calibration.") ,
                                        footer: model.isCalibrating ? nil : Text("(Calibration only can be done while gaze tracking is activated)")
                                    ) {
                                        Text(model.isCalibrating ? "Calibration started!" : "Start Calibration")
                                            .onTapGesture {
                                                model.isCalibrating ? model.stopCalibration() : model.startCalibration()
                                            }
                                        if !model.isCalibrating {
                                            HStack {
                                                Text("Calibration Type")
                                                Picker("type pick",selection: $model.caliMode) {
                                                    ForEach(calibrationType, id: \.self) {
                                                        Text($0.description)
                                                    }
                                                }
                                                .pickerStyle(.segmented)
                                            }
                                        }
                                    }.textCase(nil)
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
            if model.isEyeTracking && !model.isCalibrating {
                Circle()
                    .strokeBorder(Color.red,lineWidth: 3)
                    .frame(width: 25, height: 25)
                    .position(x: model.gazePoint.0, y: model.gazePoint.1)
            }
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
                    Text("Look at the circle!")
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
