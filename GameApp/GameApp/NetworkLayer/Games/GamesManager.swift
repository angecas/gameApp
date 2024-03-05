//
//  GamesManager.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation

struct GamesManager {
   
   let sessionProvider: SessionProvider
   
   init(sessionProvider: SessionProvider = SessionProvider()) {
      self.sessionProvider = sessionProvider
   }
    
    func fetchListOfGames(id: Int, freeSearch: String, preciseSearch: Bool, page: Int) async throws -> GamesModel {
        
        let endpoint = GamesApi.fetchListOfGames(genres: id, freeSearch: freeSearch, preciseSearch: preciseSearch, page: page)
        
        do {
            let response = try await sessionProvider.request(endpoint, responseType: GamesModel.self)
            return response
        } catch {
            throw error
        }
    }
    
    func fetchGameTrailers(id: Int) async throws -> GameVideosModel {
        
        let endpoint = GamesApi.fetchGameTrailers(gameId: id)
        
        do {
            let response = try await sessionProvider.request(endpoint, responseType: GameVideosModel.self)
            return response
        } catch {
            throw error
        }
    }
}
