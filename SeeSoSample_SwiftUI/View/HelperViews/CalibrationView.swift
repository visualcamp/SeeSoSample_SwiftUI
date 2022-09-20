//
//  CalibrationView.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

import SwiftUI

struct CalibrationView: View {
  @EnvironmentObject var model: SeeSoModel
  var body: some View {
    ZStack {
      Color
        .black
        .opacity(0.9)
      ZStack {
        Text("\(Int(model.caliProgress*100))%")
          .foregroundColor(.white)
          .font(.system(.headline))
        Circle()
          .strokeBorder(Color.red,lineWidth: 3)
          .frame(width: 50, height: 50)
      }
      .position(x: model.caliPosition.0,
                y: model.caliPosition.1)
    }
    .ignoresSafeArea()
  }
}

struct CalibrationView_Previews: PreviewProvider {
  static var previews: some View {
    CalibrationView()
  }
}
