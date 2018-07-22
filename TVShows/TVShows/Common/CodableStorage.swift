//
//  CodableStorage.swift
//  TVShows
//
//  Created by Infinum Student Academy on 22/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import Foundation

struct Show: Codable {
    let id: String
    let title: String
    let likesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case likesCount
        
    }
}
