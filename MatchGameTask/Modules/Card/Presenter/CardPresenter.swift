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
    var score : Int = 0
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
    
    func getCards() {
        game.cards = CardService.getCards(pairCount: 8)
        let viewModels = game.cards.map{ CardViewModel(frontImageName: $0.frontImageName) }
        gameViewModel.cards = viewModels
        view?.displayCards(list: viewModels)
    }
    
    func handleSelectionOfCard(at index: Int) {
        guard game.cards[index].isRemoved == false else { return }
        let selectedCard = game.cards[index]
        
        // keep the card open
        view?.openCard(at: index)
        
        if firstSelectedCardIndex != nil {
            handleSecondCardSelection(selectedCard: selectedCard, index: index)
        }
        else {
            handleFirstCardSelection(selectedCard: selectedCard, index: index)
        }
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
        }
    }
}
