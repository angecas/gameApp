//
//  MockFirestoreManager.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import FirebaseFirestore
@testable import GameApp

class MockFirestoreManager: FirestoreManagingProtocol {
    var inFirestoreStorage: [FavoriteGenre] = []

    func saveFavorites(id: Int, name: String, completion: @escaping (Error?) -> Void) {
        let newFavorite = FavoriteGenre(id: id, name: name)
        inFirestoreStorage.append(newFavorite)
        completion(nil)
    }
    
    func favoriteGenresCollection() -> CollectionReference {
        return Firestore.firestore().collection("mockUserFavorites")
    }
    
    func getFavoriteGenres(completion: @escaping ([GameApp.FavoriteGenre], Error?) -> Void) {
        completion(inFirestoreStorage, nil)
    }
    
    func removeAllFavorites(completion: @escaping (Error?) -> Void) {
        inFirestoreStorage.removeAll()
        completion(nil)
    }
    
    func removeFavoriteGenre(id: Int, completion: @escaping (Error?) -> Void) {
        inFirestoreStorage.removeAll { $0.id == id }
        completion(nil)
    }
    
    func removeFavorite(by genreId: String, completion: @escaping (Error?) -> Void) {
        inFirestoreStorage.removeAll { $0.id == Int(genreId) }
        completion(nil)
    }
    
    
}
