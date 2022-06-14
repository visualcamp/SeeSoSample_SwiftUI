//
//  UserOptionSection.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisualCamp. All rights reserved.
//

import SwiftUI

struct UserOptionSection: View {
  @EnvironmentObject var model: SeeSoModel
  var body: some View {
    Section {
      DisclosureGroup() {
        HStack {
          Text(String(format: SeeSoString.TITLE_USER_OPTION, model.customAttentionInterval))
          Spacer()
          Text("\(model.userOptions.recentAttentionScore)%")
        }
        HStack {
          Text(SeeSoString.TITLE_USER_OPTION_BLINK)
          Spacer()
          Text("\(model.userOptions.blinked ? SeeSoString.VALUE_USER_OPTION_BLINKED : SeeSoString.VALUE_USER_OPTION_OPENED)")
        }
        HStack {
          Text(SeeSoString.TITLE_USER_OPTION_SLEEPY)
          Spacer()
          Text(model.userOptions.isSleepy ?  SeeSoString.VALUE_USER_OPTION_SLEEPY : SeeSoString.VALUE_USER_OPTION_NOT_SLEEPY)
        }
        Toggle(SeeSoString.TITLE_USER_OPTION_DETAIL, isOn: $model.isDetailOptionOn)
      } label: {
        Text(SeeSoString.TITLE_USER_OPTION)
      }
    }
  }
}

struct UserOptionSection_Previews: PreviewProvider {
  static var previews: some View {
    UserOptionSection()
  }
}
