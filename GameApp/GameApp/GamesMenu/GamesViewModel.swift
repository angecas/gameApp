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
    func didFetchTags(_ model: GamesviewModel)
//    func didFetchDataWithError(_ model: GamesviewModel)
}

class GamesviewModel {
    weak var delegate: GamesviewModelDelegate?
    var genre: Genre?
    var games: [Game]?
    private let id: Int
    var currentPage = 1
    private var isLoadingData = false
    var tags: [Tags2]?
    
    
    init(id: Int) {
        self.id = id
//        LoadingManager.shared.showLoading()
    }
    
    func fetchTags() {
//        guard !isLoadingData else { return }
//        isLoadingData = true

        Task {
            do {
                let tags = TagsManager()
                let response = try await tags.fetchListOfTags(page: 1)
                
                self.tags = response.results
                
                DispatchQueue.main.async {
                    self.delegate?.didFetchTags(self)
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
    
    func fetchMoreData(lastItem: Int, freeSearch: String, preciseSearch: Bool, totalItems: Int, tags: Int? = nil) {
        if lastItem == totalItems - 1 {
            currentPage += 1

            Task {
                do {
                    let games = GamesManager()
                    
                     let response = try await games.fetchListOfGames(id: self.id, freeSearch: freeSearch, preciseSearch: preciseSearch, page: self.currentPage, tags: tags)
                    
//                    let response = try await games.fetchListOfGames(id: self.id, freeSearch: freeSearch, preciseSearch: preciseSearch, page: self.currentPage)

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
    
    func fetchData(freeSearch: String, preciseSearch: Bool, tags: Int? = nil) {
        guard !isLoadingData else { return }
        isLoadingData = true
        
        Task {
            do {
                let games = GamesManager()

                let response = try await games.fetchListOfGames(id: self.id, freeSearch: freeSearch, preciseSearch: preciseSearch, page: self.currentPage, tags: tags)
                
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
                    
                    print("......> ", self.games?.count)
                    
                    self.isLoadingData = false
                    self.delegate?.didFetchData(self)
                    
                    //TODO: did fetch with error
                    LoadingManager.shared.hideLoading()
                }
            }
        }
    }
}

