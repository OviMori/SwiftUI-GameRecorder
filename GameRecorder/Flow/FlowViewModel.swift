//
//  FlowControllerViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 18/02/23.
//

import Foundation
import Combine
import SwiftUI

class FlowViewModel: ObservableObject {
    @Published var navigateToMainMenu: Bool = false
    @Published var navigateToTimeAttack: Bool = false
    @Published var navigateToEndurance: Bool = false
    @Published var navigateToSettings: Bool = false
    @Published var showGamePlayPreview = false
    var subscription = Set<AnyCancellable>()
    private var screenRecorder: ScreenRecorder
    private var timeAttachViewModel: TimeAttackViewModel?
    
    init() {
        screenRecorder = ScreenRecorder()
        setupScreenRecorder()
        screenRecorder.isActive = SettingsDataRepository().retrieveSettings().screenRecorderActivationState
    }
    
    private func setupScreenRecorder() {
        screenRecorder.onDismissPreview
            .sink {
                withAnimation{
                    self.showGamePlayPreview = false
                }
            }
            .store(in: &subscription)
        screenRecorder.onPreviewReady
            .sink {
                withAnimation {
                    self.showGamePlayPreview = true
                }
            }
            .store(in: &subscription)
    }
    
    func presentPreview() -> ScreenRecorderPreviewRepresentable {
        return screenRecorder.retrievePreviewView()
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        let viewModel = SettingsViewModel()
        viewModel.didComplete
            .sink(receiveValue: didCompleteSettings)
            .store(in: &subscription)
        return viewModel
    }
    
    private func didCompleteSettings(viewModel: SettingsViewModel) {
        navigateToSettings = false
        navigateToMainMenu = true
    }
    
    func makeEnduranceViewModel() -> EnduranceViewModel {
        let viewModel = EnduranceViewModel()
        viewModel.didComplete
            .sink(receiveValue: didCompleteEndurance)
            .store(in: &subscription)
        return viewModel
    }
    
    private func didCompleteEndurance(viewModel: EnduranceViewModel) {
        navigateToEndurance = false
        navigateToMainMenu = true
    }
    
    func makeTimeAttackViewModel() -> TimeAttackViewModel {
        let viewModel = TimeAttackViewModel()
        viewModel.didComplete
            .sink(receiveValue: didCompleteTimeAttack)
            .store(in: &subscription)
            viewModel.playScreenRecorder
                .sink(receiveValue: playScreenRecorder)
                .store(in: &subscription)
            viewModel.stopScreenRecorder
                .sink(receiveValue: stopScreenRecorder)
                .store(in: &subscription)
        
        timeAttachViewModel = viewModel
        return viewModel
    }
    
    private func playScreenRecorder() {
        screenRecorder.play()
    }
    
    
    private func stopScreenRecorder() {
        screenRecorder.stop()
    }
    
    private func didCompleteTimeAttack(viewModel: TimeAttackViewModel) {
        navigateToTimeAttack = false
        navigateToMainMenu = true
    }
    
    func makeMainMenuViewModel() -> MainMenuViewModel {
        let viewModel = MainMenuViewModel()
        viewModel.didComplete
            .sink(receiveValue: didCompleteMainMenu)
            .store(in: &subscription)
        viewModel.onRecorderStatusUpdate
            .sink(receiveValue: updateScreenRecorderStatus)
            .store(in: &subscription)
        return viewModel
    }
    
    private func updateScreenRecorderStatus(newValue: Bool) {
        screenRecorder.isActive = newValue
        SettingsDataRepository().saveScreenRecorderState(withNewValue: newValue)
    }
    
    func didCompleteMainMenu(destination: MainMenuDestination) {
        switch destination {
        case .TimeAttack:
            navigateToTimeAttack = true
        case .Endurance:
            navigateToEndurance = true
        case .Settings:
            navigateToSettings = true
        }
    }
}
