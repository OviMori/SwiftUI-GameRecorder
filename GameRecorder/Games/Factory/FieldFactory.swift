//
//  FieldFactory.swift
//   GameRecorder
//
//  Created by ovidio morisano on 06/03/23.
//

import Foundation
import SpriteKit

struct FieldFactory {
    func centeredGravityField(atPosition position: CGPoint) -> SKFieldNode {
        let gravity = SKFieldNode.springField()
        gravity.position = position
        gravity.strength = 40
        return gravity
    }
    
    func dragField(atPosition position: CGPoint) -> SKFieldNode {
        let gravity = SKFieldNode.dragField()
        gravity.position = position
        gravity.strength = 0.5
        return gravity
    }
}
