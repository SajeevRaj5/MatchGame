//
//  CardRouter.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import Foundation

final class CardRouter {
    
    // create Car List view
    static func createModule() -> CardListViewController {
        let view = CardListViewController.initialize(in: .main)
        var presenter: ViewToPresenterCardProtocol = CardPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
