//
//  File.swift
//  TVShows
//
//  Created by Infinum Student Academy on 20/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setBottomBorderDefault() {
        setBorderWith(color: .lightGray)
    }
    
    func setBottomBorderRed() {
        setBorderWith(color: .red)
    }
    
    func setBorderWith(color: UIColor) {
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
    
}
