//
//  ContrtollerExt.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/29/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: UIViewControllerPresenting {
    
    static var className: String {
        return String(describing: self)
    }
    
    func presentAlertController(withTitle title: String? = nil,
                                message: String? = nil,
                                textField: (placeholder: String?, keyboardType: UIKeyboardType)?,
                                actions: (title: String, style: UIAlertAction.Style, handler: ((_ text: String?) -> Void)?)...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let textField = textField {
            alertController.addTextField {
                $0.placeholder = textField.placeholder
                $0.keyboardType = textField.keyboardType
            }
        }
        
        for action in actions {
            alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                action.handler?(alertController.textFields?.first?.text)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertSheet(withTitle title: String? = nil,
                           message: String? = nil,
                           textField: (placeholder: String?, keyboardType: UIKeyboardType)?,
                           actions: (title: String, style: UIAlertAction.Style, handler: ((_ text: String?) -> Void)?)...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        if let textField = textField {
            alertController.addTextField {
                $0.placeholder = textField.placeholder
                $0.keyboardType = textField.keyboardType
            }
        }
        
        for action in actions {
            alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                action.handler?(alertController.textFields?.first?.text)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
}

protocol UIViewControllerPresenting {}

extension UIViewControllerPresenting where Self: UIViewController {
    
    static func instantiate(from storyboardName: String, withIdentifier identifier: String = className) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}


protocol BlackAlphaBackGround { }

extension BlackAlphaBackGround where Self: UIViewController {
    
    static func createBlackBackground(controller: UIViewController, view: UIView) {
        view.frame = CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.view.addSubview(view)
    }
    
    static func removeBlack(view: UIView) {
        view.removeFromSuperview()
    }
}

