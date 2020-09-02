//
//  MessageView.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/30.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class MessageView {
    
    class func showMessage(title:String, message:String, viewController:UIViewController, actions:Array<(String, (() -> Void))>? = nil) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
            
            let attributedTitle = NSAttributedString(string: title, attributes: [ .foregroundColor : UIColor.primary ])
            let attributedMessage = NSAttributedString(string: "\n" + message, attributes: [ .foregroundColor : UIColor.gray ])
            
            alertViewController.setValuesForKeys(["attributedTitle" : attributedTitle, "attributedMessage" : attributedMessage])
            
            if let theActions = actions {
                for anAction in theActions {
                    let action = UIAlertAction(title: anAction.0, style: .default) { alertAction in
                        anAction.1()
                    }
                    
                    alertViewController.addAction(action)
                }
            } else {
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertViewController.addAction(dismissAction)
            }
        
            alertViewController.view.tintColor = .primary
            viewController.present(alertViewController, animated: true)
        }
    }
    
}
