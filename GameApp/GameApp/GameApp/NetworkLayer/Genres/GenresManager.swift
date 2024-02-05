//
//  GenresManager.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

struct GenresManager {
   
   let sessionProvider: SessionProvider
   
   init(sessionProvider: SessionProvider = SessionProvider()) {
      self.sessionProvider = sessionProvider
   }
    
    func fetchListOfGamesGenres() async throws -> GenresList {
        let endpoint = GenresApi.fetchListOfGamesGenres(ordering: nil)
        
        do {
            let response = try await sessionProvider.request(endpoint, responseType: GenresList.self)
            return response
        } catch {
            throw error
        }
    }
    
    func fetchGenresById(_ id: Int) async throws -> Genre {
        let endpoint = GenresApi.fetchGenresById(id: id)
        
        do {
            let response = try await sessionProvider.request(endpoint, responseType: Genre.self)
            return response
        } catch {
            throw error
        }
    }
}
