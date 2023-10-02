//
//  UIViewContollerExtensions.swift
//  Test1
//
//  Created by mac on 9/12/19.
//  Copyright © 2019 iMech. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar

extension UIViewController {
    
    func showAlertPopUp(title: String, message: String, buttonTitle1: String = "Ok".localize_, buttonTitle2: String = "Cancel".localize_, buttonTitle1Style: UIAlertAction.Style = .default, buttonTitle2Style: UIAlertAction.Style = .default, action1 buttonTitle1Action: @escaping (() -> Void), action2 buttonTitle2Action: @escaping (()->Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let button1 = UIAlertAction.init(title: buttonTitle1, style: buttonTitle1Style) { (action) in
            print("\(buttonTitle1) Button")
            buttonTitle1Action()
        }
        let button2 = UIAlertAction.init(title: buttonTitle2, style: buttonTitle2Style) { (action) in
            print("\(buttonTitle2) Button")
            buttonTitle2Action()
        }
        alert.addAction(button1)
        alert.addAction(button2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertError(title: String = "Error".localize_, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction.init(title: "Close".localize_, style: .default) { (action) in

        }
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }

    func showSnackbar(message: String, buttonTitle1: String = "Ok".localize_, buttonTitle2: String = "Close".localize_, showButtonOne: Bool = false, showButtonTwo: Bool = false, isError: Bool = false, action1 buttonOneAction: @escaping (() -> Void), buttonTwoAction: @escaping (() -> Void), backgroundColor: String = "#008800") {
        
        let snackbar = TTGSnackbar(message: message, duration: .middle)
        
        snackbar.backgroundColor = isError ? .red : UIColor.hexColor(hex: backgroundColor)
        
        if showButtonOne {
            // Action 1
            snackbar.actionText = buttonTitle1
    //        snackbar.actionTextColor = UIColor.green
            snackbar.actionBlock = { (snackbar) in buttonOneAction() }
        }

        if showButtonTwo {
            // Action 2
            snackbar.secondActionText = buttonTitle2
    //        snackbar.secondActionTextColor = UIColor.yellow
            snackbar.secondActionBlock = { (snackbar) in buttonTwoAction() }
        }

        snackbar.show()
        
    }
    
    func showSnackbarMessage(message: String, isError: Bool) {
        
        let snackbar = TTGSnackbar(message: message, duration: .middle)
        
        snackbar.backgroundColor = isError ? .red : .systemGreen

        snackbar.show()
        
    }
    
}
