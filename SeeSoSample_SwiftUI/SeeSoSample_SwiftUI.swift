//
//  SeeSoSample_SwiftUI.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI

@main
struct SeeSoSample_SwiftUI: App {
  @StateObject private var model = SeeSoModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(model)
    }
  }
}
