//
//  SplashScreenViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//
import UIKit

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
        setupUI()
        perform(#selector(showMainViewController), with: nil, afterDelay: 2.0)
    }

    // MARK: - Helpers

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
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
        animation.values = [-10.0, 10.0, -8.0, 8.0, -6.0, 6.0, -4.0, 4.0, 0.0]
        animation.duration = 1
        splashImageView.layer.add(animation, forKey: "shake")
    }

}
