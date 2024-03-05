//
//  GamesApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation

enum GamesApi {
    case fetchListOfGames(genres: Int, freeSearch: String?, preciseSearch: Bool, page: Int)
    case fetchGameTrailers(gameId: Int)
}

extension GamesApi: EndpointDescriptor {
    
    var page: Int {
         switch self {
         case .fetchListOfGames(_, _, _, let page):
             return page
         case .fetchGameTrailers:
             return 1
         }
     }
    
    var pageSize: Int {
        return 9
    }

    var body: Data? {
        return nil
    }
    
    var HTTPMethod: HTTPMethod {
        switch self {
        case .fetchListOfGames, .fetchGameTrailers:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchListOfGames(let genres, let freeSearch, let preciseSearch, _):
            return ["genres": genres as Any, "search": freeSearch, "search_precise": preciseSearch]
        case .fetchGameTrailers(let gameId):
            return ["id": gameId]
        }
    }
    
    var path: String {
        let path = commonPath + "/games"

        switch self {
        case .fetchListOfGames(_, _, _, _):
            return path
        case .fetchGameTrailers(let gameId):
            return path + "/\(gameId)/movies"
        }
    }
}
