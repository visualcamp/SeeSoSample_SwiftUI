//
//  ViewController.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: SeeSoModel
    
    var body: some View {
        ZStack(){
            VStack(spacing: 50) {
                
                Text(manager.state.stateText)
                    .padding()
                
                VStack(alignment: .center, spacing: 16){
                    Button("init") {
                        if manager.state == .none {
                            manager.initGazeTracker()
                            if manager.state == .initFailed {
                                print("error : \(manager.getInitializedError())")
                            }
                        } else {
                            manager.deinitGazeTracker()
                        }
                    }.disabled(manager.state == .initializing)
                
                    Button("start"){
                        if manager.state == .initialized {
                            manager.startTracking()
                        } else {
                            manager.stopTracking()
                        }
                    }.disabled(manager.state == .initializing)
                }
            }
            GazePointView()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
