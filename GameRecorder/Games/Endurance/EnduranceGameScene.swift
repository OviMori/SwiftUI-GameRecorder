//
//  EnduranceGameScene.swift
//   GameRecorder
//
//  Created by ovidio morisano on 27/02/23.
//

import Foundation
import SpriteKit
import SwiftUI
import SceneKit

final class EnduranceGameScene: SKScene, SKPhysicsContactDelegate, GameScene {
    var viewModel: EnduranceViewModel!
    var factory: FactoryDependecy!
    private let defaultScaleValue: Float = 1
    private let minimumDistanceToActivateEnemy: CGFloat = 45
    private var lastUpdateTime: Date = Date()
    private var isFirstHit: Bool {
        get {
            viewModel.isFirstHit == true
        }
    }
    private var enemySpriteName: String {
        get {
            GameSpriteCategory.enemy.rawValue
        }
    }
    
    override func didMove(to view: SKView) {
        initEnvironment(forView: view)
        viewModel.scheduledGameplayValidator = { [weak self] in
            let _ = self?.isTimeIntervalValid()
        }
        viewModel.startGame()
    }
    
    func cleanUpEnvironment() {
        removeAllActions()
        removeAllChildren()
    }

    private func initEnvironment(forView view: SKView) {
        view.isMultipleTouchEnabled = true
        physicsBody = SKPhysicsBody()
        physicsBody?.isDynamic = true
        physicsWorld.contactDelegate = self
        addCenteredGravityField(atPosition: frameCenter())
        addDragField(atPosition: frameCenter())
        addEnemyBackgroundNode(atPosition: frameCenter())
        addEnemyNode(atPosition: frameCenter())
        jointEnemyBackgroundToEnemy()
    }
        
    private func jointEnemyBackgroundToEnemy() {
        guard let enemy = children.first(where: { $0.name == enemySpriteName }),
              let enemyBackground = children.first(where: { $0.name == GameSpriteCategory.enemyBackground.rawValue }) else { return }
        let enemyJoint = SKPhysicsJointSpring.joint(withBodyA: enemy.physicsBody!,
                                                       bodyB: enemyBackground.physicsBody!,
                                                       anchorA: enemy.position,
                                                       anchorB: enemyBackground.position)
        enemyJoint.frequency = 7
        scene?.physicsWorld.add(enemyJoint)
    }
        
    //    private func addPhysicsBoundariesToScene() {
    //        let physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    //        physicsBody.isDynamic = false
    //        self.physicsBody = physicsBody
    //    }
    
    private func frameCenter() -> CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }
    
    private func distanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(from: from, to: to))
    }
    
    private func enemyActivationState(usingTouches touches: Set<UITouch>) {
        guard let enemy = childNode(withName: enemySpriteName) as? SpriteItem else { return }
        let fingersNearEnemy = touches.first {
            distance(from: enemy.position, to: $0.location(in: self)) < minimumDistanceToActivateEnemy
        }
        guard fingersNearEnemy == nil else { return }
        enemy.isEnable = true
    }
    
    private func isTimeIntervalValid() -> Bool {
        guard isFirstHit == false else {
            return false
        }
        let currentTime = Date()
        guard Float(currentTime.timeIntervalSince(lastUpdateTime)) < viewModel.refreshRate else {
            closeScene()
            return false
        }
        return true
    }
    
    private func resetTimeInterval() {
        guard isFirstHit == false else {
            lastUpdateTime = Date()
            return
        }
        let currentTime = Date()
        guard Float(currentTime.timeIntervalSince(lastUpdateTime)) < viewModel.refreshRate else {
            closeScene()
            return
        }
        lastUpdateTime = currentTime
    }
    
    private func closeScene() {
        let enemyName = enemySpriteName
        scaleNode(withName: enemyName, toValue: CGFloat(defaultScaleValue))
        viewModel.stopGame()
    }
    
    private func updateScore() {
        guard let enemy = childNode(withName: enemySpriteName) as? SpriteItem,
        enemy.isEnable == true else { return }
        enemy.isEnable = false
        resetTimeInterval()
        viewModel.incrementScore()
    }
    
    private func scaleNode(withName nodeName: String, toValue value: CGFloat) {
        let node = childNode(withName: nodeName)
        node?.xScale = value
        node?.yScale = value
    }

    func setup(viewModel: GameViewModel,
               factory: FactoryDependecy) {
        self.viewModel = viewModel as? EnduranceViewModel
        self.factory = factory
    }
    
    private func updateScaling(forNodeWithName nodeName: String) {
        guard !isFirstHit else {
            return
        }
        let newScaleValue = currentScaleValue()
        guard newScaleValue > 0 else {
            return }
        scaleNode(withName: nodeName, toValue: newScaleValue)
    }
    
    private func currentScaleValue() -> CGFloat {
        let delta =  -lastUpdateTime.timeIntervalSinceNow
        let newScaleValue = CGFloat(defaultScaleValue - (Float(delta) / viewModel.refreshRate))
        return newScaleValue
    }
}

