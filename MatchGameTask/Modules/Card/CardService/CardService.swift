//
//  CardService.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import Foundation

class CardService {
    static func getCards(pairCount: Int) -> [Card] {
        var createdCards = [Card]()

        var count = 0
        while count < pairCount {
            count += 1
            let title = "Card\(count)"
            let cardOne = Card(title: title)
            let cardTwo = Card(title: title)
            createdCards += [cardOne, cardTwo]
        }

        createdCards.shuffle()
        return createdCards
    }
}
