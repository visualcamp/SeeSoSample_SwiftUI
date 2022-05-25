//
//  GazePointView.swift
//  SeeSo_Sample_iOS_swiftUI
//
//  Created by 은택 on 2022/05/25.
//

import SwiftUI

struct GazePointView: View {
    @EnvironmentObject var manager: SeeSoModel
    
    var body: some View {
        Circle() // dynamically sized circle
            .stroke()
            .frame(width: 20, height: 20)
            .overlay(GeometryReader{ geometry in
                Circle() // sized based on first
                    .frame(width: geometry.size.width*0.5, height: geometry.size.height*0.5)
            }).position(x: manager.gazePoint.0, y: manager.gazePoint.1)
            .opacity(manager.state == .startTracking ? 1 : 0)
    }
}

struct GazePointView_Previews: PreviewProvider {
    static var previews: some View {
        GazePointView()
    }
}
