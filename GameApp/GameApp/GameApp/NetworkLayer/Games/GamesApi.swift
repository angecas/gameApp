//
//  GamesApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation

enum GamesApi {
    case fetchListOfGames(id: Int)
}

extension GamesApi: EndpointDescriptor {
    
    var page: Int {
        return 1
    }
    
    var pageSize: Int {
        return 10
    }

    var body: Data? {
        return nil
    }
    var HTTPMethod: HTTPMethod {
        switch self {
        case .fetchListOfGames:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchListOfGames(let id):
            return ["id": id as Any]
        }
    }
    
    var path: String {
        let path = commonPath + "/games"

        switch self {
        case .fetchListOfGames(_):
            return path
        }
    }
}
