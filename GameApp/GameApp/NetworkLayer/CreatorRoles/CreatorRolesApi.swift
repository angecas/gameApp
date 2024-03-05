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
    var page: Int? {
        return 1
    }
    
    var pageSize: Int? {
        return 10
    }

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
