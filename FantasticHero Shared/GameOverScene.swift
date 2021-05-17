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
    let background = SKSpriteNode(imageNamed: "background")
    let gameOverLabel = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
    let scoreLable = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
    let highScoreLable = SKLabelNode(fontNamed: "ReggaeOne-Regular.ttf")
    var accessibleElements: [UIAccessibilityElement] = []
    
    
    override func didMove(to view: SKView) {
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 250
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        
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
    
        
//      Setting up Testing variables
        isAccessibilityElement       = false
        scoreLable.isAccessibilityElement = true
        
        
    }
    
    override func willMove(from view: SKView) {
        accessibleElements.removeAll()
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
extension GameOverScene {
    
    override func accessibilityElementCount() -> Int {
        initAccessibility()
        return accessibleElements.count
    }

    override func accessibilityElement(at index: Int) -> Any? {

        initAccessibility()
        if (index < accessibleElements.count) {
            return accessibleElements[index]
        } else {
            return nil
        }
    }

    override func index(ofAccessibilityElement element: Any) -> Int {
        initAccessibility()
        return accessibleElements.index(of: element as! UIAccessibilityElement)!
    }
    
    
    func initAccessibility() {

        if accessibleElements.count == 0 {

            // 1.
            let elementOfView   = UIAccessibilityElement(accessibilityContainer: self.view!)

            // 2.
            var frameForScore = scoreLable.frame

            // From Scene to View
            frameForScore.origin = (view?.convert(frameForScore.origin, from: self))!

            // Don't forget origins are different for SpriteKit and UIKit:
            // - SpriteKit is bottom/left
            // - UIKit is top/left
            //              y
            //  ┌────┐       ▲
            //  │    │       │   x
            //  ◉────┘       └──▶
            //
            //                   x
            //  ◉────┐       ┌──▶
            //  │    │       │
            //  └────┘     y ▼
            //
            // Thus before the following conversion, origin value indicate the bottom/left edge of the frame.
            // We then need to move it to top/left by retrieving the height of the frame.
            //


            frameForScore.origin.y = frameForScore.origin.y - frameForScore.size.height


            // 3.
            elementOfView.accessibilityLabel   = "ScoreTagTest"
            elementOfView.accessibilityFrame   = frameForScore
            elementOfView.accessibilityTraits  = GameOverScene.accessibilityTraits()

            // 4.
            accessibleElements.append(elementOfView)

        }
    }
    
    
    
    
    
    
}
