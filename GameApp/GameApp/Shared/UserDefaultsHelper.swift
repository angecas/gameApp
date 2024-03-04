//
//  UserDefaultsHelper.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import Foundation

protocol UserDefaultsProtocol {
    func string(forKey defaultName: String) -> String?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
    func synchronize() -> Bool
}

extension UserDefaults: UserDefaultsProtocol {}

struct UserDefaultsHelper {
    private static var userDefaults: UserDefaultsProtocol = UserDefaults.standard
    
    static func setUserDefaults(_ userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    static func getSelectedGenre() -> Int? {
        if let genreId = userDefaults.string(forKey: "selectedGenre") {
            return Int(genreId)
        }
        return nil
    }
    
    static func setSelectedGenre(genreId: Int) {
        userDefaults.set(String(genreId), forKey: "selectedGenre")
    }
    
    static func removeSelectedGenre() {
        userDefaults.removeObject(forKey: "selectedGenre")
    }
    
    static func resetUserDefaults() {
        userDefaults.removeObject(forKey: "selectedGenre")
        userDefaults.synchronize()
    }
}
