//
//  GamesViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import UIKit

class GamesViewController: UIViewController {
    // MARK: - Properties
    private var genre: Genre?
    private var games: [Game]?
    private let id: Int
    private var currentPage = 1
    private var isLoadingData = false

    private lazy var gamesDescriptionHeaderView: GamesDescriptionHeaderView = {
        let view = GamesDescriptionHeaderView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldLargeTitleFont
        label.textColor = Color.blueishWhite
        return label
    }()
        
    private lazy var gamesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Color.darkBlue
        collection.register(GamesCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        return collection
    }()
    
    // MARK: - Inits
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LoadingManager.shared.showLoading()
        Task {
            do {
                let genre = GenresManager()
                let response = try await genre.fetchGenresById(self.id)
                self.genre = response
                self.pageTitle.text = response.name
                let description = SharedHelpers().removeHtmlTagsAndDecodeEntities(from: response.description)
                
                gamesDescriptionHeaderView.setContent(with: description ?? "")
                gamesDescriptionHeaderView.isUserInteractionEnabled = true
                LoadingManager.shared.hideLoading()

            } catch {
                LoadingManager.shared.hideLoading()
                print("Error: \(error)")
            }
        }
        
        fetchData()

        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        setupUI()
        setNavigationActions()
    }
    // MARK: - Helpers
    private func setupUI() {
        gamesCollectionView.reloadData()

        view.backgroundColor = Color.darkBlue
        view.addSubview(pageTitle)
        view.addSubview(gamesDescriptionHeaderView)
        view.addSubview(gamesCollectionView)

        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            gamesDescriptionHeaderView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 8),
            gamesDescriptionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesDescriptionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gamesCollectionView.topAnchor.constraint(equalTo: gamesDescriptionHeaderView.bottomAnchor, constant: 8)
        ])
    }

    private func fetchData() {
         guard !isLoadingData else { return }
         isLoadingData = true

         Task {
             do {
                 let games = GamesManager()
                 let response = try await games.fetchListOfGames(id: self.id, page: self.currentPage)
                 
                 DispatchQueue.main.async {
                     if let existingGames = self.games {
                         self.games?.append(contentsOf: response.results ?? [])
                     } else {
                         self.games = response.results
                     }
                     self.gamesCollectionView.reloadData()
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
    
    
    @objc
    func willNavigateBack() {
        self.navigationController?.popToRootViewController(animated: true)
        UserDefaultsHelper.removeSelectedGenre()
    }

    func setNavigationActions() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .plain,
                                                           target: self, action: #selector(willNavigateBack))

    }
}
// MARK: - CollectionView DataSource
extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? GamesCell else {
            fatalError("Failed to dequeue a cell of type CustomImageCell")
        }

        if let games = games {
            if indexPath.row < games.count {
                let game = games[indexPath.row]
                cell.configure(game: game)
            } else {
                print("Index out of range: \(indexPath.row), Genre Count: \(games.count)")
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "\(ResultReusableView.self)",
                                                                         for: indexPath) as! ResultReusableView
            header.configureWithView(gamesDescriptionHeaderView)
            return header
        }
        return UICollectionReusableView()
    }

}

// MARK: - CollectionView Delegate

extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GamesCell {
            cell.showCellDetails()
        }
    }
}

// MARK: - GamesDescriptionHeaderView Delegate

extension GamesViewController: GamesDescriptionHeaderViewDelegate {
    func didToggleShowMore(_ view: GamesDescriptionHeaderView) {
        gamesCollectionView.collectionViewLayout.invalidateLayout()
        gamesCollectionView.setContentOffset(CGPoint(x: 0, y: -gamesCollectionView.contentInset.top), animated: false)
        gamesCollectionView.reloadData()
    }
}
// MARK: - CollectionViewFlowLayout Delegate

extension GamesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = indexPath.item
        let totalItems = collectionView.numberOfItems(inSection: 0)

        if lastItem == totalItems - 1 {
            currentPage += 1

            Task {
                do {
                    let games = GamesManager()
                    let response = try await games.fetchListOfGames(id: self.id, page: self.currentPage)

                    DispatchQueue.main.async {
                        if let results = response.results, !results.isEmpty {
                            self.games?.append(contentsOf: results)
                            self.gamesCollectionView.reloadData()
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}


