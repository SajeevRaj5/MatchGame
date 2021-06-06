//
//  AlertController.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import Foundation
import UIKit

typealias TextValueClosure = (String?) -> Void

class AlertController {
  enum Alert {
    case startGame(defaultTime: Int)
    case timeOver(score: Int)
    case gameWon(score: Int, remainingTime: String)

    var title: String {
      switch self {
      case .startGame: return "Set a time and start game"
      case .timeOver: return "Game over"
      case .gameWon: return "You won the game"
      }
    }

    var message: String {
      switch self {
      case .startGame: return ""
      case .timeOver(let score): return "You scored \(score) points"
      case .gameWon(let score, let remainingTime):
        return "You scored \(score) points \n Remaining time : \(remainingTime)"
      }
    }

    var okButtonTitle: String {
      switch self {
      case .startGame: return "Start Game"
      case .timeOver, .gameWon: return "Start new game"
      }
    }
  }

  // show alert
  static func show(type: Alert, successHandler: TextValueClosure? = nil) {
    let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)

    switch type {
    case .startGame(let defaultTime):
      alertController.addTextField { textField in
        textField.placeholder = "\(defaultTime)" + " (in minutes)"
        textField.keyboardType = .numberPad
        textField.addDoneButtonOnKeyboard()
      }
    default: break
    }

    let okAction = UIAlertAction(title: type.okButtonTitle, style: .destructive) { (_) in
      if alertController.textFields?.count ?? 0 > 0 {
        successHandler?(alertController.textFields?[0].text)
      } else {
        successHandler?(nil)
      }
    }
    alertController.addAction(okAction)
    DispatchQueue.main.async {
      topMostViewController().present(alertController, animated: true, completion: nil)
    }
  }

  // Get top view controller
  class func topMostViewController() -> UIViewController {
    var topViewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    while (topViewController?.presentedViewController) != nil {
      topViewController = topViewController?.presentedViewController
    }
    return topViewController!
  }
}

extension UITextField {
  func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle       = UIBarStyle.default
    let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(UITextField.doneButtonAction))

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    inputAccessoryView = doneToolbar
  }

  @objc func doneButtonAction() {
    resignFirstResponder()
  }
}
