//
//  CardPresenter.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

struct GameViewModel {
    var cards: [CardViewModel]?
    var gameTime : Double = 60
    var score = 0
}

struct CardViewModel {
    var frontImage: UIImage?
    var backImage: UIImage?
    var indexPath: IndexPath?
    
    init(frontImageName: String) {
        frontImage = UIImage(named: frontImageName)
        backImage = UIImage(named: "backImage")
    }
}

class Game {
    var cards = [Card]()
    var backImageName = ""
    var score = 0
    var timeSeconds = 60
}

final class CardPresenter: ViewToPresenterCardProtocol {
    
    weak var view: PresenterToViewCardProtocol?
    var gameViewModel = GameViewModel()
    var game = Game()
    var firstSelectedCardIndex: Int?
    var gameTimer = Timer()
    var endTime = Date()
    func setup() {
        getCards()
        setUpTimer()
        computeEndTime()
        self.view?.updateScore(to: self.game.score)
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
    
    func restartGame() {
        game.score = 0
        computeEndTime()
        view?.displayCards(list: getCardsViewModel(cards: game.cards))
        view?.updateScore(to: game.score)
        timerUpdate()
    }
    
    deinit {
        gameTimer.invalidate()
    }
}


extension CardPresenter {
    
    // MARK: - Game Time
    func computeEndTime() {
        endTime = Date().addingTimeInterval(TimeInterval(game.timeSeconds))
    }
    
    func setUpTimer() {
        // set and start timer
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    @objc func timerUpdate() {
        let time = Date().getTimeDiff(to : endTime)
        if time.hour > 0 && time.minute > 0 && time.second > 0 {
            view?.updateTimer(hour: time.hour, minute:time.minute,second:time.second)
        }
        else {
            
        }
    }
    
    // MARK: - Cards

    func getCards() {
        game.cards = CardService.getCards(pairCount: 8)
        let viewModels = getCardsViewModel(cards: game.cards)
        gameViewModel.cards = viewModels
        view?.displayCards(list: viewModels)
    }
    
    func getCardsViewModel(cards: [Card]) -> [CardViewModel] {
       game.cards.map{ CardViewModel(frontImageName: $0.frontImageName) }
    }
        
    func handleFirstCardSelection(selectedCard: Card, index: Int) {
        firstSelectedCardIndex = index
        game.cards[index].isOpen = true
    }
    
    func handleSecondCardSelection(selectedCard: Card, index: Int) {
        guard let firstSelectedCardIndex = firstSelectedCardIndex else { return }
        if game.cards[firstSelectedCardIndex].title == selectedCard.title {
            removeCards(currentSelectedCardIndex: index)
        
        } else {
            closeCards(currentSelectedCardIndex: index)
        }
    }
    
    func removeCards(currentSelectedCardIndex: Int) {
        game.score = computeScore(isSuccess: true, at: game.score)
        view?.updateScore(to: game.score)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            guard let firstSelectedCardIndex = self.firstSelectedCardIndex else { return }
            self.view?.remove(at: [firstSelectedCardIndex,currentSelectedCardIndex])
            self.game.cards[currentSelectedCardIndex].isRemoved = true
            self.game.cards[firstSelectedCardIndex].isRemoved = true
            self.firstSelectedCardIndex = nil
            
        }
    }
    
    func closeCards(currentSelectedCardIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            guard let firstCardIndexPath = self.firstSelectedCardIndex else { return }
            self.view?.closeCards(at: [firstCardIndexPath, currentSelectedCardIndex])
            self.game.cards[currentSelectedCardIndex].isOpen = false
            self.firstSelectedCardIndex = nil
            
            self.game.score = self.computeScore(isSuccess: false, at: self.game.score)
            self.view?.updateScore(to: self.game.score)
        }
    }
    
// MARK: - Score
    
    func computeScore(isSuccess: Bool, at currentScore: Int) -> Int {
        let computedScore = isSuccess ? currentScore + 5 :  currentScore - 2
        return max(0,computedScore)
    }
}
