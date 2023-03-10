//
//  NodeFactory.swift
//   GameRecorder
//
//  Created by ovidio morisano on 06/03/23.
//

import Foundation
import SpriteKit

struct NodeFactory {
    private var enemySpriteName: String {
        get {
            GameSpriteCategory.enemy.rawValue
        }
    }
    
    func enemyNode(atPosition position: CGPoint) -> SKSpriteNode {
        let shape = createCircularShape(withRadius: 20, color: .red)
        let physicsBody = PhysicsBodyFactory.enemyPhysicBody()
        let name = enemySpriteName
        let enemy = SpriteItem(withShape: shape,
                                 physicsBody: physicsBody,
                                 name: name,
                                 position: position)
        return enemy
    }
    
    func playerNode(atPosition position: CGPoint) -> SKSpriteNode {
        let shape = createCircularShape(withRadius: 20, color: .red)
        let physicsBody = PhysicsBodyFactory.playerPhysicsBody()
        let name = GameSpriteCategory.player.rawValue
        let player = SpriteItem(withShape: shape,
                                 physicsBody: physicsBody,
                                 name: name,
                                 position: position)
        return player
    }
    
    func enemyBackgroundNode(atPosition position: CGPoint) -> SKSpriteNode {
        let shape = createCircularShape(withRadius: 50, color: .systemPink)
        let physicsBody = PhysicsBodyFactory.enemyPhysicBody()
        let name = GameSpriteCategory.enemyBackground.rawValue
        let enemyBackground = SpriteItem(withShape: shape,
                                 physicsBody: physicsBody,
                                 name: name,
                                 position: position)
        return enemyBackground
    }
    
    private func createCircularShape(withRadius radius: CGFloat,
                                     color: UIColor) -> SKShapeNode {
        let shape = SKShapeNode(circleOfRadius: radius)
        shape.fillColor = color
        shape.name = "Selection_Box"
        return shape
    }
}
