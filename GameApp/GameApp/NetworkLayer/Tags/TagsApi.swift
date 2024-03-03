//
//  TagsApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/03/2024.
//

import Foundation

enum TagsApi {
    case fetchListOfTags(page: Int)
}

extension TagsApi: EndpointDescriptor {
    
    var page: Int {
         switch self {
         case .fetchListOfTags(let page):
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
        case .fetchListOfTags:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchListOfTags(_):
            return nil
        }
    }
    
    var path: String {
        let path = commonPath + "/tags"

        switch self {
        case .fetchListOfTags(_):
            return path
        }
    }
}
