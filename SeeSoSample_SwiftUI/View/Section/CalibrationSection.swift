//
//  CalibrationSection.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI
import SeeSo

struct CalibrationSection: View {
  @EnvironmentObject var model: SeeSoModel
  var calibrationType: [CalibrationMode] = [.ONE_POINT, .FIVE_POINT]
    var body: some View {
      Section(
        header: Text(HEADER_CALIB) ,
        footer: model.caliBtnFooter
      ){
        Text(model.calibBtnTitle)
          .onTapGesture {
            model.toggleCalibrtation()
          }
        HStack {
          Text(PICKER_CALIB)
          Picker("type pick",selection: $model.caliMode) {
            ForEach(calibrationType, id: \.self) {
              Text($0.description)
            }
          }
          .pickerStyle(.segmented)
        }
      }.textCase(nil)
    }
}

struct CalibrationSection_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationSection()
    }
}
