//
//  GamesModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation
struct GamesModel: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Game]?
}

struct Store: Codable {
    let id: Int?
    let name: String?
    let slug: String?
}

struct Platform: Codable {
    let id: Int?
    let name: String?
    let slug: String?
}

struct Rating: Codable {
    let id: Int?
    let title: String?
    let count: Int
    let percent: Double
}

struct Charts: Codable {
    let year: YearChart?
}

struct YearChart: Codable {
    let year: Int?
    let change: String?
    let position: Int?
}

struct Clip: Codable {
    let clip: String?
    let clips: [String: String]?
    let video: String?
    let preview: String?
}

struct Tag: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let language: String?
    let games_count: Int?
    let image_background: String?
}

struct ESRBRating: Codable {
    let id: Int?
    let name: String?
    let slug: String?
}

struct ShortScreenshot: Codable {
    let id: Int?
    let image: String?
}

struct Game: Codable {
    let slug: String?
    let name: String?
    let playtime: Int?
    let platforms: [Platform]?
    let stores: [Store]?
    let released: String?
    let tba: Bool?
    let background_image: String?
    let rating: Double?
    let rating_top: Double?
    let ratings: [Rating]?
    let ratings_count: Int?
    let reviews_text_count: Int?
    let added: Int?
    let added_by_status: [String: Int]?
    let metacritic: Int?
    let suggestions_count: Int?
    let updated: String?
    let id: Int?
    let score: Double?
    let charts: Charts?
    let clip: Clip?
    let tags: [Tag]?
    let esrb_rating: ESRBRating?
    let user_game: String?
    let reviews_count: Int?
    let promo: String?
    let saturated_color: String?
    let dominant_color: String?
    let short_screenshots: [ShortScreenshot]?
    let parent_platforms: [Platform]?
//    let genres: [Tag]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        slug = try? container.decode(String.self, forKey: .slug)
        name = try? container.decode(String.self, forKey: .name)
        playtime = try? container.decode(Int.self, forKey: .playtime)
        platforms = try? container.decode([Platform].self, forKey: .platforms)
        stores = try? container.decode([Store].self, forKey: .stores)
        released = try? container.decode(String.self, forKey: .released)
        tba = try? container.decode(Bool.self, forKey: .tba)
        background_image = try? container.decode(String.self, forKey: .background_image)
        rating = try? container.decode(Double.self, forKey: .rating)
        rating_top = try? container.decode(Double.self, forKey: .rating_top)
        ratings = try? container.decode([Rating].self, forKey: .ratings)
        ratings_count = try? container.decode(Int.self, forKey: .ratings_count)
        added = try? container.decode(Int.self, forKey: .added)
        added_by_status = try? container.decode([String: Int].self, forKey: .added_by_status)
        metacritic = try? container.decode(Int.self, forKey: .metacritic)
        suggestions_count = try? container.decode(Int.self, forKey: .suggestions_count)
        updated = try? container.decode(String.self, forKey: .updated)
        id = try? container.decode(Int.self, forKey: .id)
        score = try? container.decodeIfPresent(Double.self, forKey: .score)
        charts = try? container.decode(Charts.self, forKey: .charts)
        clip = try? container.decode(Clip.self, forKey: .clip)
        tags = try? container.decode([Tag].self, forKey: .tags)
        esrb_rating = try? container.decode(ESRBRating.self, forKey: .esrb_rating)
        user_game = try? container.decodeIfPresent(String.self, forKey: .user_game)
        reviews_count = try? container.decode(Int.self, forKey: .reviews_count)
        promo = try? container.decode(String.self, forKey: .promo)
        saturated_color = try? container.decode(String.self, forKey: .saturated_color)
        dominant_color = try? container.decode(String.self, forKey: .dominant_color)
        short_screenshots = try? container.decode([ShortScreenshot].self, forKey: .short_screenshots)
        parent_platforms = try? container.decode([Platform].self, forKey: .parent_platforms)
//        genres = try? container.decode([Tag].self, forKey: .genres)

        // Initialize reviews_text_count directly in the main initializer
        let reviewsTextCountString = try? container.decode(String.self, forKey: .reviews_text_count)
        self.reviews_text_count = Int(reviewsTextCountString ?? "0") ?? 0
    }
}

