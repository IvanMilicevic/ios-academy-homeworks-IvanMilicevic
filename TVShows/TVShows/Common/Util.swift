//
//  Util.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class Util {
    
    static func isInteger(_ string: String) -> Bool {
        let num = Int(string);
        
        if num != nil {
            return true
        } else {
            return false
        }
    }
    
    static func getRandomUserImage() -> UIImage {
        switch arc4random_uniform(3) {
        case 0:
            return UIImage(named: "img-placeholder-user1")!
        case 1:
            return UIImage(named: "img-placeholder-user2")!
        case 2:
            return UIImage(named: "img-placeholder-user3")!
        default:
            return UIImage(named: "img-placeholder-user1")!
        }
    }
    
}
