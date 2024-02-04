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
    private let id: Int
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("games", comment: "")
        label.font = Font.extraLargeBoldTitleFont
        label.textColor = Color.blueishWhite
        return label
    }()
    
    private let gamesInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Font.subTitleFont
        label.textColor = Color.blueishWhite
        return label
    }()
    
    private lazy var gamesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Color.darkBlue
        collection.register(HomeScreenCell.self, forCellWithReuseIdentifier: "HomeCellIdentifier")
//        collection.dataSource = self
//        collection.delegate = self
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
        
        Task {
            do {
                let genre = GenresManager()
                let response = try await genre.fetchGenresById(self.id)
                self.genre = response
                gamesInfo.text = response.description

            } catch {
                print("Error: \(error)")
            }
        }
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = Color.darkBlue

        view.addSubview(pageTitle)
        view.addSubview(gamesInfo)
//        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            gamesInfo.topAnchor.constraint(equalTo: pageTitle.bottomAnchor),
            gamesInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            

//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//                    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//                    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            collectionView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 8)
        ])
    }

    
}
