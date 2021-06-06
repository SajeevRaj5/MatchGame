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
    
    func startGameWith(time: Int) {
        saveSelectedTime(time: time)
        game.timeSeconds = time * 60
        setupNewGame()
    }

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

    private func startGame(cards: [Card]) {
        game.score = 0
        firstSelectedCardIndex = nil
        setEndTime()
        view?.displayCards(list: getCardsViewModel(cards: cards))
        view?.updateScore(to: game.score)
        timerUpdate()
    }
    
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

    @objc func timerUpdate() {
        let time = Date().getTimeDiff(to: endTime)
        view?.updateTimer(hour: time.hour, minute: time.minute, second: time.second)
        if time.hour == 0 && time.minute == 0 && time.second == 0 {
            handleTimeOut()
        }
    }
    
    private func handleTimeOut() {
        gameTimer?.invalidate()
        view?.showTimeoutAlert(score: game.score)
    }
    
    // MARK: - Cards

    private func getCardsViewModel(cards: [Card]) -> [CardViewModel] {
       game.cards.map { CardViewModel(frontImageName: $0.frontImageName) }
    }

    private func handleFirstCardSelection(selectedCard: Card, index: Int) {
        firstSelectedCardIndex = index
        game.cards[index].isOpen = true
    }

    private func handleSecondCardSelection(selectedCard: Card, index: Int) {
        guard let firstSelectedCardIndex = firstSelectedCardIndex else { return }
        if game.cards[firstSelectedCardIndex].title == selectedCard.title {
            removeCards(currentSelectedCardIndex: index)

        } else {
            closeCards(currentSelectedCardIndex: index)
        }
    }

    private func removeCards(currentSelectedCardIndex: Int) {
        game.score = computeScore(isSuccess: true, at: game.score)
        view?.updateScore(to: game.score)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            guard let firstSelectedCardIndex = self.firstSelectedCardIndex else { return }
            self.view?.remove(at: [firstSelectedCardIndex, currentSelectedCardIndex])
            self.game.cards[currentSelectedCardIndex].isRemoved = true
            self.game.cards[firstSelectedCardIndex].isRemoved = true
            self.firstSelectedCardIndex = nil
            self.matchedCardsCounter += 1
            
            self.checkGameCompletion(cardCounter: self.matchedCardsCounter)
        }
    }
    
    private func checkGameCompletion(cardCounter: Int) {
        guard cardCounter == pairCount else { return }
        let time = Date().getTimeDiff(to: endTime)
        view?.showGameCompletionAlert(score: game.score, remainingTime: time)
        gameTimer?.invalidate()
    }

    private func closeCards(currentSelectedCardIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            guard let firstCardIndexPath = self.firstSelectedCardIndex else { return }
            self.view?.closeCards(at: [firstCardIndexPath, currentSelectedCardIndex])
            self.game.cards[currentSelectedCardIndex].isOpen = false
            self.game.cards[firstCardIndexPath].isOpen = false
            self.firstSelectedCardIndex = nil

            self.game.score = self.computeScore(isSuccess: false, at: self.game.score)
            self.view?.updateScore(to: self.game.score)
        }
    }

// MARK: - Score

    private func computeScore(isSuccess: Bool, at currentScore: Int) -> Int {
        let computedScore = isSuccess ? currentScore + 5 :  currentScore - 2
        return max(0, computedScore)
    }
}
