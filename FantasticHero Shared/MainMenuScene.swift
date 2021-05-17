//
//  MainMenuScene.swift
//  FantasticHero iOS
//
//  Created by Amith Narayan on 14/05/2021.
//

import Foundation
import SpriteKit

var femailHero  = false

class MainMenuScene : SKScene {
    
    let heroA = SKSpriteNode(imageNamed: "AHero")
    let heroB = SKSpriteNode(imageNamed: "BHero")
    let heroC = SKSpriteNode(imageNamed: "CHero")
    let heroD = SKSpriteNode(imageNamed: "DHero")
    let checkmarkNode = SKSpriteNode(imageNamed: "checked")
    let heroALable = SKLabelNode(fontNamed: "Lora-Regular")
    let heroBLable = SKLabelNode(fontNamed: "Lora-Regular")
    let heroCLable = SKLabelNode(fontNamed: "Lora-Regular")
    let heroDLable = SKLabelNode(fontNamed: "Lora-Regular")
    
    let startGame = SKLabelNode(fontNamed: "ReggaeOne-Regular")
    
    var accessibleElements: [UIAccessibilityElement] = []
    
    override func didMove(to view: SKView) {
        
        isAccessibilityElement       = false
        startGame.isAccessibilityElement = true
        heroC.isAccessibilityElement = true
        checkmarkNode.isAccessibilityElement = true
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameName = SKLabelNode(fontNamed: "ReggaeOne-Regular")
        gameName.text = "Fantastic Hero"
        gameName.fontSize = 150
        gameName.fontColor = SKColor.white
        gameName.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameName.zPosition = 1
        self.addChild(gameName)
        
        let subTitle = SKLabelNode(fontNamed: "ReggaeOne-Regular")
        subTitle.text = "The ultimate adventure game"
        subTitle.fontSize = 50
        subTitle.fontColor = SKColor.white
        subTitle.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.72)
        subTitle.zPosition = 1
        self.addChild(subTitle)
        
