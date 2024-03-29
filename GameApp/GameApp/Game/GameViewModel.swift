//
//  GameViewModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 12/02/2024.
//

import Foundation

class GameViewModel {
    let game: Game
    var gameVideos: GameVideosModel?
    var gamePropertiesForm: [(String, String)] = []

    init(game: Game) {
        
        self.game = game
        
        if let gameId = game.id {
            fetchGameVideos(id: gameId)
        }

        if let releasedString = game.releasedToString() {
            gamePropertiesForm.append((NSLocalizedString("released-date", comment: ""), releasedString))
        }

        if let updatedString = game.updatedToString() {
            gamePropertiesForm.append((NSLocalizedString("update-date", comment: ""), updatedString))
        }

        if let rating = game.ratingsToString() {
            gamePropertiesForm.append((NSLocalizedString("rating", comment: ""), rating))
        }

        if let metaScore = game.metacritic {
            gamePropertiesForm.append((NSLocalizedString("metascore", comment: ""), String(metaScore)))
        }
        
        if let esrb = game.esrb_rating?.name {
            gamePropertiesForm.append((NSLocalizedString("esrb-rating", comment: ""), esrb))
        }
    }
        
    private func fetchGameVideos(id: Int) {
        Task {
            do {
                let videos = GamesManager()
                let response = try await videos.fetchGameTrailers(id: id)
                
                DispatchQueue.main.async {
                    
                    self.gameVideos = response
//                    self.delegate?.didFetchDetail(self, genre: response)
                    
                    LoadingManager.shared.hideLoading()
                }
                
            } catch {
                DispatchQueue.main.async {
                    
                    LoadingManager.shared.hideLoading()
                    print("Error: \(error)")
                }
            }
        }
        
    }
}
