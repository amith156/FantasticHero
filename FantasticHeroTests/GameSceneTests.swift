//
//  GameSceneTests.swift
//  FantasticHeroTests
//
//  Created by Amith Narayan on 16/05/2021.
//
@testable import FantasticHero
import XCTest

class GameSceneTests: XCTestCase {

    var gameSceneT : GameScene!
    
    override func setUp() {
        super.setUp()
        gameSceneT = GameScene(size: CGSize(width: 1536, height: 2048))
    }
    
    override func tearDown() {
        gameSceneT = nil
        super.tearDown()
    }
    
    func test_explosion_on_contact() throws {
        
    }
    
}
