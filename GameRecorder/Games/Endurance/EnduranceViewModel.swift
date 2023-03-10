//
//  EnduranceViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 27/02/23.
//

import Foundation
import Combine
import SpriteKit

final class EnduranceViewModel: GameViewModel, ObservableObject {
    @Published var score: Int = 0
    @Published var timerCount = 0
    @Published var scene: GameScene
    private var timer: Timer?
    private var audio: AudioViewModel
    private var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var scheduledGameplayValidator: (() -> Void)? //trigger gameplay check from viewModel
    let didComplete = PassthroughSubject<EnduranceViewModel, Never>()
    var refreshRate: Float = 0.5
    var isFirstHit = true

    init() {
        audio = AudioViewModel()
        scene = SceneFactory().scene(forCategory: .Endurance)
        var factory = FactoryDependecy(nodeFactory: NodeFactory(),
                                       fieldFactory: FieldFactory())
        scene.setup(viewModel: self, factory: factory)
    }
    
    fileprivate func didTapNext() {
        didComplete.send(self)
    }
}

//MARK: GameViewModel
extension EnduranceViewModel {
    func startGame() {
        initializeProperties()
        audio.start()
    }
    
    private func initializeProperties() {
        score = 0
        timerCount = 0
        timer = nil
        isFirstHit = true
    }
    
    func stopGame() {
        timer?.invalidate()
        timer = nil
        isFirstHit = true
        scene.cleanUpEnvironment()
        didComplete.send(self)
    }
    
    func incrementScore() {
        feedbackGenerator.prepare()
        if isFirstHit {
            isFirstHit = false
            startTimer()
        }
        score += 1
        audio.play()
        feedbackGenerator.impactOccurred()
    }
    
    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                self.timerCount += 1
                self.scheduledGameplayValidator?()
            })
        }
    }
    
    func resetTouches() {
        let touchesToRemove = scene.children.compactMap { $0.name == GameSpriteCategory.player.rawValue ? $0 : nil }
        scene.removeChildren(in: touchesToRemove)
    }
}
