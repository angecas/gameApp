//
//  GameViewModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 12/02/2024.
//

import Foundation

class GameViewModel {
    let game: Game
    var gameProperties: [String] = []
    var gamePropertiesInfo: [String] = []

    init(game: Game) {
        self.game = game

        if let releasedString = game.releasedToString() {
            gameProperties.append(NSLocalizedString("released-date", comment: ""))
            gamePropertiesInfo.append(releasedString)
        }

        if let updatedString = game.updatedToString() {
            gameProperties.append(NSLocalizedString("update-date", comment: ""))
            gamePropertiesInfo.append(updatedString)
        }

        if let rating = game.ratingsToString() {
            gameProperties.append(NSLocalizedString("rating", comment: ""))
            gamePropertiesInfo.append(rating)
        }

        if let metaScore = game.metacritic {
            gameProperties.append(NSLocalizedString("metascore", comment: ""))
            gamePropertiesInfo.append("\(metaScore)")
        }
        
        if let esrb = game.esrb_rating?.name {
            gameProperties.append(NSLocalizedString("esrb-rating", comment: ""))
            gamePropertiesInfo.append("\(esrb)")
        }
    }
}
