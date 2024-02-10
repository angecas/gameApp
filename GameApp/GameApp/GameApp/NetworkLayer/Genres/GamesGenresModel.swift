//
//  GamesGenresModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

struct GenresList: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    var results: [Genre] = []

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        next = try container.decodeIfPresent(String.self, forKey: .next)
        previous = try container.decodeIfPresent(String.self, forKey: .previous)
        results = try container.decodeIfPresent([Genre].self, forKey: .results) ?? []
    }
}

struct Genre: Codable {
    let id: Int
    let name: String?
    let slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

