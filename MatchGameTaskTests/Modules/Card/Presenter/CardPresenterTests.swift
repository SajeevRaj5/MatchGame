//
//  CardPresenterTests.swift
//  MatchGameTaskTests
//
//  Created by Sajeev Raj on 6/6/21.
//

import XCTest

@testable import MatchGameTask

class CardPresenterTests: XCTestCase {
    var view: MockView!
    var presenter: CardPresenter!

    override func setUp() {
        view = MockView()
        presenter = CardPresenter()
        presenter.view = view
    }
    
    func testShowTimerSettingAlert() {
        presenter.configureGame()
        XCTAssert(view.didShowTimerSettingAlert, "Should show Time setting alert")
    }
    
    func testDisplayCards() {
        presenter.setupNewGame()
        XCTAssert(view.cards.count > 0, "Should have cards")
    }
    
    func testHandleSelectionOfCard() {
        presenter.game.cards = MockCardData.cards
        view.cards = MockCardData.cards.map{ CardViewModel(frontImageName: $0.frontImageName) }
        presenter.handleSelectionOfCard(at: 1)
        XCTAssert(view.didOpenCard, "Should Open Card")
    }
    
    func testStartGame() {
        presenter.setupNewGame()
        XCTAssert(view.score == 0, "Score should be 0 at start")
        XCTAssert(presenter.firstSelectedCardIndex == nil, "There should be not selection at game start")
        XCTAssert(view.cards.count > 0, "Should have cards")
    }
    
    func testRestartGame() {
        presenter.restartGame()
        XCTAssert(view.score == 0, "Score should be 0 after restart")
        XCTAssert(presenter.game.timeSeconds != 0, "Some end time should be present")
    }
    
    func testTimerUpdate() {
        presenter.endTime = Date().addingTimeInterval(3.0)
        presenter.setupNewGame()
        XCTAssert(view.didUpdateTimer, "Should update timer")
    }
    
    func testTimeOutAlertShowed() {
        presenter.endTime = Date()
        presenter.timerUpdate()
        XCTAssert(view.didShowedTimeOutAlert, "Should show timeout alert")
    }
    
    func testSavedSelectedTime() {
        presenter.startGameWith(time: 2)
        XCTAssert(UserDefaults.standard.value(forKey: "UserSelectedTimeOut") as? Int == 2, "Time should be saved locally")
    }
    
    func testHandleFirstCardSelection() {
        let index = 1
        presenter.startGameWith(time: 1)
        presenter.handleSelectionOfCard(at: index)
        XCTAssert(presenter.game.cards[index].isOpen, "Card should be opened")
        XCTAssert(view.didOpenCard, "Should Open Card")
    }
    
    func testRemoveCards() {
        let cards = MockCardData.cards
        presenter.game.cards = cards
        presenter.firstSelectedCardIndex = 0
        presenter.handleSelectionOfCard(at: 8)
        let mainQueueExpectation = expectation(description: "switch to main queue")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            XCTAssert(self.presenter.game.cards[0].isRemoved, "Card should be removed")
            XCTAssert(self.presenter.game.cards[8].isRemoved, "Card should be removed")
            XCTAssert(self.view.didRemoveCards, "Card should be removed")
            mainQueueExpectation.fulfill()
        }
        wait(for: [mainQueueExpectation], timeout: 5)

    }
    
    func testCloseCards() {
        let cards = MockCardData.cards
        presenter.game.cards = cards
        presenter.firstSelectedCardIndex = 0
        presenter.handleSelectionOfCard(at: 1)
        let mainQueueExpectation = expectation(description: "switch to main queue")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            XCTAssert(self.presenter.game.cards[0].isOpen == false, "Card should be closed")
            XCTAssert(self.presenter.game.cards[7].isOpen == false, "Card should be closed")
            XCTAssert(self.view.didCloseCards == true, "Card should be closed")
            mainQueueExpectation.fulfill()
        }
        wait(for: [mainQueueExpectation], timeout: 5)
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
    }
}

extension CardPresenterTests {
    class MockView: PresenterToViewCardProtocol {
        
        var didShowTimerSettingAlert = false
        var didOpenCard = false
        var didUpdateTimer = false
        var didShowedTimeOutAlert = false
        var didRemoveCards = false
        var didCloseCards = false
        
        var cards = [CardViewModel]()
        var score: Int?
        
        func displayCards(list: [CardViewModel]) {
            cards = list
        }
        
        func openCard(at index: Int) {
            didOpenCard = true
        }
        
        func closeCards(at indexes: [Int]) {
            didCloseCards = true
        }
        
        func remove(at indexes: [Int]) {
            didRemoveCards = true
        }
        
        func updateTimer(hour: Int, minute: Int, second: Int) {
            didUpdateTimer = true
        }
        
        func updateScore(to: Int) {
            self.score = to
        }
        
        func showTimeoutAlert(score: Int) {
            didShowedTimeOutAlert = true
        }
        
        func showTimerSettingAlert(defaultTime: Int) {
            didShowTimerSettingAlert = true
        }
        
        func showGameCompletionAlert(score: Int, remainingTime: (Int, Int, Int)) {
        }
    }
}
