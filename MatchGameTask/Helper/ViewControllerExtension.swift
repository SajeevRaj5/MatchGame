//
//  ViewControllerExtension.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

extension UIViewController {
    
    // create view controller from storyboard
    class func initialize(in storyBoard: UIStoryboard.StoryBoard, identifier: String? = nil) -> Self {
        let storyBoard = UIStoryboard(type: storyBoard)
        let viewControllerIdentifier = identifier ?? Self.identifier
        return  storyBoard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! Self
    }
}
