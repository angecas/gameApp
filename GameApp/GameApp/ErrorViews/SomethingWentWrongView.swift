//
//  SomethingWentWrongView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 27/02/2024.
//

import Foundation
import UIKit

class SomethingWentWrongView: UIView {
    
    // MARK: - Props
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.fall")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var somethingWentWrongLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops... Something went wrong!"
        label.font = Font.subHeadingFont
        label.textColor = Color.blueishWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - inits
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupLayout() {
        addSubview(imageView)
        addSubview(somethingWentWrongLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            somethingWentWrongLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            somethingWentWrongLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            somethingWentWrongLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

        ])
    }
}
