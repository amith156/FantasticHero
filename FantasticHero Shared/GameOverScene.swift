//
//  GameOverScene.swift
//  FantasticHero iOS
//
//  Created by Amith Narayan on 14/05/2021.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartLable = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 250
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLable = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
        scoreLable.text = "Score: \(gameScore)"
        scoreLable.fontSize = 125
        scoreLable.fontColor = SKColor.white
        scoreLable.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLable.zPosition = 1
        self.addChild(scoreLable)
        
        let defaults = UserDefaults()
        var highScoreNum = defaults.integer(forKey: "highScoreSaved")
        
        if(gameScore > highScoreNum) {
            highScoreNum = gameScore
            defaults.setValue(highScoreNum, forKey: "highScoreSaved")
        }
        
        let highScoreLable = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
        highScoreLable.text = "High Score: \(highScoreNum)"
        highScoreLable.fontSize = 125
        highScoreLable.fontColor = SKColor.white
        highScoreLable.zPosition = 1
        highScoreLable.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLable)
    
        
        restartLable.text = "Restart"
        restartLable.fontColor = SKColor.white
        restartLable.fontSize = 90
        restartLable.zPosition = 1
        restartLable.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLable)
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let touchPount = touch.location(in: self)
            
            if restartLable.contains(touchPount) {
                
                let moveToGameScene = GameScene(size: self.size)
                moveToGameScene.scaleMode = self.scaleMode
                let transion = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(moveToGameScene, transition: transion)
            
            
            }
            
        }
    }
    
    
}
