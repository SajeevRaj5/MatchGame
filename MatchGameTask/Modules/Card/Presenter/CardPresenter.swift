//
//  CardPresenter.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

struct GameViewModel {
    var cards: [CardViewModel]?
    var gameTime: Double = 60
    var score = 0
}

struct CardViewModel {
    var frontImage: UIImage?
    var backImage: UIImage?

    init(frontImageName: String) {
        frontImage = UIImage(named: frontImageName)
        backImage = UIImage(named: "backImage")
    }
}

final class CardPresenter: ViewToPresenterCardProtocol {

    weak var view: PresenterToViewCardProtocol?
    var gameViewModel = GameViewModel()
    var game = Game()
    var firstSelectedCardIndex: Int?
    var gameTimer: Timer?
    var endTime = Date()
    
    private let pairCount = 8
    private var matchedCardsCounter = 0
    
    // configure game when started for first time
    func configureGame() {
        let selectedTime = UserDefaults.standard.value(forKey: "UserSelectedTimeOut")
        if let selectedTimeValue = selectedTime as? Int {
            view?.showTimerSettingAlert(defaultTime: selectedTimeValue)
        }
        else {
            view?.showTimerSettingAlert(defaultTime: 1)
        }
    }
    
    // start new game with shuffled cards
    func setupNewGame() {
        game.cards = CardService.getCards(pairCount: pairCount)
        startGame(cards: game.cards)
        setUpTimer()
    }
    
    // start game with selected timeout
    func startGameWith(time: Int) {
        saveSelectedTime(time: time)
        game.timeSeconds = time * 60
        setupNewGame()
    }

    // handle selection of card when clicked
    func handleSelectionOfCard(at index: Int) {
        guard game.cards[index].isRemoved == false,
              index != firstSelectedCardIndex else { return }
        let selectedCard = game.cards[index]

        // keep the card open
        view?.openCard(at: index)

        if firstSelectedCardIndex != nil {
            handleSecondCardSelection(selectedCard: selectedCard, index: index)

        } else {
            handleFirstCardSelection(selectedCard: selectedCard, index: index)
        }
    }
    
    // restart game with previous set of cards, without shuffling
    func restartGame() {
        startGame(cards: game.cards)
    }

    // start game with provided card set
    private func startGame(cards: [Card]) {
        game.score = 0
        firstSelectedCardIndex = nil
        setEndTime()
        view?.displayCards(list: getCardsViewModel(cards: cards))
        view?.updateScore(to: game.score)
        timerUpdate()
    }
    
    // save set time when game starts
    private func saveSelectedTime(time: Int) {
        UserDefaults.standard.setValue(time, forKey: "UserSelectedTimeOut")
    }

    deinit {
        gameTimer?.invalidate()
    }
}

extension CardPresenter {

    // MARK: - Game Time
    private func setEndTime() {
        endTime = Date().addingTimeInterval(TimeInterval(game.timeSeconds))
    }

    private func setUpTimer() {
        // set and start timer
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        gameTimer?.fire()
    }

    // update timer
    @objc func timerUpdate() {
        let time = Date().getTimeDiff(to: endTime)
        view?.updateTimer(hour: time.hour, minute: time.minute, second: time.second)
        if time.hour == 0 && time.minute == 0 && time.second == 0 {
            handleTimeOut()
        }
    }
    
    // invalidate timer and show alert when timout happens
    private func handleTimeOut() {
        gameTimer?.invalidate()
        view?.showTimeoutAlert(score: game.score)
    }
    
    // MARK: - Cards

    private func getCardsViewModel(cards: [Card]) -> [CardViewModel] {
       game.cards.map { CardViewModel(frontImageName: $0.frontImageName) }
    }

    // handle selection of card one
    private func handleFirstCardSelection(selectedCard: Card, index: Int) {
        firstSelectedCardIndex = index
        game.cards[index].isOpen = true
    }

    // handle selection of card two
    private func handleSecondCardSelection(selectedCard: Card, index: Int) {
        guard let firstSelectedCardIndex = firstSelectedCardIndex else { return }
        if game.cards[firstSelectedCardIndex].title == selectedCard.title {
            removeCards(currentSelectedCardIndex: index)

        } else {
            closeCards(currentSelectedCardIndex: index)
        }
    }

    // remove cards as match was found
    private func removeCards(currentSelectedCardIndex: Int) {
        game.score = computeScore(isSuccess: true, at: game.score)
        view?.updateScore(to: game.score)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                guard let welf = self,
                  let firstSelectedCardIndex = welf.firstSelectedCardIndex else { return }
            welf.view?.remove(at: [firstSelectedCardIndex, currentSelectedCardIndex])
            welf.game.cards[currentSelectedCardIndex].isRemoved = true
            welf.game.cards[firstSelectedCardIndex].isRemoved = true
            welf.firstSelectedCardIndex = nil
            welf.matchedCardsCounter += 1
            
            welf.checkGameCompletion(cardCounter: welf.matchedCardsCounter)
        }
    }
    
    // check if all matches are found and show alert accordingly
    private func checkGameCompletion(cardCounter: Int) {
        guard cardCounter == pairCount else { return }
        let time = Date().getTimeDiff(to: endTime)
        view?.showGameCompletionAlert(score: game.score, remainingTime: time)
        gameTimer?.invalidate()
    }

    // close cards as match was not found
    private func closeCards(currentSelectedCardIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            guard let welf = self,
                  let firstCardIndexPath = welf.firstSelectedCardIndex else { return }
            welf.view?.closeCards(at: [firstCardIndexPath, currentSelectedCardIndex])
            welf.game.cards[currentSelectedCardIndex].isOpen = false
            welf.game.cards[firstCardIndexPath].isOpen = false
            welf.firstSelectedCardIndex = nil

            welf.game.score = welf.computeScore(isSuccess: false, at: welf.game.score)
            welf.view?.updateScore(to: welf.game.score)
        }
    }

// MARK: - Score

    private func computeScore(isSuccess: Bool, at currentScore: Int) -> Int {
        let computedScore = isSuccess ? currentScore + 5 :  currentScore - 2
        return max(0, computedScore)
    }
}
