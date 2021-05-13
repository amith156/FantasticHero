//
//  GameScene.swift
//  FantasticHero Shared
//
//  Created by Amith Narayan on 12/05/2021.
//

import SpriteKit

class GameScene: SKScene {
    
    let gameArea : CGRect
    let player = SKSpriteNode(imageNamed: "hero01")
    
    override init(size: CGSize) {
        
        let aspectRatioMax : CGFloat = 16.0/9.0
        let playableWidth = size.height / aspectRatioMax

        //gettting marging by using the center
        let margin = (size.width - playableWidth) / 2
        
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}

//MARK:- Override Function
extension GameScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/6)
        player.zPosition = 2
        self.addChild(player)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletFiring()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            let previousPointTouch = touch.previousLocation(in: self)
            let presentPointTouch = touch.location(in: self)
            let amountDraggedX = presentPointTouch.x - previousPointTouch.x
            let amountDraggedY = presentPointTouch.y - previousPointTouch.y
            player.position.x += amountDraggedX
            player.position.y += amountDraggedY
            
            if(player.position.y > (gameArea.maxY) / 2) {
                player.position.y = gameArea.maxY/2
            }
            
            if(player.position.y < gameArea.minY) {
                player.position.y = gameArea.minY
            }
            
            
            //if moved too far to right, bump it back to game area
            if(player.position.x > gameArea.maxX) {
                player.position.x = gameArea.maxX
            }
            
            //if moved too far to left, bump it back to game area
            if(player.position.x < gameArea.minX) {
                player.position.x = gameArea.minX
            }
        }
    }
    
    
    
}

//MARK:- Helper Functions
extension GameScene {
    
    func bulletFiring() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.zPosition = 1
        bullet.position = player.position
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height + 2, duration: 1.25)
        let deleteBullet = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBullet, deleteBullet]))
    }
    
    
    func enemyAttack() {
        let randomStartX = randomRange(min: gameArea.minX, max: gameArea.maxX)
        let RandomEndX = randomRange(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomStartX, y: self.size.height + 1.4)
        let endPont = CGPoint(x: RandomEndX, y: -20)
        
        let enemyBullet = SKSpriteNode(imageNamed: "bullet02")
        enemyBullet.position = startPoint
        enemyBullet.zPosition = 2
        self.addChild(enemyBullet)
        
        let moveEnemyBullet = SKAction.move(to: endPont, duration: 1.3)
        let deleteEnemyBullet = SKAction.removeFromParent()
        enemyBullet.run(SKAction.sequence([moveEnemyBullet,deleteEnemyBullet]))
        
        enemyBullet.zRotation = calculateAngleRotate(dy : (endPont.y - startPoint.y), dx: (endPont.x - startPoint.x))
        
    }
    
    func startNewLevel() {
        let waitToAttack = SKAction.wait(forDuration: 0.75)
        let attack = SKAction.run(enemyAttack)
        let continuousAttack = SKAction.repeatForever(SKAction.sequence([waitToAttack,attack]))
        self.run(continuousAttack)
    }
    

    
}

//MARK:- Utilities
extension GameScene {
    
    func calculateAngleRotate(dy : CGFloat, dx: CGFloat) -> CGFloat {
        return atan2(dy, dx)
    }
    
    //rage from 0 to 1
    func randomRange() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomRange(min : CGFloat, max : CGFloat) -> CGFloat {
        return randomRange() * (max-min) + min
    }
}
