//
//  TimeAttackView.swift
//   GameRecorder
//
//  Created by ovidio morisano on 01/03/23.
//

import SwiftUI
import SpriteKit

struct TimeAttackView: View {
    @StateObject var viewModel: TimeAttackViewModel
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            if #available(iOS 16.0, *) {
                SpriteView(scene: viewModel.scene,
                           options: [.allowsTransparency],
                           debugOptions: [.showsFPS])
                    .ignoresSafeArea()
                    .defersSystemGestures(on: .vertical)
                    .background(.white)
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

struct TimeAttackHUDView: View {
    @Binding var timerCount: Int
    @Binding var  score: Int
    
    var body: some View {
        VStack {
            Text("\(timerCount)")
                .padding(.top, 100)
                .foregroundColor(.pink)
                .font(.system(size: 80))
                .transition(.move(edge: .top))
            Spacer()
            Text("\(score)")
                .padding(.top, 400)
                .foregroundColor(.pink)
                .font(.system(size: 80))
                .transition(.move(edge: .bottom))
            Spacer()
        }
    }
}

struct TimeAttackView_Previews: PreviewProvider {
    static var previews: some View {
        TimeAttackView(viewModel: TimeAttackViewModel())
    }
}
