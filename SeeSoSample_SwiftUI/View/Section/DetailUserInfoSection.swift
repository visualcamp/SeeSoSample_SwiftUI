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
        Text(SeeSoString.TITLE_EXAMPLE_LEFT_BLINK_COUNT)
        Spacer()
        Text("\(model.leftBlinkCount)")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_RIGHT_BLINK_COUNT)
        Spacer()
        Text("\(model.rightBlinkCount)")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_BLINK_COUNT)
        Spacer()
        Text("\(model.blinkCount)")
      }
      HStack {
        Text(SeeSoString.TITLE_EXAMPLE_EYE_OPENNESS)
        Spacer()
        Text("\(model.averageEyeOpenness)")
      }
    }
  }
}

struct DetailUserInfoSection_Previews: PreviewProvider {
  static var previews: some View {
    DetailUserInfoSection()
  }
}
