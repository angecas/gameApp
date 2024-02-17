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

    private lazy var splashImageView: UIImageView = {
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
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.authenticatUserAndSeteUI()
            self.showRootViewController()

        }
    }

    // MARK: - Helpers
    private func showRootViewController() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let rootViewController = sceneDelegate.determineRootViewController()
            rootViewController.modalPresentationStyle = .fullScreen
            self.present(rootViewController, animated: true, completion: nil)
        }
    }

    
    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        view.addSubview(splashImageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SharedHelpers().shakeView(uiView: self.splashImageView)
        }

        NSLayoutConstraint.activate([
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.heightAnchor.constraint(equalToConstant: 85),
            splashImageView.widthAnchor.constraint(equalToConstant: 85),
        ])
    }
    /*
    private func authenticatUserAndSeteUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        } else {            
            if UserDefaultsHelper.getSelectedGenre() != nil {
                if let selectedGenredId = UserDefaultsHelper.getSelectedGenre() {
                    
                    DispatchQueue.main.async {
                        let mainViewController = GenresViewController()
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        
                        navigationController.pushViewController(GamesViewController(id: selectedGenredId), animated: false)
                        navigationController.modalPresentationStyle = .fullScreen
                        
                        self.present(navigationController, animated: true, completion: nil)
                    }
                }
            } else {
               DispatchQueue.main.async {
                   let navigationController = UINavigationController(rootViewController: GenresViewController())
                   navigationController.modalPresentationStyle = .fullScreen
                   self.present(navigationController, animated: true)
               }
           }
        }
    }
    */
    
    
//    private func createMainTabBarController(_ selectedGenreId: Int) -> UIViewController {
//
//        let tabBarController = UITabBarController()
//
//        let genresViewController = GenresViewController()
//
//        let favoritesViewController = FavoritesViewController()
//        let profileViewController = ProfileViewController()
//
//        tabBarController.viewControllers = [genresViewController, favoritesViewController, profileViewController]
//
//        return tabBarController
//    }

}
