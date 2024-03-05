//
//  TagsModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/03/2024.
//

import Foundation

struct TagsModel: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Tags2]?
}

struct Tags2: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let imageBackground: String
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, gamesCount = "games_count", imageBackground = "image_background", language
    }
}
