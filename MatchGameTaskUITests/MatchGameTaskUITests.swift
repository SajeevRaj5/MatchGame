//
//  MatchGameTaskUITests.swift
//  MatchGameTaskUITests
//
//  Created by Sajeev Raj on 05/06/2021.
//

import XCTest

class MatchGameTaskUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }

    func testInitialAlertTitle() {
        XCTAssert(app.alerts.element.staticTexts["Set a time and start game"].exists)
    }
    
    func testAlertButtonClick() {
        navigateToGame()
        let collectionView = self.app.collectionViews
        XCTAssert(collectionView.cells.count > 0, "Collection view should be present")
        assertNewGame()
    }
    
    func testCardFirstCardOpen() {
        navigateToGame()
        openCard(index: 0)
        XCTAssertEqual(openCards.count, 1)
    }
    
    func testOpenTwoCards() {
        navigateToGame()
        openCard(index: 0)
        openCard(index: 1)
        XCTAssert(openCards.count == 0)
    }
    
    func testRestartGame() {
        navigateToGame()
        openCard(index: 0)
        app.buttons["RestartGame"].tap()
        assertNewGame()
    }
}

private extension MatchGameTaskUITests {
    
    func navigateToGame() {
        let time = "1"
        addUIInterruptionMonitor(withDescription: "Set a time and start game") {
            (alert) -> Bool in
            return true
        }
        self.typeTime(time: time)
        app.alerts.buttons["Start Game"].tap()
        app.tap()
    }
    
    func typeTime(time: String) {
        let textField = app.textFields["DefaultTimeTextField"]
        textField.tap()
        textField.typeText(time)
    }
    
    func assertNewGame() {
        let cells = app.collectionViews.cells
        
        //check all cels have same backgroung image
        let backImages = cells.images.matching(identifier: "BackImageView").allElementsBoundByIndex
        let backImageName = backImages.first?.label
        let sameImages =  backImages.filter{$0.label == backImageName }
        XCTAssertEqual(sameImages.count, backImages.count)
        
        let scoreLabel = app.staticTexts["ScoreLabel"]
        print(scoreLabel.label)
        XCTAssertEqual("Score: 0", scoreLabel.label)
        
        let timerLabel = app.staticTexts["TimerLabel"]
        XCTAssertEqual("00:59", timerLabel.label)
    }
    
    func openCard(index: Int) {
        app.cells.firstMatch.tap()
        let cells = app.cells.allElementsBoundByIndex
        cells[index].tap()
    }
    
    var openCards: XCUIElementQuery {
        app.cells.images.matching(identifier: "FrontImageView")
    }
    
    var removedCards: [XCUIElement] {
        let cells = app.cells.allElementsBoundByIndex
        let removedCells = cells.filter{!$0.images["FrontImageView"].exists && !$0.images["BackImageView"].exists }
        return removedCells
    }
}
