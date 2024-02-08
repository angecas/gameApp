//
//  SplashScreenViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//
import FirebaseAuth
import UIKit

class SplashViewController: UIViewController {

    // MARK: - Properties

    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logout()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.authenticatUserAndSeteUI()
        }
    }

    // MARK: - Helpers
    
    private func authenticatUserAndSeteUI() {
        if Auth.auth().currentUser == nil {
            print("not logged")
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        } else {
                print("logged")
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: GenresViewController())
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }            
        }
    }

    
//    private func logout() {
//        do {
//            try Auth.auth().signOut()
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }

    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        view.addSubview(splashImageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.shakeIcon()
        }

        NSLayoutConstraint.activate([
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.heightAnchor.constraint(equalToConstant: 85),
            splashImageView.widthAnchor.constraint(equalToConstant: 85),
        ])
    }

    @objc private func showMainViewController() {
        
        if let selectedGenredId = UserDefaultsHelper.getSelectedGenre() {
            
            let mainViewController = GenresViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            navigationController.pushViewController(GamesViewController(id: selectedGenredId), animated: false)
            navigationController.modalPresentationStyle = .fullScreen

            present(navigationController, animated: true, completion: nil)
        } else {
            
            let mainViewController = GenresViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }

    
    private func shakeIcon() {
        SharedHelpers().shakeView(uiView: splashImageView)
    }
}
