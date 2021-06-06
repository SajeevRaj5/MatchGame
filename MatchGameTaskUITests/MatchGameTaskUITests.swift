//
//  MatchGameTaskUITests.swift
//  MatchGameTaskUITests
//
//  Created by Sajeev Raj on 05/06/2021.
//

import XCTest

class MatchGameTaskUITests: XCTestCase {
    let app = XCUIApplication()
    var alertPressed = false

    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    func testInitialAlertTitle() {
        XCTAssert(app.alerts.element.staticTexts["Set a time and start game"].exists)
    }
    
    func testAlertButtonClick() {
        addUIInterruptionMonitor(withDescription: "Set a time and start game") {
                (alert) -> Bool in
                alert.buttons["Start Game"].tap()
            self.alertPressed = true
                return true
            }
        app.tap()
            let collectionView = self.app.collectionViews
        XCTAssert(collectionView.cells.count > 0, "Collection view should be present")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
