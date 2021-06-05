//
//  CardProtocol.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import Foundation

protocol PresenterToViewCardProtocol: AnyObject {
    func displayCards(list: [CardViewModel])
    func openCard(at index: Int)
    func closeCards(at indexes: [Int])
    func remove(at indexes: [Int])
    func updateTimer(hour: Int, minute: Int, second: Int)
    func updateScore(to: Int)
}

protocol ViewToPresenterCardProtocol {
    var view: PresenterToViewCardProtocol? {get set}
    func setup()
    func handleSelectionOfCard(at index: Int)
    func restartGame()
}

protocol PresenterToRouterCardProtocol {
    static func createModule() -> CardListViewController
}