        let selectTextNode = SKLabelNode(fontNamed: "ReggaeOne-Regular")
        selectTextNode.text = "Please Select Your Hero"
        selectTextNode.fontSize = 75
        selectTextNode.fontColor = SKColor.white
        selectTextNode.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.6)
        selectTextNode.zPosition = 1
        self.addChild(selectTextNode)
        
        
        heroA.setScale(2)
        heroA.zPosition = 1
        heroA.name = "heroA"
        heroA.position = CGPoint(x: self.size.width*0.20, y: self.size.height*0.4)
        self.addChild(heroA)

        heroALable.text = "Amith"
        heroALable.name = "heroALable"
        heroALable.fontSize = 50
        heroALable.fontColor = SKColor.white
        heroALable.zPosition = 1
        heroALable.position = CGPoint(x: self.size.width*0.20, y: self.size.height*0.47)
        self.addChild(heroALable)



        heroB.setScale(2)
        heroB.zPosition = 1
        heroB.name = "heroB"
        heroB.position = CGPoint(x: self.size.width*0.40, y: self.size.height*0.4)
        self.addChild(heroB)

        heroBLable.text = "Martin"
        heroBLable.name = "heroBLable"
        heroBLable.fontSize = 50
        heroBLable.fontColor = SKColor.white
        heroBLable.zPosition = 1
        heroBLable.position = CGPoint(x: self.size.width*0.40, y: self.size.height*0.47)
        self.addChild(heroBLable)



        heroC.setScale(2)
        heroC.zPosition = 1
        heroC.name = "heroC"
        heroC.position = CGPoint(x: self.size.width*0.60, y: self.size.height*0.4)
        self.addChild(heroC)

        heroCLable.text = "Sky"
        heroCLable.name = "heroCLable"
        heroCLable.fontSize = 50
        heroCLable.fontColor = SKColor.white
        heroCLable.zPosition = 1
        heroCLable.position = CGPoint(x: self.size.width*0.60, y: self.size.height*0.47)
        self.addChild(heroCLable)



        heroD.setScale(2)
        heroD.zPosition = 1
        heroD.name = "heroD"
        heroD.position = CGPoint(x: self.size.width*0.80, y: self.size.height*0.4)
        self.addChild(heroD)

        heroDLable.text = "Sam"
        heroDLable.name = "heroDLable"
        heroDLable.fontSize = 50
        heroDLable.fontColor = SKColor.white
        heroDLable.zPosition = 1
        heroDLable.position = CGPoint(x: self.size.width*0.80, y: self.size.height*0.47)
        self.addChild(heroDLable)
        
        
        startGame.text = "Start Game"
        startGame.fontSize = 60
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        startGame.zPosition = 10
        startGame.name = "startButton"
        self.addChild(startGame)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let pointOfNode = atPoint(pointOfTouch)
            
            if(pointOfNode.name == "startButton") {
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.scaleMode = self.scaleMode
                let myTransion = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMove, transition: myTransion)
            }
            
            if(pointOfNode.name == "heroA") {
                femailHero = false
                checkFunction(checkMarkPosition: heroA.position, heroSize: heroA.size)
            }
            else if(pointOfNode.name == "heroB") {
                femailHero = false
                checkFunction(checkMarkPosition: heroB.position, heroSize: heroB.size)
            }
            else if(pointOfNode.name == "heroC") {
                femailHero = true
                checkFunction(checkMarkPosition: heroC.position, heroSize: heroC.size)
            }
            else if(pointOfNode.name == "heroD") {
                femailHero = false
                checkFunction(checkMarkPosition: heroD.position, heroSize: heroD.size)
            }
            
        }
        
        
    }
    
    
}
extension MainMenuScene {
    
    
    func checkFunction(checkMarkPosition : CGPoint, heroSize : CGSize) {
//        checkmarkNode.position = checkMarkPosition
        checkmarkNode.removeFromParent()
        checkmarkNode.position = CGPoint(x: checkMarkPosition.x, y: checkMarkPosition.y - ((heroSize.height/2) + checkmarkNode.frame.height))
        checkmarkNode.zPosition = 3
        checkmarkNode.setScale(0)
        self.addChild(checkmarkNode)
        let scaleIn = SKAction.scale(to: 2, duration: 0.25)
        checkmarkNode.run(scaleIn)
        
    }
    
    
}

extension MainMenuScene {
    
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
            let elementForTapMe   = UIAccessibilityElement(accessibilityContainer: self.view!)

            // 2.
            var frameForStartGame = startGame.frame
            var frameForFemaleHero = heroC.frame
            var frameForCheckMark = checkmarkNode.frame

            // From Scene to View
            frameForStartGame.origin = (view?.convert(frameForStartGame.origin, from: self))!
            frameForFemaleHero.origin = (view?.convert(frameForFemaleHero.origin, from: self))!
            frameForCheckMark.origin = (view?.convert(frameForCheckMark.origin, from: self))!

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


            frameForStartGame.origin.y = frameForStartGame.origin.y - frameForStartGame.size.height
            frameForFemaleHero.origin.y = frameForFemaleHero.origin.y - frameForFemaleHero.size.height
            frameForCheckMark.origin.y = frameForCheckMark.origin.y - frameForCheckMark.size.height

            // 3.
            elementForTapMe.accessibilityLabel   = "TapToStartMainTagTest"
            elementForTapMe.accessibilityFrame   = frameForStartGame
            elementForTapMe.accessibilityTraits  = SKSpriteNode.accessibilityTraits()
            // 4.
            accessibleElements.append(elementForTapMe)
            
            elementForTapMe.accessibilityLabel   = "TapToSuperHeroTagTest"
            elementForTapMe.accessibilityFrame   = frameForFemaleHero
            elementForTapMe.accessibilityTraits  = SKSpriteNode.accessibilityTraits()
            
            // 4.
            accessibleElements.append(elementForTapMe)

            
            //checkMark
//            elementForTapMe.accessibilityLabel   = "checkMarkTagTest"
//            elementForTapMe.accessibilityFrame   = frameForCheckMark
//            elementForTapMe.accessibilityTraits  = SKSpriteNode.accessibilityTraits()
//
//            // 4.
//            accessibleElements.append(elementForTapMe)
            
            
        }
    }

    
}
