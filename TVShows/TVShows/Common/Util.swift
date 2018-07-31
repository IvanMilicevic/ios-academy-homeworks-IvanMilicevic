//
//  Util.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import Foundation

class Util {
    
    static func isInteger(_ string: String) -> Bool {
        let num = Int(string);
        
        if num != nil {
            return true
        } else {
            return false
        }
    }
    
}
