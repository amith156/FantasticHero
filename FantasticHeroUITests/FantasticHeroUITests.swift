//
//  FantasticHeroUITests.swift
//  FantasticHeroUITests
//
//  Created by Amith Narayan on 16/05/2021.
//

import XCTest

class FantasticHeroUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }
    
    func test_player_acceablity() {
        let app = XCUIApplication()
        app.launch()
        
        let node = app.otherElements["playerTagTest"]
        XCTAssert(node.waitForExistence(timeout: 20))
        
    }
    
    func test_enemy_bullet_existence() {
        let app = XCUIApplication()
        app.launch()
        
        let node = app.otherElements["enemyBulletTagTest"]
        XCTAssert(node.waitForExistence(timeout: 20))
    }

    func test_score_existence() {
        let app = XCUIApplication()
        app.launch()
        
        let node = app.otherElements["ScoreTagTest"]
        XCTAssert(node.waitForExistence(timeout: 20))
    }
    
    func test_tap_to_start() {
        let app = XCUIApplication()
        app.launch()
        
        let node = app.otherElements["TapToStartTagTest"]
        node.tap()
        XCTAssert(node.waitForExistence(timeout: 20))
    }
    
    

}
