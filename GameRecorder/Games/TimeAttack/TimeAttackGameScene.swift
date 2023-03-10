//
//   GameRecorderEngine.swift
//   GameRecorder
//
//  Created by ovidio morisano on 16/02/23.
//

import Foundation
import SpriteKit
import SwiftUI
import SceneKit

final class TimeAttackScene: SKScene, SKPhysicsContactDelegate, GameScene {
    weak var viewModel: TimeAttackViewModel!
    var factory: FactoryDependecy!
    override func didMove(to view: SKView) {
        initEnvironment(forView: view)
        viewModel.startGame()
        view.allowsTransparency = true
        view.backgroundColor = .clear
        backgroundColor = .clear
    }

    func cleanUpEnvironment() {
        self.removeAllActions()
        self.removeAllChildren()
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
        guard let enemy = children.first(where: { $0.name == GameSpriteCategory.enemy.rawValue }),
              let enemyBackground = children.first(where: { $0.name == "EnemyBackground" }) else { return }
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
        guard let enemy = childNode(withName: GameSpriteCategory.enemy.rawValue) as? SpriteItem else { return }
        let fingersNearEnemy = touches.first {
            distance(from: enemy.position, to: $0.location(in: self)) < 45
        }
        guard fingersNearEnemy == nil else { return }
        enemy.isEnable = true
    }
    
    func setup(viewModel: GameViewModel,
               factory: FactoryDependecy) {
        self.viewModel = viewModel as? TimeAttackViewModel
        self.factory = factory
    }
}

//MARK: SKPhysicsContactDelegate
extension TimeAttackScene {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let enemy = childNode(withName: GameSpriteCategory.enemy.rawValue) as? SpriteItem,
        enemy.isEnable == true else { return }
        viewModel?.incrementScore()
        enemy.isEnable = false
    }

    func didEnd(_ contact: SKPhysicsContact) {}
}

extension TimeAttackScene {
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

extension TimeAttackScene {
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
