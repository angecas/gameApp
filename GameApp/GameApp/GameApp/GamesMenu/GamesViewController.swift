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
        layout.minimumInteritemSpacing = 50
        layout.itemSize = CGSize(width: 80, height: 80)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Color.darkBlue
        collection.register(GridCell2.self, forCellWithReuseIdentifier: "CellIdentifier")
        return collection
    }()
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        gamesCollectionView.delegate = self

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
        
        Task {
            do {
                let games = GamesManager()
                let response = try await games.fetchListOfGames(id: self.id)
                
                print(response, "<<<")
                DispatchQueue.main.async {
                    self.gamesCollectionView.reloadData()

                self.games = response.results
                self.gamesCollectionView.reloadData()
                }
                
                LoadingManager.shared.hideLoading()

            } catch {
                LoadingManager.shared.hideLoading()
                print("Error: \(error)")
            }
        }
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self

        setNavigationActions()
        setupUI()
    }
    
    
    @objc
    func willNavigateBack() {
        print(games?.count)
        self.navigationController?.popToRootViewController(animated: true)
        UserDefaultsHelper.removeSelectedGenre()
    }

    func setNavigationActions() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .plain,
                                                           target: self, action: #selector(willNavigateBack))

    }

    
    private func setupUI() {
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
}

extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(games?.count ?? 0)
        return games?.count ?? 0
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? GridCell2 else {
            fatalError("Failed to dequeue a cell of type CustomImageCell")
        }

        if let games = games {
            if indexPath.row < games.count {
                let game = games[indexPath.row]
                cell.configure(game: game)
            } else {
                print("Index out of range: \(indexPath.row), Genre Count: \(games.count)")
            }
        } else {
            print("Genres array is nil")
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

extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
    }
    
}

extension GamesViewController: GamesDescriptionHeaderViewDelegate {
    func didToggleShowMore(_ view: GamesDescriptionHeaderView) {
        gamesCollectionView.collectionViewLayout.invalidateLayout()
        gamesCollectionView.setContentOffset(CGPoint(x: 0, y: -gamesCollectionView.contentInset.top), animated: false)
        gamesCollectionView.reloadData()

    }
}

extension GamesDescriptionHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 60
    }
    
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 90)
    }

    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (UIScreen.main.bounds.size.width/2)-43, height: 400)
//    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerSize = calculateHeaderSize()
        return headerSize
        
    }
}
