//
//  GamesApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation

enum GamesApi {
    case fetchListOfGames(genres: Int, page: Int)
}

extension GamesApi: EndpointDescriptor {
    
    var page: Int {
         switch self {
         case .fetchListOfGames(_, let page):
             return page
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
        case .fetchListOfGames:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchListOfGames(let genres, _):
            return ["genres": genres as Any]
        }
    }
    
    var path: String {
        let path = commonPath + "/games"

        switch self {
        case .fetchListOfGames(_, _):
            return path
        }
    }
}
