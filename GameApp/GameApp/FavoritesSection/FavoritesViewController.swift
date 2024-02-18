//
//  FavoritesViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 17/02/2024.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - Properties
    
    private let favoritesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Favorites", comment: "")
        label.font = Font.extraLargeBoldTitleFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyFavoritesView: EmptyFavoritesView = {
        let uiView = EmptyFavoritesView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        return uiView
    }()

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        
        view.addSubview(favoritesTitleLabel)
        view.addSubview(emptyFavoritesView)
        
        NSLayoutConstraint.activate([
            favoritesTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            favoritesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emptyFavoritesView.topAnchor.constraint(equalTo: favoritesTitleLabel.bottomAnchor, constant: 32),
            emptyFavoritesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyFavoritesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyFavoritesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
    }
    
}
