//
//  AudioViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 24/02/23.
//

import Foundation
import AVFoundation

struct SoundEffect: Codable {
    var id: String
    var name: String
    var fileType: String
    var isSelected = false
    
    init(name: String,
         fileType: String,
         isSelected: Bool = false) {
        id = UUID().uuidString
        self.name = name
        self.fileType = fileType
        self.isSelected = isSelected
    }
    
    init(id: String,
         name: String,
         fileType: String,
         isSelected: Bool) {
        self.id = id
        self.name = name
        self.fileType = fileType
        self.isSelected = isSelected
    }
    
    func fileName() -> String {
        "\(name).\(fileType)"
    }
}

class AudioViewModel {
    let engine = AVAudioEngine()
    private var audioPlayerNodeList: [AVAudioPlayerNode] = []
    private var speedControlList: [AVAudioUnitVarispeed] = []
    private var pitchControlList: [AVAudioUnitTimePitch] = []
    private var file = AVAudioFile()
    private var numberOfAvailableNodes = 30
    private var currentPitch: Int = 0
    private var pitchValidRange = -2400...2400
    private var currentNodeIndex = 0
    
    init() {
        for _ in 0..<numberOfAvailableNodes {
            audioPlayerNodeList.append(AVAudioPlayerNode())
            speedControlList.append(AVAudioUnitVarispeed())
            pitchControlList.append(AVAudioUnitTimePitch())
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            debugPrint(error)
        }
    }
    
    func start() {
        let currentSettings = SettingsDataRepository().retrieveSettings()
        currentPitch = currentSettings.pitch
        do {
            let fileName = currentSettings.soundEffect.fileName()
            let audioUrl = audioUrl(fileName: fileName)
            try loadAudioEngine(withSoundUrl: audioUrl)
        } catch {
            debugPrint(error)
        }
    }
    
    func setPitch(value: Int) {
        currentPitch = pitchValidRange.contains(value) ? value : 0
    }
        
    private func audioUrl(fileName: String) -> URL {
        let sound = Bundle.main.path(forResource: fileName, ofType: nil)
        return URL(fileURLWithPath: sound!)
    }
    
    func play() {
        pitchControlList[currentNodeIndex].pitch = Float(currentPitch)
        let currentNode = audioPlayerNodeList[currentNodeIndex]
        currentNode.scheduleFile(file, at: nil)
        currentNode.play()
        currentNodeIndex = (currentNodeIndex + 1) % audioPlayerNodeList.count
    }
    
    private func loadAudioEngine(withSoundUrl url: URL) throws {
        file = try AVAudioFile(forReading: url)
        for (index, node) in audioPlayerNodeList.enumerated() {
            engine.attach(node)
            engine.attach(pitchControlList[index])
            engine.attach(speedControlList[index])
            engine.connect(node, to: speedControlList[index], format: nil)
            engine.connect(speedControlList[index], to: pitchControlList[index], format: nil)
            engine.connect(pitchControlList[index], to: engine.mainMixerNode, format: nil)
        }
        try engine.start()
    }
    
    private func initSoundEffectsList() -> [SoundEffect] {
        AudioViewModel.testSoundEffectList()
    }
    
    static func testSoundEffectList() -> [SoundEffect] {
        return [SoundEffect(name: "tangel", fileType: "wav", isSelected: true),
                SoundEffect(name: "single", fileType: "mp3")]
    }
}
