//
//  CreatorRolesManager.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

struct CreatorRolesManager {
   
   let sessionProvider: SessionProvider
   
   init(sessionProvider: SessionProvider = SessionProvider()) {
      self.sessionProvider = sessionProvider
   }
    
    func fetchListOfCreatorPositions() async throws -> GameCreatorList {
        let endpoint = CreatorRolesApi.fetchListOfCreatorPositions
        
        do {
            let response = try await sessionProvider.request(endpoint, responseType: GameCreatorList.self)
            return response
        } catch {
            print(error.localizedDescription)
            print("-----")
            print(error)
            throw error
        }
    }
}
