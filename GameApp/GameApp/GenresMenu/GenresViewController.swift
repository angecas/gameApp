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
    
    private var viewModel: GenresViewModel
    private var teste: [Int] = []
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("genres", comment: "")
        label.font = Font.extraLargeBoldTitleFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = Color.darkBlue
        collection.register(GenresCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    // MARK: - Inits
    
    init() {
        self.viewModel = GenresViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LyfeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirestoreManager.shared.getFavoriteGenres { (fetchedGenres, error) in
            if let error = error {
                print("Error fetching favorite genres: \(error.localizedDescription)")
            } else {
                self.teste = fetchedGenres.compactMap({$0.id})
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        collectionView.refreshControl = refreshControl
        LoadingManager.shared.showLoading()
        viewModel.fetchData()
        setupUI()
        setUpDoubleTap()
        
    }
    
    // MARK: - Helpers
    
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 8)
            ])
    }

        
    @objc func didDoubleTapCollectionView() {
           let pointInCollectionView = doubleTapGesture.location(in: collectionView)
           if let selectedIndexPath = collectionView.indexPathForItem(at: pointInCollectionView) {
               let tappedGenredId = viewModel.genres?.results[selectedIndexPath.row].id
               let tappedGenredName = viewModel.genres?.results[selectedIndexPath.row].name
                              
                   if let tappedGenredId = tappedGenredId, let tappedGenredName = tappedGenredName {
                       
                       let isGenreAlreadyAdded = teste.contains(tappedGenredId)

                       if !isGenreAlreadyAdded {
                                                  
                               FirestoreManager.shared.saveFavorites(id: tappedGenredId, name: tappedGenredName) { error in
                                   if let error = error {
                                       print("Error saving favorite: \(error.localizedDescription)")
                                   } else {
                                       print("Favorite saved successfully")
                                       self.teste.append(tappedGenredId)
                                       self.collectionView.reloadData()

                                   }
                               }
                               collectionView.reloadData()
                       } else {
                           //TODO: put in datasource and make a didfetch delegate here to reload data

                           FirestoreManager.shared.removeFavoriteGenre(id: tappedGenredId) { error in
                               if let error = error {
                                   print("Error removing favorite genre: \(error.localizedDescription)")
                               } else {
                                   self.teste = self.teste.filter { $0 != tappedGenredId }
                                   self.collectionView.reloadData()
                               }
                           }
                           collectionView.reloadData()
                       }
                   }
           }
       }
    
    private var doubleTapGesture: UITapGestureRecognizer!
      func setUpDoubleTap() {
          doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
          doubleTapGesture.numberOfTapsRequired = 2
          collectionView.addGestureRecognizer(doubleTapGesture)
          doubleTapGesture.delaysTouchesBegan = true
      }

    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        refreshControl.endRefreshing()
        viewModel.fetchData()
        collectionView.reloadData()
    }
}

// MARK: - Collection DataSource

extension GenresViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.genres?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? GenresCell else {
            fatalError("Failed to dequeue a cell of type CustomImageCell")
        }
        
        if let genres = viewModel.genres {
            if indexPath.row < genres.results.count {
                let genre = genres.results[indexPath.row]
                
                let isFavorite = self.teste.contains(genre.id)
                                
                cell.configure(genre: genre, isFavoriteGenre: isFavorite)
            }
        }
        return cell
    }
}

// MARK: - Collection Delegate

extension GenresViewController: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let id = viewModel.genres?.results[indexPath.row].id {
            UserDefaultsHelper.setSelectedGenre(genreId: id)
            
            let gamesViewController = GamesViewController(id: id)
                self.navigationController?.pushViewController(gamesViewController, animated: true)
        }
    }
}

// MARK: - CollectionViewFlowLayout Delegate

extension GenresViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = indexPath.item
        let totalItems = collectionView.numberOfItems(inSection: 0)

        if lastItem == totalItems - 1 {
            viewModel.currentPage += 1
            viewModel.fetchData()
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

extension GenresViewController: GenresViewModelDelegate {
    func didFetchData(_ model: GenresViewModel) {
        self.collectionView.reloadData()
    }
}
