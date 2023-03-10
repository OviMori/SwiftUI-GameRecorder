//
//  SceneFactory.swift
//   GameRecorder
//
//  Created by ovidio morisano on 27/02/23.
//

import Foundation
import UIKit

struct SceneFactory {
    func scene(forCategory category: GameCategory) -> GameScene {
        switch category {
        case .TimeAttack:
            return timeAttackScene()
        case .Endurance:
            return enduranceScene()
        }
    }
    
    private func timeAttackScene() -> TimeAttackScene{
        let scene = TimeAttackScene()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        scene.physicsWorld.contactDelegate = scene
        scene.size = CGSize(width: width, height: height)
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFit
        return scene
    }
    
    private func enduranceScene() -> EnduranceGameScene {
        let scene = EnduranceGameScene()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        scene.physicsWorld.contactDelegate = scene
        scene.size = CGSize(width: width, height: height)
        scene.backgroundColor = .white
        scene.scaleMode = .aspectFit
        return scene
    }
}
