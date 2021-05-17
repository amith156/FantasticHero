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
    
    func test_tap_to_start_main() {
        let app = XCUIApplication()
        app.launch()
        
        let node = app.otherElements["TapToStartMainTagTest"]
        node.tap()
        
        XCTAssert(node.waitForExistence(timeout: 20))
    }
    
    func test_tap_femail_super_hero() {
        let app = XCUIApplication()
        app.launch()
        
        let node = app.otherElements["TapToSuperHeroTagTest"]
//        let node2 = app.otherElements["checkMarkTagTest"]
        node.tap()
        
        XCTAssert(node.waitForExistence(timeout: 20))
//        XCTAssert(node2.waitForExistence(timeout: 30))
    }

    

}
