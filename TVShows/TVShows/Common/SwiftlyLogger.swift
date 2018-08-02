//
//  SwiftlyLogger.swift
//  TVShows
//
//  Created by Infinum Student Academy on 25/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import Foundation

public enum SwiftyState: Int {
    case relase
    case development
}

class SwiftyLog {
    
    private static var swiftyFlag: SwiftyState = SwiftyState.development
    
    static func debug(_ items: Any) {
        if (SwiftyLog.swiftyFlag == SwiftyState.development){
            print("Debug:[🛠]: \(items)")
        }
    }
    
    static func error(_ items: Any) {
        if (SwiftyLog.swiftyFlag == SwiftyState.development){
            print("ERROR:[❌]: \(items)")
        }
    }
    
    static func info(_ items: Any) {
        if (SwiftyLog.swiftyFlag == SwiftyState.development){
            print("Info:[ℹ️]: \(items)")
        }
    }
    
    static func warning(_ items: Any) {
        if (SwiftyLog.swiftyFlag == SwiftyState.development){
            print("Warning:[⚠️]: \(items)")
        }
    }
    
    
}
