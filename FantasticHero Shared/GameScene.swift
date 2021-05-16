//
//  GameScene.swift
//  FantasticHero Shared
//
//  Created by Amith Narayan on 12/05/2021.
//

import SpriteKit

enum GameState {
    case beforeGame
    case duringGame
    case afterGame
}

var gameScore : Int = 0

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var currentGameState = GameState.beforeGame
    let gameArea : CGRect
    let player = SKSpriteNode(imageNamed: "hero01")
    let enemy = SKSpriteNode(imageNamed: "monster")

    let scoreLabel = SKLabelNode(fontNamed: "ReggaeOne-Regular")
    var gameLevel :Int = 0
    var lifeLineNumber = 5
    let lifeLineLable = SKLabelNode(fontNamed: "ReggaeOne-Regular")
    let tapToStartLable = SKLabelNode(fontNamed: "ReggaeOne-Regular")
    var enemyLiveCounter : Int

    
    override init(size: CGSize) {
        
        enemyLiveCounter = 0

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
        gameScore = 0
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
        player.position = CGPoint(x: self.size.width/2, y: 0 - self.size.height)
        player.zPosition = 2
        self.addChild(player)
        
        enemy.position = CGPoint(x: self.size.width/2, y: self.size.height)
        enemySetup()

        tapToStartFuction()
        scoreFuction()
        lifeLineFunction()

        
        

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
            gameOver()

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
        
        //bullet contact with enemy
        if(contactBodyA.categoryBitMask == CategoriesOfPhysics.Bullet && contactBodyB.categoryBitMask == CategoriesOfPhysics.Enemy) {
            if let postionB = contactBodyB.node?.position {
                enemyLiveCounter += 1
                explosionOnContact(explosionPosition: postionB)
                
            }
            
            if(enemyLiveCounter > 5) {
                contactBodyB.node?.removeFromParent()
            }
        }
        
        
    }
    

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(currentGameState == .beforeGame) {
            startNewGame()
        }
        else if(currentGameState == .duringGame) {
            bulletFiring()
        }
        
//        enemyAttack()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            let previousPointTouch = touch.previousLocation(in: self)
            let presentPointTouch = touch.location(in: self)
            let amountDraggedX = presentPointTouch.x - previousPointTouch.x
            let amountDraggedY = presentPointTouch.y - previousPointTouch.y
            
            if(currentGameState == .duringGame) {
                player.position.x += amountDraggedX
                player.position.y += amountDraggedY
            }
            
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
    
    func startNewGame() {
        currentGameState = .duringGame
        
        //deletes the "tap to start" button
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        tapToStartLable.run(SKAction.sequence([fadeOutAction, deleteAction]))
        
        //moving the hero back to screen
        let movePlayerToScreen = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        player.run(SKAction.sequence([movePlayerToScreen, startLevelAction]))
        
    }
    
    
    
    
    func bulletFiring() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "bullet"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
//        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = CategoriesOfPhysics.Bullet
        bullet.physicsBody?.collisionBitMask = CategoriesOfPhysics.None
        bullet.physicsBody?.contactTestBitMask = CategoriesOfPhysics.EnemyBullet | CategoriesOfPhysics.Enemy
        
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
        enemyBullet.name = "enemyBullet"
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
        let looseLifeBlock = SKAction.run(loseLife)
        if(currentGameState == .duringGame) {
            enemyBullet.run(SKAction.sequence([moveEnemyBullet,deleteEnemyBullet, looseLifeBlock]))
        }
        
        
        enemyBullet.zRotation = calculateAngleRotate(dy : (endPont.y - startPoint.y), dx: (endPont.x - startPoint.x))
        
    }
    
    func enemySetup() {
        
        
        enemy.zPosition = 2
        enemy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = CategoriesOfPhysics.Enemy
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.restitution = 1
        enemy.physicsBody?.linearDamping = 0
        let border = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: self.frame.height/2, width: self.frame.width, height: self.frame.height/2))
