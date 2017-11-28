//
//  ErrorMessage.swift
//  CatPictures
//
//  Created by Alex Gordon on 29.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation
import UIKit

enum ErrorMessage {
    case unknownError()
    case custom(error: Error)
    
    public func show(on viewController: UIViewController,
                     canCancel: Bool,
                     recoveryActionTitle: String = "Try Again",
                     recoveryAction: (() -> ())? = nil) {
        
        let alert = UIAlertController(title: title(), message: message(), preferredStyle: .alert)
        
        let action = UIAlertAction(title: recoveryActionTitle, style: .default) {(action) in
            if let recoveryAction = recoveryAction {
                recoveryAction()
            }
        }
        alert.addAction(action)
        
        if canCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
        }
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

private extension ErrorMessage {
    private func title() -> String {
        switch self {
        case .custom(_):
            return "Error"
        case .unknownError():
            return "Oops..."
        }
    }
    
    private func message() -> String {
        switch self {
        case .custom(let error):
            return error.localizedDescription
        case .unknownError():
            return "We are sorry, an unknown error has happened. Please try again later or call support."
        }
    }
}

