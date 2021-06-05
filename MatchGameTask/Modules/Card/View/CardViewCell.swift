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
        
        if card.isOpen {
            frontImageView.alpha = 1
            backImageView.alpha = 0
        }
        else {
            frontImageView.alpha = 0
            backImageView.alpha = 1
        }
    }
}
