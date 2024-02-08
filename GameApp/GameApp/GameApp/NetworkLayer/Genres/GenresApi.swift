//
//  GenresApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

enum GenresApi {
    case fetchListOfGamesGenres(page: Int)
    case fetchGenresById(id: Int)
}

extension GenresApi: EndpointDescriptor {
    
    var page: Int {
         switch self {
         case .fetchListOfGamesGenres(let page):
             return page
         case .fetchGenresById(id: let id):
             return 10
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
        case .fetchListOfGamesGenres, .fetchGenresById:
            return .get
        }
    }
    var parameters: Parameters? {
       switch self {
       case .fetchListOfGamesGenres:
           return nil
       case .fetchGenresById:
           return nil
       }
    }
    
    var path: String {
        let path = commonPath + "/genres"

        switch self {
        case .fetchListOfGamesGenres(_):
            return path
        case .fetchGenresById(let id):
           return path + "/\(id)"
        }
    }
}
