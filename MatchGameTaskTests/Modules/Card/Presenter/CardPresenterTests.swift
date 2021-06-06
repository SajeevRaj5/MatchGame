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
        XCTAssert(view.cards.count == CardService.getCards(pairCount: 8).count, "Should parse cards")
    }
    
    func testHandleSelectionOfCard() {
        presenter.game.cards = CardService.getCards(pairCount: 8)
        view.cards = CardService.getCards(pairCount: 8).map{ CardViewModel(frontImageName: $0.frontImageName) }
        presenter.handleSelectionOfCard(at: 1)
        XCTAssert(view.didOpenCard, "Should Open Card")
    }
    
    func testStartGame() {
        presenter.setupNewGame()
        XCTAssert(view.score == 0, "Score should be 0 at start")
        XCTAssert(presenter.firstSelectedCardIndex == nil, "There should be not selection at game start")
        XCTAssert(view.cards.count == CardService.getCards(pairCount: 8).count, "Should parse cards")
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
    }
    
    func testHandleSecondCardSelection() {
        let index = 2
        presenter.startGameWith(time: 1)
        presenter.firstSelectedCardIndex = 1
        presenter.handleSelectionOfCard(at: index)
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

        var cards = [CardViewModel]()
        var score: Int?
        
        func displayCards(list: [CardViewModel]) {
            cards = list
        }
        
        func openCard(at index: Int) {
            didOpenCard = true
        }
        
        func closeCards(at indexes: [Int]) {
            
        }
        
        func remove(at indexes: [Int]) {
            
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
    }
}
