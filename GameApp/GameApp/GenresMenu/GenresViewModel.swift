//
//  GenresViewModel.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 11/02/2024.
//

import Foundation

protocol GenresViewModelDelegate: AnyObject {
    func didFetchData(_ model: GenresViewModel)
    func didFetchDataWithError(_ model: GenresViewModel)
}

class GenresViewModel {
    
    // MARK: - Properties
    weak var delegate: GenresViewModelDelegate?
    var currentPage = 1
    private var isLoadingData = false
    var genres: GenresList?
    var tags: TagsModel?
    
    // MARK: - Fetch Data
    
    func fetchData() {
         guard !isLoadingData else { return }
         isLoadingData = true

         Task {
             do {
                 let genres = GenresManager()
                 let response = try await genres.fetchListOfGamesGenres(page: self.currentPage)

                 DispatchQueue.main.async {
                     if self.genres != nil {
                         self.genres?.results.append(contentsOf: response.results)
                     } else {
                         self.genres = response
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
                     //add error view
                     self.delegate?.didFetchDataWithError(self)
                 }
             }
         }
     }
    
    func fetchTags() {
//        guard !isLoadingData else { return }
//        isLoadingData = true

        Task {
            do {
                let tags = TagsManager()
                let response = try await tags.fetchListOfTags(page: 1)
                
                self.tags = response
                
                DispatchQueue.main.async {
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
