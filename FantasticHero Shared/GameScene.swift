//
//  GameScene.swift
//  FantasticHero Shared
//
//  Created by Amith Narayan on 12/05/2021.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let player = SKSpriteNode(imageNamed: "hero01")
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        player.zPosition = 2
        self.addChild(player)
        
    }


}
