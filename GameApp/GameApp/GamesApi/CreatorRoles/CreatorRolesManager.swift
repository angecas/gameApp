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
    
    func fetchListOfCreatorPositions() async -> GameCreatorList? {
        let endpoint = CreatorRolesApi.fetchListOfCreatorPositions
        
       let response = try? await sessionProvider.request(endpoint, responseType: GameCreatorList.self)
       return response
    }

}
