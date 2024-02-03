//
//  HomeScreenViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import UIKit

class HomeScreenViewController: UIViewController {
    private let text: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Home"
        label.textColor = Color.blueishWhite
        return label
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = Color.darkBlue
        view.addSubview(text)
        
        Task {
            do {
                let creatorRolesManager = CreatorRolesManager()
                let response = try await creatorRolesManager.fetchListOfCreatorPositions()
                print(response)
            } catch {
                print("Error: \(error)")
            }
        }

        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
