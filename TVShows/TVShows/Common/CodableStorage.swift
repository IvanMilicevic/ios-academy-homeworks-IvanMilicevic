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

struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int?
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
        
    }
}

struct ShowEpisode: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        
    }
}

//struct AddShowEpisode: Codable {
//    let showId: String
//    let mediaId: String?
//    let title: String
//    let description: String
//    let episodeNumber: String?
//    let season: String?
//
//    enum CodingKeys: String, CodingKey {
//        case showId
//        case mediaId
//        case title
//        case description
//        case episodeNumber
//        case season
//
//    }
//}


