//
//  AlertPresentable.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 17/01/2021.
//

import UIKit

protocol AlertPresentable {
  /// Present alerte.
  /// - Parameter message: Choose message.
  func showError(message: String)
}

extension AlertPresentable where Self: UIViewController {
  func showError(message: String) {
    let alertVC = UIAlertController(title: "Erreur!",
                                    message: message,
                                    preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }
}
