//
//  StoryboardExtension.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

extension UIStoryboard {
    enum StoryBoard: String {
        case main = "Main"
    }

    convenience init(type: StoryBoard) {
        self.init(name: type.rawValue, bundle: nil)
    }
}
