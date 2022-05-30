//
//  DetailUserInfoSection.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI

struct DetailUserInfoSection: View {
  @EnvironmentObject var model: SeeSoModel
  var body: some View {
    Section() {
      HStack {
        Text(TITLE_EXAMPLE_AVE_ATT_SCORE)
        Spacer()
        Text("\(model.averageAttentionScore)")
      }
      HStack {
        Text(TITLE_EXAMPLE_AVE_ATT_COUNT)
        Spacer()
        Text("\(model.attentionCheckCount)")
      }
      HStack {
        Text(TITLE_EXAMPLE_LEFT_BLINK_COUNT)
        Spacer()
        Text("\(model.leftBlinkCount)")
      }
      HStack {
        Text(TITLE_EXAMPLE_RIGHT_BLINK_COUNT)
        Spacer()
        Text("\(model.rightBlinkCount)")
      }
      HStack {
        Text(TITLE_EXAMPLE_BLINK_COUNT)
        Spacer()
        Text("\(model.blinkCount)")
      }
      HStack {
        Text(TITLE_EXAMPLE_EYE_OPENNESS)
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
