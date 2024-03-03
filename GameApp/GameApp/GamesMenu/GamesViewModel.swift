//
//  GamesviewModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 11/02/2024.
//

import Foundation


protocol GamesviewModelDelegate: AnyObject {
    func didFetchDetail(_ model: GamesviewModel, genre: Genre)
    func didFetchData(_ model: GamesviewModel)
}

class GamesviewModel {
    weak var delegate: GamesviewModelDelegate?
    var genre: Genre?
    var games: [Game]?
    private let id: Int
    var currentPage = 1
    private var isLoadingData = false
    
    init(id: Int) {
        self.id = id
    }

    
    func fetchDetail() {
        Task {
            do {
                let genre = GenresManager()
                let response = try await genre.fetchGenresById(self.id)
                DispatchQueue.main.async {
                    
                    self.genre = response
                    self.delegate?.didFetchDetail(self, genre: response)
                    
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
    
    func fetchMoreData(lastItem: Int, freeSearch: String, totalItems: Int) {
        if lastItem == totalItems - 1 {
            currentPage += 1

            Task {
                do {
                    let games = GamesManager()
                    let response = try await games.fetchListOfGames(id: self.id, freeSearch: freeSearch, page: self.currentPage)

                    DispatchQueue.main.async {
                        if let results = response.results, !results.isEmpty {
                            self.games?.append(contentsOf: results)
                            
                            self.delegate?.didFetchData(self)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func fetchData(freeSearch: String) {
        guard !isLoadingData else { return }
        isLoadingData = true
        
        Task {
            do {
                let games = GamesManager()
                let response = try await games.fetchListOfGames(id: self.id, freeSearch: freeSearch, page: self.currentPage)
                
                DispatchQueue.main.async {
                    if self.games != nil {
                        self.games?.append(contentsOf: response.results ?? [])
                    } else {
                        self.games = response.results
                    }
                    
                    self.delegate?.didFetchData(self)
                    
                    self.isLoadingData = false
                    
                    LoadingManager.shared.hideLoading()
                }
                
            } catch {
                DispatchQueue.main.async {
                    
                    self.isLoadingData = false
                    LoadingManager.shared.hideLoading()
                    print("Error: \(error)")
                }
            }
        }
    }
}

