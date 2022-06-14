//
//  GazeTrackerIcon.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

import SwiftUI

struct GazeTrackerIcon: View {
  @EnvironmentObject var model: SeeSoModel
  var body: some View {
    Circle()
      .strokeBorder(Color.red,lineWidth: 3)
      .frame(width: 25, height: 25)
      .position(x: model.gazePoint.0, y: model.gazePoint.1)
  }
}

struct GazeTrackerIcon_Previews: PreviewProvider {
  static var previews: some View {
    GazeTrackerIcon()
  }
}
