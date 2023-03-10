//
//  PhysicsBodyFactory.swift
//   GameRecorder
//
//  Created by ovidio morisano on 20/02/23.
//

import Foundation
import SpriteKit

struct PhysicsBodyFactory {
    static func enemyBackgroundPhysicBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(circleOfRadius: 5)
        physicsBody.categoryBitMask = SpriteNodeCategory.enemyBackground.rawValue
        physicsBody.collisionBitMask = SpriteNodeCategory.noCollision.rawValue
        physicsBody.affectedByGravity = false
        physicsBody.restitution = 0
        return physicsBody
    }
    
    static func enemyPhysicBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody.categoryBitMask = SpriteNodeCategory.enemy.rawValue
        physicsBody.collisionBitMask = SpriteNodeCategory.player.rawValue
        physicsBody.fieldBitMask = SpriteNodeCategory.gravity.rawValue
        physicsBody.contactTestBitMask = SpriteNodeCategory.player.rawValue
        physicsBody.affectedByGravity = false
        physicsBody.restitution = 0
        return physicsBody
    }
    
    static func playerPhysicsBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody.categoryBitMask = SpriteNodeCategory.player.rawValue
        physicsBody.collisionBitMask = SpriteNodeCategory.enemy.rawValue
        physicsBody.affectedByGravity = false
        physicsBody.restitution = 0
        physicsBody.isDynamic = false
        return physicsBody
    }
}
