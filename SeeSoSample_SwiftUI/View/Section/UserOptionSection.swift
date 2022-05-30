//
//  UserOptionSection.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI

struct UserOptionSection: View {
  @EnvironmentObject var model: SeeSoModel
  var body: some View {
    Section {
      DisclosureGroup() {
        HStack {
          Text("Attention score of recent \(model.customAttentionInterval)s")
          Spacer()
          Text("\(model.userOptions.recentAttentionScore)%")
        }
        HStack {
          Text(TITLE_USER_OPTION_BLINK)
          Spacer()
          Text("\(model.userOptions.blinked ? "Ȕ _ Ű" : "Ȍ _ Ő")")
        }
        HStack {
          Text(TITLE_USER_OPTION_SLEEPY)
          Spacer()
          Text(model.userOptions.isSleepy ? "Yes.." : "Nope!")
        }
        Toggle(TITLE_USER_OPTION_DETAIL, isOn: $model.isDetailOptionOn)
      } label: {
        Text(TITLE_USER_OPTION)
      }
    }
  }
}

struct UserOptionSection_Previews: PreviewProvider {
  static var previews: some View {
    UserOptionSection()
  }
}
