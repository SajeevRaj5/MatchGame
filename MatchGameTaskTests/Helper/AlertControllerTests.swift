//
//  AlertControllerTests.swift
//  MatchGameTaskTests
//
//  Created by Sajeev Raj on 6/6/21.
//

import XCTest

@testable import MatchGameTask

class AlertControllerTests: XCTestCase {
    override func setUpWithError() throws {
    }
    
    func testAlertTitle() {
        AlertController.show(type: .startGame(defaultTime: 1))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(AlertController.topMostViewController() is UIAlertController)
            XCTAssertEqual(AlertController.topMostViewController().title, "Set a time and start game")
        }
    }
    
    override func tearDownWithError() throws {
        
    }
}
