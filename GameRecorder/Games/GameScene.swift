//
//  GameScene.swift
//   GameRecorder
//
//  Created by ovidio morisano on 27/02/23.
//

import Foundation
import SpriteKit

protocol GameScene: SKScene {
//    var gameCategory: GameCategory { get set }
    func cleanUpEnvironment()
    func setup(viewModel: GameViewModel,
               factory: FactoryDependecy)
}
