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
    var isOpen: Bool = false
    var indexPath: IndexPath?
    let title: String
    
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
        
    }
}
