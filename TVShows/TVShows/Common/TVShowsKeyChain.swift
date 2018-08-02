//
//  TVShowsKeyChain.swift
//  TVShows
//
//  Created by Infinum Student Academy on 28/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import Foundation
import KeychainAccess

public enum TVShowsKeyChain: String {
    case service = "TVShows"
    case email = "userEmail"
    case password = "userPassword"

}

class KeycChainService {
    
    static func getEmailAndPassword() -> (email: String, password: String) {
        let keychain = Keychain(service: TVShowsKeyChain.service.rawValue)
        
        let email = keychain[TVShowsKeyChain.email.rawValue]!
        let password = keychain[TVShowsKeyChain.password.rawValue]!
        return (email,password)
    }
    
    static func storeEmailAndPassword(email: String, password: String) {
        let keychain = Keychain(service: TVShowsKeyChain.service.rawValue)
        keychain[TVShowsKeyChain.email.rawValue] = email
        keychain[TVShowsKeyChain.password.rawValue] = password
    }
    
}
