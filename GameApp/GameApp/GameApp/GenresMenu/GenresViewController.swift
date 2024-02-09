//
//  HomeScreenViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import UIKit
import FirebaseAuth

class GenresViewController: UIViewController {
    // MARK: - Properties
    private var currentPage = 1
    private var isLoadingData = false
    private var genres: GenresList?
    private lazy var floatingButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.setTitle("Out", for: .normal)
        floatingButton.backgroundColor = .black
        floatingButton.layer.cornerRadius = 25
        floatingButton.translatesAutoresizingMaskIntoConstraints = false

        return floatingButton
    }()
    
    
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
        fetchData()
        setupUI()
        
    }
    
    // MARK: - Helpers
    
    //no sign up or a ir para o genres quando fazes o registo
    //no logout por a ir para a pagina de login
    
    @objc private func logout() {
        
        /*
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
         */
    }
    
    private func fetchData() {
         guard !isLoadingData else { return }
         isLoadingData = true

         Task {
             do {
                 let genres = GenresManager()
                 let response = try await genres.fetchListOfGamesGenres(page: self.currentPage)

                 DispatchQueue.main.async {
                     if let existingGenres = self.genres {
                         self.genres?.results.append(contentsOf: response.results)
                     } else {
                         self.genres = response
                     }
                     self.collectionView.reloadData()
                     self.isLoadingData = false
                 }

                 LoadingManager.shared.hideLoading()

             } catch {
                 self.isLoadingData = false
                 LoadingManager.shared.hideLoading()
                 print("Error: \(error)")
             }
         }
     }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        refreshControl.endRefreshing()
        fetchData()
        collectionView.reloadData()
    }
    
    private func setupUI(){
        view.backgroundColor = Color.darkBlue
        view.addSubview(floatingButton)
        view.addSubview(pageTitle)
        view.addSubview(collectionView)
        
        floatingButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: floatingButton.topAnchor),
            collectionView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 8),
            
            floatingButton.widthAnchor.constraint(equalToConstant: 50),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10),

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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = indexPath.item
        let totalItems = collectionView.numberOfItems(inSection: 0)

        if lastItem == totalItems - 1 {
            currentPage += 1
            fetchData()
        }
    }

    
    
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