//MARK: SKPhysicsContactDelegate
extension EnduranceGameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        updateScore()
    }

    func didEnd(_ contact: SKPhysicsContact) {}
}

//MARK: Game items creation
extension EnduranceGameScene {
    override func update(_ currentTime: TimeInterval) {
        guard isTimeIntervalValid() else {
            return
        }
        updateScaling(forNodeWithName: enemySpriteName)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let fingersToRemove = children.compactMap { $0.name == GameSpriteCategory.player.rawValue ? $0 : nil }
        removeChildren(in: fingersToRemove)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        addPlayerNode(atPosition: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let previuosLocation = touch.previousLocation(in: self)
            spriteNode(at: previuosLocation)?.position = touchLocation
        }
        enemyActivationState(usingTouches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.previousLocation(in: self)
            spriteNode(at: touchPosition)?.removeFromParent()
        }
    }
    
    private func spriteNode(at location: CGPoint) -> SpriteItem? {
        nodes(at: location).filter { $0.name == GameSpriteCategory.player.rawValue }.first as? SpriteItem
    }
}

extension EnduranceGameScene {
    func addEnemyNode(atPosition position: CGPoint) {
        let enemy = factory.nodeFactory.enemyNode(atPosition: position)
        addChild(enemy)
    }
    
    func addPlayerNode(atPosition position: CGPoint) {
        let finger = factory.nodeFactory.playerNode(atPosition: position)
        addChild(finger)
    }
    
    func addEnemyBackgroundNode(atPosition position: CGPoint) {
        let enemyBackground = factory.nodeFactory.enemyBackgroundNode(atPosition: position)
        addChild(enemyBackground)
    }

    func addCenteredGravityField(atPosition position: CGPoint) {
        let gravity = factory.fieldFactory.centeredGravityField(atPosition: position)
        addChild(gravity)
    }
    
    func addDragField(atPosition position: CGPoint) {
        let gravity = factory.fieldFactory.dragField(atPosition: position)
        addChild(gravity)
    }
}


//    player speed functions
//    private func setupTimer() {
//        guard let viewModel = viewModel as? EnduranceViewModel else { return }
//        resetTooSlowFlagsTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(viewModel.refreshRate), repeats: true, block: { [weak viewModel] timer in
//            debugPrint("Reset flags call")
//            viewModel.resetTooSlowFlags()
//        })
//    }
//
//
//    private func checkPlayerSpeed(usingTouches touches: Set<UITouch>) {
//        guard let viewModel = viewModel as? EnduranceViewModel else { return }
//        guard let touchLocation = touches.first else { return }
//        let location = touchLocation.location(in: self)
//        let previousLocation = touchLocation.previousLocation(in: self)
//        let distance = distance(from: previousLocation, to: location)
//        let timeSinceLastUpdate = deltaTime
//
//        if timeSinceLastUpdate > 0 {
//            let velocity = distance / CGFloat(timeSinceLastUpdate)
//            if velocity < viewModel.minSpeedAllowed {
//                viewModel.tooSlowFlags -= 1
//            }
//            guard viewModel.tooSlowFlags > 0 else {
//                viewModel.stopGame()
//                return
//            }
//        }
//        self.deltaTime = 0
//    }
