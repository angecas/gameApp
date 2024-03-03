//
//  TagsManager.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/03/2024.
//

import Foundation

struct TagsManager {
   
   let sessionProvider: SessionProvider
   
   init(sessionProvider: SessionProvider = SessionProvider()) {
      self.sessionProvider = sessionProvider
   }
    
    func fetchListOfTags(page: Int) async throws -> TagsModel {
        let endpoint = TagsApi.fetchListOfTags(page: page)
        
        do {
            let response = try await sessionProvider.request(endpoint, responseType: TagsModel.self)
            return response
        } catch {
            throw error
        }
    }
}
