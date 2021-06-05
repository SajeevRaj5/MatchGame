//
//  CardListViewController.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

class CardListViewController: UIViewController {
    var presenter: ViewToPresenterCardProtocol?
    
    var dataSource: [CardViewModel]? {
        didSet {
            cardsCollectionView?.reloadData()
        }
    }
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.getCards()
    }

}

extension CardListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath) as! CardViewCell
        return cell
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
