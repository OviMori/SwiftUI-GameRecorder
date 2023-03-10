//
//  SettingsViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 25/02/23.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var currentPitch: Float
    @Published var soundEffectList: [SoundEffect]
    var settings: Settings
    var oldSelectedSoundIndex: Int = 0
    let didComplete = PassthroughSubject<SettingsViewModel, Never>()
    
    init() {
        settings = SettingsDataRepository().retrieveSettings()
        soundEffectList = SettingsDataRepository().retrieveSoundEffects()
        currentPitch = Float(settings.pitch)
        initSelectedSoundIndex()
    }
    
    private func initSelectedSoundIndex() {
        oldSelectedSoundIndex = soundEffectList.firstIndex(where: { $0.isSelected == true }) ?? 0
    }
    
    func saveSettings() {
        updateSettings()
        SettingsDataRepository().save(settings: settings)
        SettingsDataRepository().save(soundEffectList: soundEffectList)
        didComplete.send(self)
    }
    
    func updateSettings() {
        settings.pitch = Int(currentPitch)
        guard oldSelectedSoundIndex < soundEffectList.count else { return }
        settings.soundEffect = soundEffectList[oldSelectedSoundIndex]
    }
    
    func updateSelectedSoundEffect(atInded index: Int) {
        deselectOldsSelectedItem()
        selectNewDeselectedItem(atIndex: index)
        oldSelectedSoundIndex = index
    }
    
    private func selectNewDeselectedItem(atIndex index: Int) {
        let deselectedOld = soundEffectList[index]
        let newSelected = SoundEffect(id: deselectedOld.id,
                                        name: deselectedOld.name,
                                        fileType: deselectedOld.fileType,
                                        isSelected: true)
        soundEffectList.remove(at: index)
        soundEffectList.insert(newSelected, at: index)
    }
    
    private func deselectOldsSelectedItem() {
        let oldSelected = soundEffectList[oldSelectedSoundIndex]
        let deselectedOld = SoundEffect(id: oldSelected.id,
                                        name: oldSelected.name,
                                        fileType: oldSelected.fileType,
                                        isSelected: false)
        soundEffectList.remove(at: oldSelectedSoundIndex)
        soundEffectList.insert(deselectedOld, at: oldSelectedSoundIndex)
    }
}
