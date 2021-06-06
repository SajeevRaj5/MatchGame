//
//  CardViewCell.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

class CardViewCell: UICollectionViewCell {

    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!

    func configureCell(card: CardViewModel) {
        frontImageView.image = card.frontImage
        backImageView.image = card.backImage
        self.backImageView.alpha = 1
        self.frontImageView.alpha = 0
        close(duration: 0)
    }

    // open card
    func open(duration: TimeInterval = 0.3) {
        backImageView.alpha = 0
        frontImageView.alpha = 1
        UIView.transition(from: backImageView, to: frontImageView, duration: duration, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
    }

    // close/ flip down card as match was not found
    func close(duration: TimeInterval = 0.3) {
        self.backImageView.alpha = 1
        self.frontImageView.alpha = 0
        UIView.transition(from: self.frontImageView, to: self.backImageView, duration: duration, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
    }

    // remove card as match was founc
    func remove() {
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0

        }, completion: nil)
    }
}
