//
//  CreatorRolesApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

enum CreatorRolesApi {
    case fetchListOfCreatorPositions
}

extension CreatorRolesApi: EndpointDescriptor {
    
//    var url: URL? {
//        let baseURL = URL(string: "http://example.com")
//        return baseURL?.appendingPathComponent(path)
//    }

    var body: Data? {
        return nil
    }
    
    var HTTPMethod: HTTPMethod {
        switch self {
        case .fetchListOfCreatorPositions:
            return .get
        }
    }
    var parameters: Parameters? {
       switch self {
       case .fetchListOfCreatorPositions:
          return nil
       }
    }
    
    var path: String {
        let path = commonPath

        switch self {
        case .fetchListOfCreatorPositions:
            return path + "/creator-roles"
        }
    }
}
