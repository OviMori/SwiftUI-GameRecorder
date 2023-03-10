//
//  EnduranceView.swift
//   GameRecorder
//
//  Created by ovidio morisano on 27/02/23.
//

import SwiftUI
import SpriteKit
    
struct EnduranceView: View {
    @ObservedObject var viewModel: EnduranceViewModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        ZStack {
            if #available(iOS 16.0, *) {
                SpriteView(scene: viewModel.scene, debugOptions: [.showsFPS])
                    .ignoresSafeArea()
                    .defersSystemGestures(on: .vertical)
                
            } else {
                SpriteView(scene: viewModel.scene)
                
            }
            TimeAttackHUDView(timerCount: $viewModel.timerCount,
                              score: $viewModel.score)
        }
        .onChange(of: scenePhase, perform: { newValue in
            guard newValue == .inactive else { return }
            viewModel.resetTouches()
        })
    }
}

struct EnduranceView_Previews: PreviewProvider {
    static var previews: some View {
        EnduranceView(viewModel: EnduranceViewModel())
    }
}
