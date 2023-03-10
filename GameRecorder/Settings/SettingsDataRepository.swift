//
//  SettingsDataRepository.swift
//   GameRecorder
//
//  Created by ovidio morisano on 25/02/23.
//

import Foundation

struct Settings: Codable {
    var pitch: Int
    var soundEffect: SoundEffect
    var screenRecorderActivationState: Bool
}

struct SettingsDataRepository {
    private static let settingsKey = "SETTINGSKEY"
    private static let soundEffectsKey = "SOUNDEFFECTSLIST"
    
    func retrieveSettings() -> Settings {
        loadSettings() ?? defaultSettings()
    }

    func retrieveSoundEffects() -> [SoundEffect] {
        loadSoundEffectList() ?? AudioViewModel.testSoundEffectList()
    }
    
    func saveScreenRecorderState(withNewValue value: Bool) {
        let settings = retrieveSettings()
        let newSettings = Settings(pitch: settings.pitch,
                                   soundEffect: settings.soundEffect,
                                   screenRecorderActivationState: value)
        save(settings: newSettings)
    }
    
    func save(settings: Settings) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(settings)
            UserDefaults.standard.set(data, forKey: SettingsDataRepository.settingsKey)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    private func loadSettings() -> Settings? {
        if let data = UserDefaults.standard.data(forKey: SettingsDataRepository.settingsKey) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Settings.self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return nil
    }
    
    func save(soundEffectList: [SoundEffect]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(soundEffectList)
            UserDefaults.standard.set(data, forKey: SettingsDataRepository.soundEffectsKey)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func loadSoundEffectList() -> [SoundEffect]? {
        if let data = UserDefaults.standard.data(forKey: SettingsDataRepository.soundEffectsKey) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([SoundEffect].self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return nil
    }
    
    private func defaultSettings() -> Settings {
        return Settings(pitch: 0,
                        soundEffect: SoundEffect(name: "tangel", fileType: "wav", isSelected: true),
                        screenRecorderActivationState: false)
    }
}
