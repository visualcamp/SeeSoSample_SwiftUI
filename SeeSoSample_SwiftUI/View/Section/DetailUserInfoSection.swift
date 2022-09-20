//
//  DetailUserInfoSection.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

import SwiftUI

struct DetailUserInfoSection: View {
  @EnvironmentObject var model: SeeSoModel
  var body: some View {
    Section() {
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_AVE_ATT_SCORE)
        Spacer()
        Text("\(model.averageAttentionScore)")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_AVE_ATT_COUNT)
        Spacer()
        Text("\(model.attentionCheckCount)")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_LEFT_EYE_CLOSE_TIME)
        Spacer()
        Text("\(NSString(format: "%.4f", model.leftEyeClosedTime))")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_RIGHT_EYE_CLOSE_TIME)
        Spacer()
        Text("\(NSString(format: "%.4f", model.rightEyeClosedTime))")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_BOTH_EYE_CLOSE_TIME)
        Spacer()
        Text("\(NSString(format: "%.4f", model.bothEyeClosedTime))")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_LEFT_EYE_OPENNESS)
        Spacer()
        Text("\(NSString(format: "%.4f", model.averageLeftEyeOpenness))")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_RIGHT_EYE_OPENNESS)
        Spacer()
        Text("\(NSString(format: "%.4f", model.averageRightEyeOpenness))")
      }
    }
  }
}

struct DetailUserInfoSection_Previews: PreviewProvider {
  static var previews: some View {
    DetailUserInfoSection()
  }
}
