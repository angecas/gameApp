//
//  CreatorRolesModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

struct GameCreatorList: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [GameCreator]?
}

struct GameCreator: Codable {
    let id: Int?
    let name: String?
    let slug: String?
}
