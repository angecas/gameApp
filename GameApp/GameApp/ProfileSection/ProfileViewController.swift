//
//  ProfileViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 17/02/2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    // MARK: - Properties

    private lazy var floatingButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        floatingButton.setTitleColor(.white, for: .normal)
        floatingButton.backgroundColor = Color.darkGrey
        floatingButton.layer.cornerRadius = 8
        floatingButton.titleLabel?.font = Font.bodyFont
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        return floatingButton
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        
        view.addSubview(floatingButton)
        
        floatingButton.addTarget(self, action: #selector(logout), for: .touchUpInside)

        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            floatingButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),

            floatingButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 32),
        ])

        
    }
    
    @objc private func logout() {
        do {
            UserDefaultsHelper.resetUserDefaults()
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
    }

    
}
