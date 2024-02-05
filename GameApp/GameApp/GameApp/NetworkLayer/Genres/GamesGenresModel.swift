//
//  GamesGenresModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

struct GenresList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let imageBackground: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
