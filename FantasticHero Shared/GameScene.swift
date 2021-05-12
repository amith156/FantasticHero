//
//  GameScene.swift
//  FantasticHero Shared
//
//  Created by Amith Narayan on 12/05/2021.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "hero01")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        player.zPosition = 2
        self.addChild(player)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletFiring()
    }

}

extension GameScene {
    
    func bulletFiring() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.zPosition = 1
        bullet.position = player.position
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height + 2, duration: 1.25)
        let deleteBullet = SKAction.removeFromParent()
        let x = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(x)
    }
    
    
}
