//
//  FirestoreManager.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 19/02/2024.
//

import Foundation
import FirebaseFirestore

struct FavoriteGenre {
    let id: Int?
    let name: String?
}


class FirestoreManager {
    static let shared = FirestoreManager()

    private let userCollection = Firestore.firestore().collection("userFavorites")

    private init() {
    }

    func saveFavorites(id: Int, name: String, completion: @escaping (Error?) -> Void) {
        let favorites = [
            "id": id,
            "name": name,
        ] as [String : Any]

        userCollection.addDocument(data: favorites) { error in
            completion(error)
        }
    }
    
    func favoriteGenresCollection() -> CollectionReference {
        return userCollection
    }

    func getFavoriteGenres(completion: @escaping ([FavoriteGenre], Error?) -> Void) {
        userCollection.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                completion([], error)
                return
            }

            let favoriteGenres = snapshot.documents.compactMap { document in
                let data = document.data()
                let id = data["id"] as? Int ?? 0
                let name = data["name"] as? String ?? ""
                return FavoriteGenre(id: id, name: name)
            }

            completion(favoriteGenres, nil)
        }
    }
    
    
    func removeAllFavorites(completion: @escaping (Error?) -> Void) {
        userCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }

            guard let snapshot = snapshot else {
                completion(nil)
                return
            }

            let batch = Firestore.firestore().batch()

            snapshot.documents.forEach { document in
                let documentRef = self.userCollection.document(document.documentID)
                batch.deleteDocument(documentRef)
            }

            batch.commit { error in
                completion(error)
            }
        }
    }
    func removeFavoriteGenre(id: Int, completion: @escaping (Error?) -> Void) {
        let query = userCollection.whereField("id", isEqualTo: id)

        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
            } else {
                // Iterate through the documents and remove them
                for document in snapshot!.documents {
                    document.reference.delete { error in
                        completion(error)
                    }
                }
            }
        }
    }
    
    func removeFavorite(by genreId: String, completion: @escaping (Error?) -> Void) {
        let query = userCollection.whereField("id", isEqualTo: genreId)

        query.getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }

            guard let snapshot = snapshot, !snapshot.isEmpty else {
                // No matching documents found
                completion(nil)
                return
            }

            // Assuming there's only one document with the given genreId
            let document = snapshot.documents.first!

            document.reference.delete { error in
                completion(error)
            }
        }
    }
}
