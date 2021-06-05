//
//  CardListViewController.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

class CardListViewController: UIViewController {
    var presenter: ViewToPresenterCardProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension CardListViewController: PresenterToViewCardProtocol {
    func displayCards(list: [CardViewModel]) {
        
    }
    
    func openCard(at indexPath: IndexPath) {
        
    }
    
    func closeCards(at indexPaths: [IndexPath]) {
        
    }
    
    func remove(at indexPaths: [IndexPath]) {
        
    }

}
