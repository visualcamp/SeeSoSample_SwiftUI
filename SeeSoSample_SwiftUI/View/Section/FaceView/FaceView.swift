//
//  FaceView.swift
//  SeeSoSample_SwiftUI
//
//  Created by Daniel Koh on 2022/09/19.
//

import SwiftUI
import SeeSo

struct FaceView: View {
  @EnvironmentObject var model: SeeSoModel
  var rectSize = UIWindow().bounds.width / 2
  var body: some View {
    VStack(alignment: .center) {
      Text(SeeSoString.GUIDE_FACE_VIEW)
      Spacer()
      ZStack {
        Rectangle()
          .stroke(.green, lineWidth: 2)
        Rectangle()
          .stroke(.blue, lineWidth: 5)
          .frame(width: rectSize, height: rectSize, alignment: .center)
          .offset(CGSize(width: -(model.faceInfo?.centerXYZ.x ?? 0), height: model.faceInfo?.centerXYZ.y ?? 0))
          .rotation3DEffect(.degrees((model.faceInfo?.yaw ?? 0) * -90), axis: (x:0.5, y:0, z:0))
          .rotation3DEffect(.degrees((model.faceInfo?.pitch ?? 0) * -90), axis: (x:0, y:0.5, z:0))
      }
      Spacer()
      VStack(alignment: .leading) {
        Text("\(NSString(format: "%@%.4f",SeeSoString.TITLE_FACE_SCORE, model.faceInfo?.score ?? -999))")
        Text("\(NSString(format: "%@%.4f",SeeSoString.TITLE_FACE_DISTANCE, model.faceInfo?.centerXYZ.z ?? 0))")
      }
    }
  }
}
