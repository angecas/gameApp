//
//  GameHeaderView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 12/02/2024.
//

import UIKit
import SDWebImage

class GameHeaderView: UIView {
    
    // MARK: - Props

    let image: String?
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - inits
    
    init(image: String?) {
        self.image = image
        super.init(frame: .zero)
        
        headerImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        headerImage.sd_setImage(with: URL(string: image ?? ""))
        
        setupLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupLayout() {
        addSubview(headerImage)
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: topAnchor),
            headerImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
        
}
