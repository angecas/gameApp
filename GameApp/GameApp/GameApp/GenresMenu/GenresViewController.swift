//
//  HomeScreenViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import UIKit

class GenresViewController: UIViewController {
    // MARK: - Properties
    private var genres: GenresList?
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("genres", comment: "")
        label.font = Font.extraLargeBoldTitleFont
        label.textColor = Color.blueishWhite
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Color.darkBlue
        collection.register(GridCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - LyfeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        LoadingManager.shared.showLoading()
        Task {
            do {
                let genres = GenresManager()
                let response = try await genres.fetchListOfGamesGenres()
                self.genres = response
                self.collectionView.reloadData()
                LoadingManager.shared.hideLoading()
            } catch {
                print("Error: \(error)")
                LoadingManager.shared.hideLoading()
            }
        }
        setupUI()
        
        //        Task {
        //            do {
        //                let creatorRolesManager = CreatorRolesManager()
        //                let response = try await creatorRolesManager.fetchListOfCreatorPositions()
        //                print(response)
        //            } catch {
        //                print("Error: \(error)")
        //            }
        //        }
        
    }
    
    // MARK: - Helpers
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        refreshControl.endRefreshing()
        
        Task {
            do {
                let genres = GenresManager()
                let response = try await genres.fetchListOfGamesGenres()
                self.genres = response
                self.collectionView.reloadData()
            } catch {
                print("Error: \(error)")
            }
        }
        collectionView.reloadData()
    }
    
    private func setupUI(){
        view.backgroundColor = Color.darkBlue
        
        view.addSubview(pageTitle)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 8)
        ])
    }
}



// MARK: - Collection DataSource

extension GenresViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.genres?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? GridCell else {
            fatalError("Failed to dequeue a cell of type CustomImageCell")
        }
        
        if let genres = genres {
            if indexPath.row < genres.results.count {
                let genre = genres.results[indexPath.row]
                cell.configure(genre: genre)
            } else {
                print("Index out of range: \(indexPath.row), Genre Count: \(genres.results.count)")
            }
        } else {
            print("Genres array is nil")
        }
        
        
        return cell
    }
}

// MARK: - Collection Delegate

extension GenresViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //save to user defaults
        
        if let id = genres?.results[indexPath.row].id {
            UserDefaultsHelper.setSelectedGenre(genreId: id)
            
            let gamesViewController = GamesViewController(id: id)
            navigationController?.pushViewController(gamesViewController, animated: true)
        }
    }
}
extension GenresViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
}
