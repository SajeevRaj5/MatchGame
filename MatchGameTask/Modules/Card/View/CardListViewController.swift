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
        guard let currentCard = dataSource?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configureCell(card: currentCard)
        return cell
    }
}

extension CardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count: CGFloat = 4
        return CGSize(width: collectionView.frame.width/count - 2, height: collectionView.frame.width/count)
    }
}

extension CardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.handleSelectionOfCard(at: indexPath)
    }
}

extension CardListViewController: PresenterToViewCardProtocol {
    func displayCards(list: [CardViewModel]) {
        dataSource = list
    }
    
    func openCard(at indexPath: IndexPath) {
        let cardCell = cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell
        cardCell?.open()
    }
    
    func closeCards(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let cardCell = cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell
            cardCell?.flipDown()
        }
    }
    
    func remove(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let cardCell = cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell
            cardCell?.close()
        }
    }

}
