//
//  UserDefaultsHelper.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation

struct UserDefaultsHelper {
    static func getSelectedGenre() -> Int? {
        if let genreId = UserDefaults.standard.string(forKey: "selectedGenre") {
            return Int(genreId)
        }
        return nil
    }

    static func saveSelectedGenre(genreId: Int) {
        UserDefaults.standard.set(String(genreId), forKey: "selectedGenre")
    }
}
