//
//  StringExtensions.swift
//  Test2
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 iMech. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isURL: Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    var image_: UIImage? {
        return UIImage.init(named: self)
    }
    
    var localize_: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var color_: UIColor {
        return UIColor.hexColor(hex: self)
    }
    
    var convertNumberToEnglish: String {
        
        var newNumber = ""
        
        for value in self {
            switch value {
            case "٠":
                newNumber += "0"
                break
            case "١":
                newNumber += "1"
                break
            case "٢":
                newNumber += "2"
                break
            case "٣":
                newNumber += "3"
                break
            case "٤":
                newNumber += "4"
                break
            case "٥":
                newNumber += "5"
                break
            case "٦":
                newNumber += "6"
                break
            case "٧":
                newNumber += "7"
                break
            case "٨":
                newNumber += "8"
                break
            case "٩":
                newNumber += "9"
                break
            default:
                newNumber += value.description
                break
            }
        }
        
        return newNumber
    }
    
    func toDate(customFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en")
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.dateFormat = customFormat
        return (dateFormatter.date(from: self) ?? Date()).addingTimeInterval(-3 * 60 * 60)
    }
}
