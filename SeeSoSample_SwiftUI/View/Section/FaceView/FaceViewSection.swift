//
//  FaceViewSection.swift
//  SeeSoSample_SwiftUI
//
//  Created by Daniel Koh on 2022/09/20.
//

import SwiftUI

struct FaceViewSection: View {
    var body: some View {
      Section(
        header: Text(SeeSoString.HEADER_FACE_VIEW)
          .textCase(nil)
      ){
        NavigationLink {
          FaceView()
        } label: {
          Text(SeeSoString.LIST_FACE_VIEW)
        }
      } 
    }
}

struct FaceViewSection_Previews: PreviewProvider {
    static var previews: some View {
        FaceViewSection()
    }
}
