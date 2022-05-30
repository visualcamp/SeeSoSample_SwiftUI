//
//  LoadingView.swift
//  SeeSoSample_SwiftUI
//
//  Created by VisualCamp on 2022/05/25.
//  Copyright © 2022 VisaulCamp. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    ZStack {
      Color
        .black
        .opacity(0.5)
        .ignoresSafeArea()
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
        .scaleEffect(4)
    }
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingView()
  }
}
