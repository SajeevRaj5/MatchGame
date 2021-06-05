//
//  Card.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import Foundation

class Card {
    var title = ""
    var frontImageName = ""
    var isOpen = false
    var isRemoved = false

    convenience init(title: String) {
        self.init()
        frontImageName = title
        self.title = title
    }
}
