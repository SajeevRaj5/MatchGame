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
        frontImageView.alpha = 0
        backImageView.alpha = 1
    }
    
    func open() {
        backImageView.alpha = 0
        frontImageView.alpha = 1
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
    }
    
    func close() {
        self.backImageView.alpha = 1
        self.frontImageView.alpha = 0
        UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
    }
    
    func remove() {
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
            
        }, completion: nil)
    }
}
