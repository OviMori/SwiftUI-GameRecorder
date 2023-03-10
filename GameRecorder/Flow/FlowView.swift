//
//  SwiftUIView.swift
//   GameRecorder
//
//  Created by ovidio morisano on 18/02/23.
//

import SwiftUI

struct FlowView: View {
    @StateObject var viewModel: FlowViewModel
    var body: some View {
        NavigationView {
            VStack() {
                MainMenuView(viewModel: viewModel.makeMainMenuViewModel())
                Flow(next: $viewModel.navigateToTimeAttack) {
                    TimeAttackView(viewModel: viewModel.makeTimeAttackViewModel())
                }
                Flow(next: $viewModel.navigateToEndurance) {
                    EnduranceView(viewModel: viewModel.makeEnduranceViewModel())
                }
            }
        }
        .sheet(isPresented: $viewModel.navigateToSettings) {
            SettingsView(viewModel: viewModel.makeSettingsViewModel())
        }
        if viewModel.showGamePlayPreview {
            viewModel.presentPreview()
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
        }
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(viewModel: FlowViewModel())
    }
}
