//
//  GamePlayViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 18/02/23.
//

import Foundation
import Combine
import SpriteKit

final class TimeAttackViewModel: ObservableObject, GameViewModel {
    @Published var score: Int = 0
    @Published var timerCount = 10
    @Published var scene: GameScene
    private var timer: Timer?
    private var isFirstHist = true
    private var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private var audio: AudioViewModel
    let didComplete = PassthroughSubject<TimeAttackViewModel, Never>()
    let playScreenRecorder = PassthroughSubject<Void, Never>()
    let stopScreenRecorder = PassthroughSubject<Void, Never>()
    
    init() {
        audio = AudioViewModel()
        scene = SceneFactory().scene(forCategory: .TimeAttack)
        let factory = FactoryDependecy(nodeFactory: NodeFactory(),
                                       fieldFactory: FieldFactory())
        scene.setup(viewModel: self, factory: factory)
    }
    
    func startGame() {
        playScreenRecorder.send()
        timerCount = 10
        score = 0
        isFirstHist = true
        audio.start()
        scene.view!.allowsTransparency = true
        scene.view!.backgroundColor = .clear
    }
    
    func stopGame() {
        stopScreenRecorder.send()
        timer?.invalidate()
        timer = nil
        scene.cleanUpEnvironment()
        didComplete.send(self)
    }
    
    func incrementScore() {
        feedbackGenerator.prepare()
        if isFirstHist {
            isFirstHist = false
            startTimer()
        }
        score += 1
        audio.play()
        feedbackGenerator.impactOccurred()
    }
    
    func resetTouches() {
        let touchesToRemove = scene.children.compactMap { $0.name == GameSpriteCategory.player.rawValue ? $0 : nil }
        scene.removeChildren(in: touchesToRemove)
    }
    
    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                guard self.timerCount > 0 else {
                    self.stopGame()
                    return
                }
                self.timerCount -= 1
            })
        }
    }
}

class SpriteItem: SKSpriteNode {
    var isEnable: Bool
    init(withShape shape: SKShapeNode,
         physicsBody: SKPhysicsBody?,
         name: String,
         position: CGPoint,
         isEnable: Bool = true) {
        self.isEnable = isEnable
        super.init(texture: .none, color: .clear, size: .zero)
        addChild(shape)
        self.physicsBody = physicsBody
        self.name = name
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
