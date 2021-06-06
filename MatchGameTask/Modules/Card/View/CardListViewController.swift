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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupNewGame()
    }

    @IBAction func restartButtonAction(sender: UIButton) {
        presenter?.restartGame()
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
        presenter?.handleSelectionOfCard(at: indexPath.row)
    }
}

extension CardListViewController: PresenterToViewCardProtocol {
    func showTimeoutAlert(score: Int) {
        AlertController.show(type: .timeOver(score: score)) { [weak self] _ in
            self?.presenter?.setupNewGame()
        }
    }
    
    func updateTimer(hour: Int, minute: Int, second: Int) {
        var timeString = "\(format(minute)):\(format(second))"
        if hour != 0 { timeString = "\(format(hour))" + timeString }
        timerLabel.text = "\(timeString)"
    }

    func format(_ time: Int) -> String {
        String(format: "%02ld", time)
    }

    func updateScore(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    func displayCards(list: [CardViewModel]) {
        dataSource = list
    }

    func openCard(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let cardCell = cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell
        cardCell?.open()
    }

    func closeCards(at indexes: [Int]) {
        indexes.forEach { (index) in
            let indexPath = IndexPath(row: index, section: 0)
            let cardCell = cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell
            cardCell?.close()
        }
    }

    func remove(at indexes: [Int]) {
        indexes.forEach { (index) in
            let indexPath = IndexPath(row: index, section: 0)
            let cardCell = cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell
            cardCell?.remove()
        }
    }
}
