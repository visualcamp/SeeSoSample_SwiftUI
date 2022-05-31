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
  @State var isSavePopupShow = false
  
  var body: some View {
    Section(
      header: Text(HEADER_CALIB) ,
      footer: model.caliBtnFooter
    ){
      Button(action: {
        model.toggleCalibrtation()
      }, label: {
        Text(model.calibBtnTitle)
          .foregroundColor(.primary)
      })
      HStack {
        Text(PICKER_CALIB)
        Picker("type pick",selection: $model.caliMode) {
          ForEach(calibrationType, id: \.self) {
            Text($0.description)
          }
        }
        .pickerStyle(.segmented)
      }
      if !model.savedCaliData.isEmpty {
        Button {
          isSavePopupShow = true
        } label: {
          Text(TITLE_CALIB_SAVE)
            .foregroundColor(.primary)
        }
        .alert(isPresented:$isSavePopupShow) {
          Alert(title: Text(ALERT_CALIB_SAVE_TITLE),message: nil,dismissButton: .default(Text(ALERT_CALIB_SAVE_BTN),action: {
            model.saveCalibrationDataToLocal()
          }))
        }
      }
    }.textCase(nil)
  }
}

struct CalibrationSection_Previews: PreviewProvider {
  static var previews: some View {
    CalibrationSection()
  }
}
