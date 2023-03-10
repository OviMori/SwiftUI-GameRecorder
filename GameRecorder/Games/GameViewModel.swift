//
//  GameViewModel.swift
//   GameRecorder
//
//  Created by ovidio morisano on 27/02/23.
//

import Foundation
import SpriteKit

protocol GameViewModel {
    func startGame()
    func incrementScore()
    func stopGame()
}

enum SpriteNodeCategory: UInt32 {
    case noCollision = 0
    case enemy = 0x01
    case player = 0x02
    case gravity = 0x03
    case generalGravity = 0x04
    case enemyBackground = 0x05
}

enum GameSpriteCategory: String {
    case player = "Player"
    case enemy = "Enemy"
    case enemyBackground = "EnemyBackground"
}

enum MainMenuDestination {
    case TimeAttack
    case Endurance
    case Settings
}

enum GameCategory: String, CaseIterable {
    case TimeAttack
    case Endurance
}

struct FactoryDependecy {
    var nodeFactory: NodeFactory
    var fieldFactory: FieldFactory
}
