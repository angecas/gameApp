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
    
    static func setSelectedGenre(genreId: Int) {
        UserDefaults.standard.set(String(genreId), forKey: "selectedGenre")
    }
    
    static func removeSelectedGenre() {
        UserDefaults.standard.removeObject(forKey: "selectedGenre")
    }
    
//    static func getFavoriteGenres() -> [Int] {
//        if let genreIds = UserDefaults.standard.array(forKey: "selectedFavoriteGenres") as? [Int] {
//            return genreIds
//        }
//        return []
//    }
    
//    static func setFavoriteGenres(genreId: Int) {
//        var favoriteGenres = getFavoriteGenres()
//        
//        if !favoriteGenres.contains(genreId) {
//                favoriteGenres.append(genreId)
//                UserDefaults.standard.set(favoriteGenres, forKey: "selectedFavoriteGenres")
//        }
//    }
    
//    static func removeFavoriteGenre(genreId: Int) {
//        var favoriteGenres = getFavoriteGenres()
//        
//        if let index = favoriteGenres.firstIndex(of: genreId) {
//            favoriteGenres.remove(at: index)
//            UserDefaults.standard.set(favoriteGenres, forKey: "selectedFavoriteGenres")
//        }
//    }
    
    
    static func resetUserDefaults() {
            UserDefaults.standard.removeObject(forKey: "selectedGenre")
            UserDefaults.standard.removeObject(forKey: "selectedFavoriteGenres")
            UserDefaults.standard.synchronize()
    }
}
