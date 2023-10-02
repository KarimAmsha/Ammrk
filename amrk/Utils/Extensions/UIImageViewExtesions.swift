//
//  UIImageViewExtesions.swift
//  Rules
//
//  Created by mac on 4/24/20.
//  Copyright © 2020 Yousef El-Madhoun. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    @IBInspectable var imageColor: UIColor {
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        } get {
            return self.tintColor
        }
    }
    
    func imageURL(url: String) {
        self.sd_setImage(with: URL(string: url), placeholderImage: nil)
    }
    
    @IBInspectable var isFlipImageInRTL: Bool {
        set {
            if newValue {
                let lang = UserProfile.shared.language ?? Language.english
                if lang == .arabic {
                    self.transform = CGAffineTransform(scaleX: -1, y: 1) //Flipped
                }
            }
        } get {
            return self.isFlipImageInRTL
        }
    }
    
}
