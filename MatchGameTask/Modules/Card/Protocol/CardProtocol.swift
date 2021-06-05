//
//  CardProtocol.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import Foundation

protocol PresenterToViewCardProtocol: AnyObject {
    func displayCards(list: [CardViewModel])
    func openCard(at indexPath: IndexPath)
    func closeCards(at indexPaths: [IndexPath])
    func remove(at indexPaths: [IndexPath])
}

protocol ViewToPresenterCardProtocol {
    var view: PresenterToViewCardProtocol? {get set}
    func getCards()
    func handleSelectionOfCard(at indexPath: IndexPath)
}

protocol PresenterToRouterCardProtocol {
    static func createModule() -> CardListViewController
}
