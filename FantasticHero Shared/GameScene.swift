//
//  GameScene.swift
//  FantasticHero Shared
//
//  Created by Amith Narayan on 12/05/2021.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    let gameArea : CGRect
    let player = SKSpriteNode(imageNamed: "hero01")
    var gameLevel : Int = 0
    let scoreLabel = SKLabelNode(fontNamed: "ReggaeOne-Regular")
    
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
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
//        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.categoryBitMask = CategoriesOfPhysics.Player
        player.physicsBody?.collisionBitMask = CategoriesOfPhysics.EnemyBullet
        player.physicsBody?.allowsRotation = false
        
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/6)
        player.zPosition = 2
        self.addChild(player)
        
        scoreFuction()
        startNewLevel()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {    //gives contact bodyA & Contact bodyB
        
        var contactBodyA = SKPhysicsBody()
        var contactBodyB = SKPhysicsBody()
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {     //re-arrageign on the contact body based on the binary
            contactBodyA = contact.bodyA
            contactBodyB = contact.bodyB
        }
        else {
            contactBodyA = contact.bodyB
            contactBodyB = contact.bodyA
        }
        
        // player contact with enemyBullet
        if(contactBodyA.categoryBitMask == CategoriesOfPhysics.Player
            && contactBodyB.categoryBitMask == CategoriesOfPhysics.EnemyBullet) {
            
            if let positionA = contactBodyA.node?.position {
                explosionOnContact(explosionPosition: positionA)
            }
            contactBodyA.node?.removeFromParent()
            contactBodyB.node?.removeFromParent()

        }
        
        // bullet contact with enemyBullet
        if (contactBodyA.categoryBitMask == CategoriesOfPhysics.Bullet
                && contactBodyB.categoryBitMask == CategoriesOfPhysics.EnemyBullet) {
            
            addScore()
            
            if let postionA = contactBodyA.node?.position {
                explosionOnContact(explosionPosition: postionA)
            }
            
            if let positionB = contactBodyB.node?.position {
                explosionOnContact(explosionPosition: positionB)
            }
            
            
            
            contactBodyA.node?.removeFromParent()
            contactBodyB.node?.removeFromParent()
            
        }
        
        
    }
    

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletFiring()
//        enemyAttack()
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
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
//        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = CategoriesOfPhysics.Bullet
        bullet.physicsBody?.collisionBitMask = CategoriesOfPhysics.None
        bullet.physicsBody?.contactTestBitMask = CategoriesOfPhysics.EnemyBullet
        
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
        
        let enemyBullet = SKSpriteNode(imageNamed: "torpedo")
        enemyBullet.physicsBody = SKPhysicsBody(rectangleOf: enemyBullet.size)
        enemyBullet.physicsBody?.affectedByGravity = false
        enemyBullet.physicsBody?.isDynamic = true
//        enemyBullet.physicsBody?.usesPreciseCollisionDetection = true
        enemyBullet.physicsBody?.categoryBitMask = CategoriesOfPhysics.EnemyBullet
        enemyBullet.physicsBody?.collisionBitMask = CategoriesOfPhysics.None
        enemyBullet.physicsBody?.contactTestBitMask = CategoriesOfPhysics.Bullet | CategoriesOfPhysics.Player
        
        enemyBullet.position = startPoint
        enemyBullet.zPosition = 2
        enemyBullet.setScale(2)
        self.addChild(enemyBullet)
        
        let moveEnemyBullet = SKAction.move(to: endPont, duration: 1.5)
        let deleteEnemyBullet = SKAction.removeFromParent()
        enemyBullet.run(SKAction.sequence([moveEnemyBullet,deleteEnemyBullet]))
        
        enemyBullet.zRotation = calculateAngleRotate(dy : (endPont.y - startPoint.y), dx: (endPont.x - startPoint.x))
        
    }
    
    func startNewLevel() {
        let waitToAttack = SKAction.wait(forDuration: 1.75)
        let attack = SKAction.run(enemyAttack)
        let continuousAttack = SKAction.repeatForever(SKAction.sequence([waitToAttack,attack]))
        self.run(continuousAttack)
    }
    
    func scoreFuction() {
        scoreLabel.zPosition = 100
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 100
//        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.9)
        scoreLabel.position = CGPoint(x: 10.0, y: self.size.height-scoreLabel.fontSize)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        self.addChild(scoreLabel)
    }
    
    
    
    func explosionOnContact(explosionPosition : CGPoint) {
        
        let explosion = SKSpriteNode(imageNamed: "bang")
        explosion.position = explosionPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let scaleIn = SKAction.scale(to: 5, duration: 0.25)
        let removeExplosion = SKAction.removeFromParent()
        explosion.run(SKAction.sequence([scaleIn, fadeOut, removeExplosion]))
        
    }

    
}

//MARK:- Utilities
extension GameScene {
    
    func addScore() {
        gameLevel += 1
        scoreLabel.text = "Score: \(gameLevel)"
    }
    
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
