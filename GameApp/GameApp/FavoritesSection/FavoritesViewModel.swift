//
//  FavoritesViewModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 22/02/2024.
//

import Foundation

protocol FavoritesViewModelDelegate: AnyObject {
    func didFetchFavoriteGenres(_ model: FavoritesViewModel)
    func didRemoveFavoriteGenres(_ model: FavoritesViewModel)
}

class FavoritesViewModel {
    
    // MARK: - Properties
    weak var delegate: FavoritesViewModelDelegate?
    private var isLoadingData = false
    var favoriteGenres: [FavoriteGenre] = []

    var genres: GenresList?
    
    // MARK: - Fetch Data
    
    func fetchFavoriteGenres() {
        
        FirestoreManager.shared.getFavoriteGenres { (fetchedGenres, error) in
            if let error = error {
                print("Error fetching favorite genres: \(error.localizedDescription)")
            } else {
                self.favoriteGenres = fetchedGenres
                
                DispatchQueue.main.async {
                    self.delegate?.didFetchFavoriteGenres(self)
                }
            }
        }
     }
    
    func removeFavoriteGenre(id: Int) {
        FirestoreManager.shared.removeFavoriteGenre(id: id) { error in
            if let error = error {
                print("Error removing favorite genre: \(error.localizedDescription)")
            } else {
                self.favoriteGenres = self.favoriteGenres.filter { $0.id != id }
                self.delegate?.didRemoveFavoriteGenres(self)
//                self.tableView.reloadData()
            }
        }
    }
}
