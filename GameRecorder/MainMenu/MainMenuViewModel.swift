//
//  MainMenuViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 25/02/23.
//

import Foundation
import SwiftUI
import Combine

final class MainMenuViewModel: ObservableObject {
    @Published var gameCategory: GameCategory
    @Published var menuHudVisibile: Bool = true
    @Published var settingsVisible: Bool = false
    @Published var recorderStatusToggle: Bool = false
    var onDismiss: (() -> Void)?
    var onChangeCategory: ((GameCategory) -> Void)?
    let didComplete = PassthroughSubject<MainMenuDestination, Never>()
    let onRecorderStatusUpdate = PassthroughSubject<Bool, Never>()
    
    init() {
        gameCategory = .TimeAttack
        let settings = SettingsDataRepository().retrieveSettings()
        recorderStatusToggle = settings.screenRecorderActivationState
    }
    
    func updateCategory() {
        switch gameCategory {
        case .TimeAttack:
            gameCategory = .Endurance
            onChangeCategory?(gameCategory)
        case .Endurance:
            gameCategory = .TimeAttack
            onChangeCategory?(gameCategory)
        }
    }
    
    func openSettings() {
        didComplete.send(.Settings)
    }
    
    func playGame() {
        switch gameCategory {
        case .TimeAttack:
            didComplete.send(.TimeAttack)
        case .Endurance:
            didComplete.send(.Endurance)
        }
    }
    
    func recorderStatusToggleUpdate() {
        debugPrint("Recorder initialization...")
        onRecorderStatusUpdate.send(recorderStatusToggle)
    }
}
