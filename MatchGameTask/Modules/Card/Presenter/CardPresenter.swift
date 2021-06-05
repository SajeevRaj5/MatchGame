//
//  CardPresenter.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

class CardViewModel {
    var frontImage: UIImage?
    var backImage: UIImage?
    var indexPath: IndexPath?
    let title: String
    var isOpen: Bool = false
    var isRemoved: Bool = false
    
    init(frontImageName: String) {
        frontImage = UIImage(named: frontImageName)
        backImage = UIImage(named: "backImage")
        self.title = frontImageName
    }
}

final class CardPresenter: ViewToPresenterCardProtocol {
    weak var view: PresenterToViewCardProtocol?
    var cardViewModels: [CardViewModel]?
    var firstSelectedCard: CardViewModel?
    
    func getCards() {
        let cards = CardService.getCards(pairCount: 8)
        let viewModels = cards.map{ CardViewModel(frontImageName: $0.frontImageName) }
        self.cardViewModels = viewModels
        view?.displayCards(list: viewModels)
    }
    
    func handleSelectionOfCard(at indexPath: IndexPath) {
        guard let allCards = cardViewModels else { return }
        let selectedCard = allCards[indexPath.row]
        
        if cardViewModels?[indexPath.row].isRemoved == true {
            return
        }
        
        // keep the card open
        view?.openCard(at: indexPath)
        
        if firstSelectedCard != nil {
            handleSecondCardSelection(selectedCard: selectedCard, indexPath: indexPath)
        }
        else {
            handleFirstCardSelection(selectedCard: selectedCard, indexPath: indexPath)
        }
    }
    
    func handleFirstCardSelection(selectedCard: CardViewModel, indexPath: IndexPath) {
        firstSelectedCard = selectedCard
        firstSelectedCard?.indexPath = indexPath
        
        cardViewModels?[indexPath.row].indexPath = indexPath
        cardViewModels?[indexPath.row].isOpen = true
    }
    
    func handleSecondCardSelection(selectedCard: CardViewModel, indexPath: IndexPath) {
        if firstSelectedCard?.title == selectedCard.title {
            removeCards(currentSelectedCardIndexPath: indexPath)
        }
        else {
            closeCards(currentSelectedCardIndexPath: indexPath)
        }
    }
    
    func removeCards(currentSelectedCardIndexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if let firstCardIndexPath = self.firstSelectedCard?.indexPath {
                self.view?.remove(at: [firstCardIndexPath,currentSelectedCardIndexPath])
                self.cardViewModels?[currentSelectedCardIndexPath.row].isRemoved = true
                self.firstSelectedCard?.isRemoved = true
                self.firstSelectedCard = nil
            }
        }
    }
    
    func closeCards(currentSelectedCardIndexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if let firstCardIndexPath = self.firstSelectedCard?.indexPath {
                self.view?.closeCards(at: [firstCardIndexPath, currentSelectedCardIndexPath])
                self.cardViewModels?[currentSelectedCardIndexPath.row].isOpen = false
                self.firstSelectedCard = nil
            }
        }
    }
}
