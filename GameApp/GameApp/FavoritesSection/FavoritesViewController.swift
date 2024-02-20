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
    
    private var favoriteGenres: [FavoriteGenre] = []
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: "favoritesCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.allowsSelection = true
        tableView.separatorColor = .systemBlue
        tableView.backgroundColor = Color.darkBlue
        tableView.isUserInteractionEnabled = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        FirestoreManager.shared.getFavoriteGenres { (fetchedGenres, error) in
            if let error = error {
                print("Error fetching favorite genres: \(error.localizedDescription)")
            } else {
                self.favoriteGenres = fetchedGenres
                
                DispatchQueue.main.async {
                    if self.favoriteGenres.count > 0 {
                        self.emptyFavoritesView.isHidden = true
                        self.tableView.isHidden = false
                    } else {
                        self.tableView.isHidden = true
                        self.emptyFavoritesView.isHidden = false
                    }
                    self.tableView.reloadData()
                }

            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        
        view.addSubview(favoritesTitleLabel)
        view.addSubview(emptyFavoritesView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            favoritesTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            favoritesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emptyFavoritesView.topAnchor.constraint(equalTo: favoritesTitleLabel.bottomAnchor, constant: 32),
            emptyFavoritesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyFavoritesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyFavoritesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
                        
            tableView.topAnchor.constraint(equalTo: favoritesTitleLabel.bottomAnchor, constant: 32),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                        
        ])
        
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! ListCell
        cell.configure(genreName: favoriteGenres[indexPath.row].name ?? "")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        
        guard let id = favoriteGenres[indexPath.row].id else {return}
        let gamesViewController = GamesViewController(id: id)
            self.navigationController?.pushViewController(gamesViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            guard let id = self.favoriteGenres[indexPath.row].id else {return}
            FirestoreManager.shared.removeFavoriteGenre(id: id) { error in
                if let error = error {
                    print("Error removing favorite genre: \(error.localizedDescription)")
                } else {
                    self.favoriteGenres = self.favoriteGenres.filter { $0.id != id }
                    self.tableView.reloadData()
                    //TODO: make a did delete in a DT to reload and also a diddelete in VC to update collection in genresVC
                }
            }
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration

    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return favoriteGenres.count
    }
}
