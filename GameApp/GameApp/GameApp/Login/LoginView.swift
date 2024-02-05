//
//  LoginView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import UIKit

class LoginView: UIView {
    
    // MARK: properties
    
    private let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
        private let emailTextField: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
        private let passwordTextField: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: inits
    
    init() {
        super.init(frame: CGRectZero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: helpers
    
    private func configureUI() {
        self.backgroundColor = Color.darkBlue
        
        addSubview(loginImageView)
        
        NSLayoutConstraint.activate([
            loginImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
    }

}