////        let border = SKPhysicsBody(edgeLoopFrom:frame)
        border.friction = 0
        border.affectedByGravity = true
        physicsBody = border
        
        
        enemy.setScale(3)
        
        self.addChild(enemy)
        enemy.physicsBody?.applyImpulse(CGVector(dx: 170, dy: -250))
        
    }
    
    
    
    
    
    
    func startNewLevel() {
        gameLevel += 1
        var waitToAttackDuration = TimeInterval()
        if (self.action(forKey: "enemiesAttackKey") != nil) {
            self.removeAction(forKey: "enemiesAttackKey")
        }
        
        switch gameLevel {
        case 1:
            waitToAttackDuration = 1.75
        case 2:
            waitToAttackDuration = 1.3
        case 3:
            waitToAttackDuration = 0.9
        case 4:
            waitToAttackDuration = 0.5
        default:
            waitToAttackDuration = 1.5
        }
        
        
        let waitToAttack = SKAction.wait(forDuration: waitToAttackDuration)
        let attack = SKAction.run(enemyAttack)
        let continuousAttack = SKAction.repeatForever(SKAction.sequence([waitToAttack,attack]))
        self.run(continuousAttack, withKey: "enemiesAttackKey")
    }
    
    func lifeLineFunction() {
        lifeLineLable.text = "Life: 5"
        lifeLineLable.fontSize = 100
        lifeLineLable.fontColor = SKColor.white
        lifeLineLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        lifeLineLable.zPosition = 100
        lifeLineLable.position = CGPoint(x: self.size.width - 10.0 , y: self.size.height + lifeLineLable.frame.size.height)
        lifeLineLable.run(SKAction.moveTo(y: self.size.height - lifeLineLable.frame.size.height , duration: 0.3))
        self.addChild(lifeLineLable)
    }
    
    func scoreFuction() {
        scoreLabel.zPosition = 100
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 100
//        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.9)
        scoreLabel.position = CGPoint(x: 10.0, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.run(SKAction.moveTo(y: self.size.height - scoreLabel.frame.size.height , duration: 0.3))
        self.addChild(scoreLabel)
    }
    
    func tapToStartFuction() {
        tapToStartLable.text = "Tap To Start"
        tapToStartLable.fontSize = 100
        tapToStartLable.zPosition = 1
        tapToStartLable.fontColor = SKColor.white
        tapToStartLable.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLable.alpha = 0
        self.addChild(tapToStartLable)
        tapToStartLable.run(SKAction.fadeIn(withDuration: 0.4))
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
    
    func gameOver() {
        
        currentGameState = .afterGame
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "enemyBullet") { enemyBullet, stop in
            enemyBullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "bullet") { bullet, stop in
            bullet.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeToNewScene)
        
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        self.run(SKAction.sequence([waitToChangeScene, changeSceneAction]))
        
        
        
    }
    
    
    func changeToNewScene() {
        let moveToGameOverScene = GameOverScene(size: self.size)
        moveToGameOverScene.scaleMode = self.scaleMode
        let transition = SKTransition.flipVertical(withDuration: 0.5)
        self.view?.presentScene(moveToGameOverScene, transition: transition)
    }
    
    
    func loseLife() {
        lifeLineNumber -= 1
        lifeLineLable.text = "Life: \(lifeLineNumber)"
        
        let scaleUpAnimate = SKAction.scale(to: 1.5, duration: 0.3)
        let ScaleDownAnimat = SKAction.scale(to: 1, duration: 0.2)
        let changeColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0)
        let returnColor = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0)
        lifeLineLable.run(SKAction.sequence([changeColor,scaleUpAnimate,ScaleDownAnimat,returnColor]))
        
        if(lifeLineNumber == 0) {
            gameOver()
        }
    }
    
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if(gameScore == 10 || gameScore ==  20 || gameScore == 30) {
            
            startNewLevel()
        }
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
